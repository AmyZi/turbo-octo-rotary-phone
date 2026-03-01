import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/map/widget/custom_icon_card.dart';
import 'package:ride_sharing_user_app/features/map/widget/discount_coupon_bottomsheet.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/widgets/safety_alert_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/parcel_expendable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/payment/screens/payment_screen.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/ride_expendable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


enum MapScreenType{ride, splash, parcel, location}

class MapScreen extends StatefulWidget {
  final MapScreenType fromScreen;
  final bool isShowCurrentPosition;
  const MapScreen({super.key, required this.fromScreen, this.isShowCurrentPosition = true});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver{
  GoogleMapController? _mapController;
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey<ExpandableBottomSheetState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Get.find<MapController>().setContainerHeight((widget.fromScreen == MapScreenType.parcel) ? 200 : 260, false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.resumed){
      _setMapCurrentRoutes();
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    Get.find<MapController>().mapController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(
        canPop: Navigator.canPop(context),
        onPopInvokedWithResult: (didPop, value){
          if(didPop){
            Future.delayed(const Duration(milliseconds: 500)).then((onValue){
              if(Get.find<RideController>().currentRideState.name == AppConstants.findingRider ||
                  Get.find<ParcelController>().currentParcelState.name == AppConstants.findingRider){
                Get.offAll(()=> const DashboardScreen());
              }
            });

          }else{
            Get.offAll(()=> const DashboardScreen());
          }
        },
        child: Scaffold(resizeToAvoidBottomInset: false,
          body: GetBuilder<RideController>(builder: (rideController){
            return Stack(children: [
              BodyWidget(topMargin: 0,
                appBar: AppBarWidget(
                  title: widget.fromScreen == MapScreenType.parcel ? 'your_parcel'.tr : _getAppbarTitle(rideController),
                  subTitle: widget.fromScreen == MapScreenType.parcel ? null : rideController.isLoading ? 'refreshing_date'.tr : _getAppbarSubTitle(rideController),
                  centerTitle: true,
                  onBackPressed: () {
                    if(Navigator.canPop(context)) {
                      if(Get.find<RideController>().currentRideState.name == AppConstants.findingRider ||
                          Get.find<ParcelController>().currentParcelState.name == AppConstants.findingRider){
                        Get.offAll(()=> const DashboardScreen());
                      }else{
                        Get.back();
                      }

                    }else {
                      Get.offAll(()=> const DashboardScreen());
                    }
                  },
                ),
                body: GetBuilder<MapController>(builder: (mapController) {
                  return ExpandableBottomSheet(key: key,
                    background: GetBuilder<RideController>(builder: (rideController) {
                      return Stack(children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: mapController.sheetHeight - 20),
                          child: GoogleMap(
                              style: Get.isDarkMode ?
                              Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                              initialCameraPosition:  CameraPosition(
                                target:  rideController.tripDetails?.pickupCoordinates != null ?
                                LatLng(
                                  rideController.tripDetails!.pickupCoordinates!.coordinates![1],
                                  rideController.tripDetails!.pickupCoordinates!.coordinates![0],
                                ) :
                                Get.find<LocationController>().initialPosition,
                                zoom: 16,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                mapController.mapController = controller;
                                if(
                                rideController.currentRideState.name == AppConstants.findingRider ||
                                    rideController.currentRideState.name == AppConstants.riseFare
                                ){
                                  mapController.initializeData();
                                  mapController.setOwnCurrentLocation(
                                      LatLng(
                                        rideController.tripDetails!.pickupCoordinates!.coordinates![1],
                                        rideController.tripDetails!.pickupCoordinates!.coordinates![0],
                                      )
                                  );
                                }else if(rideController.currentRideState.name == AppConstants.initial){
                                  mapController.getPolyline();
                                }else if(rideController.currentRideState.name == AppConstants.completeRide){
                                  mapController.initializeData();
                                }else{
                                  mapController.initializeData();
                                  mapController.setMarkersInitialPosition();
                                  rideController.startLocationRecord();
                                }
                                _mapController = controller;
                              },
                              minMaxZoomPreference: const MinMaxZoomPreference(0, AppConstants.mapZoom),
                              markers: Set<Marker>.of(mapController.markers),
                              polylines: Set<Polyline>.of(mapController.polylines.values),
                              zoomControlsEnabled: false,
                              compassEnabled: false,
                              trafficEnabled: mapController.isTrafficEnable,
                              indoorViewEnabled: true,
                              mapToolbarEnabled: true,
                          ),
                        ),

                        if(widget.isShowCurrentPosition)
                          Positioned(bottom: Get.height * 0.34, right: 0,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GetBuilder<LocationController>(builder: (locationController) {
                                return CustomIconCard(
                                  icon: Images.currentLocation,
                                  iconColor: Theme.of(context).primaryColor,
                                  onTap: () async {
                                    await locationController.getCurrentLocation(mapController: _mapController);
                                    await _mapController?.moveCamera(CameraUpdate.newCameraPosition(
                                      CameraPosition(target: Get.find<LocationController>().initialPosition, zoom: 16),
                                    ));
                                  },
                                );
                              }),
                            ),
                          ),

                        Positioned(bottom: Get.height * 0.40, right:0,
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: CustomIconCard(
                                icon: mapController.isTrafficEnable ?
                                Images.trafficOnlineIcon : Images.trafficOfflineIcon,
                                iconColor: mapController.isTrafficEnable ?
                                Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).hintColor,
                                onTap: () => mapController.toggleTrafficView(),
                              )
                          ),
                        ),

                        if(_isShowCouponButton(rideController))
                          Positioned(
                              bottom: Get.height * 0.46, right:0,
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: CustomIconCard(
                                    icon: Images.offerMapIcon,iconColor: Theme.of(context).colorScheme.inverseSurface,
                                    onTap: (){
                                      Get.bottomSheet(
                                        const DiscountAndCouponBottomSheet(),
                                        backgroundColor: Theme.of(context).cardColor,isDismissible: false,
                                      );
                                    },
                                  )
                              )
                          ),

                        if(_isSafetyFeatureActive())
                          Positioned(bottom: Get.height * 0.52, right:0,
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: JustTheTooltip(
                                    backgroundColor: Get.isDarkMode ?
                                    Theme.of(context).primaryColor :
                                    Theme.of(context).textTheme.bodyMedium!.color,
                                    controller: rideController.justTheController,
                                    preferredDirection: AxisDirection.right,
                                    tailLength: 10,
                                    tailBaseWidth: 20,
                                    content: Container(width: 130,
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                      child: Text(
                                        'safety_alert_sent'.tr,
                                        style: textRegular.copyWith(
                                          color: Colors.white, fontSize: Dimensions.fontSizeSmall,
                                        ),
                                      ),
                                    ),
                                    child: GetBuilder<SafetyAlertController>(builder: (safetyAlertController){
                                      return CustomIconCard(
                                        icon: safetyAlertController.currentState == SafetyAlertState.afterSendAlert ?
                                        Images.shieldCheckIcon :
                                        Images.safelyShieldIcon2,
                                        backGroundColor: safetyAlertController.currentState == SafetyAlertState.afterSendAlert ?
                                        Colors.red : null,
                                        onTap: (){
                                          Get.bottomSheet(
                                            isScrollControlled: true,
                                            const SafetyAlertBottomSheetWidget(),
                                            backgroundColor: Theme.of(context).cardColor,isDismissible: false,
                                          );
                                        },
                                      );
                                    }),
                                  )
                              )

                          ),
                      ]);
                    }),
                    persistentContentHeight: mapController.sheetHeight,

                    expandableContent: Column(mainAxisSize: MainAxisSize.min, children: [
                      widget.fromScreen == MapScreenType.parcel ?
                      GetBuilder<RideController>(builder: (parcelController) {
                        return ParcelExpendableBottomSheet(expandableKey: key);
                      }) :
                      (widget.fromScreen == MapScreenType.ride || widget.fromScreen == MapScreenType.splash) ?
                      GetBuilder<RideController>(builder: (rideController) {
                        return RideExpendableBottomSheet(expandableKey: key);
                      }) :
                      const SizedBox(),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom),

                    ]),
                  );
                }),
              ),

              widget.fromScreen == MapScreenType.location ?
              Positioned(
                child: Align(alignment: Alignment.bottomCenter,
                  child: SizedBox(height: 70, child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: ButtonWidget(buttonText: 'set_location'.tr, onPressed: () => Get.back()),
                  )),
                ),
              ) :
              const SizedBox(),

            ]);
          }),
        ),
      ),
    );
  }

  bool _isSafetyFeatureActive(){
    return ((Get.find<ConfigController>().config?.safetyFeatureStatus ?? false) &&
    (Get.find<RideController>().currentRideState.name == AppConstants.ongoingRide) &&
        Get.find<RideController>().tripDetails?.type != AppConstants.parcel) ? true : false;
  }

  String _getAppbarTitle(RideController rideController){
    if(rideController.currentRideState == RideState.initial){
      return 'chose_a_vehicle'.tr;
    }else if(rideController.currentRideState == RideState.outForPickup || rideController.currentRideState == RideState.otpSent){
      return 'oth_the_way_to_pickup'.tr;
    }else if(rideController.currentRideState == RideState.ongoingRide){
      return 'ongoing'.tr;
    }else if(rideController.currentRideState == RideState.riseFare){
      return 'rise_fare'.tr;
    }else if(rideController.currentRideState == RideState.findingRider){
      return 'finding_rider'.tr;
    }else{
      return 'your_trip'.tr;
    }
  }

  String? _getAppbarSubTitle(RideController rideController){
    if(rideController.currentRideState == RideState.ongoingRide || rideController.currentRideState == RideState.outForPickup || rideController.currentRideState == RideState.otpSent){
      return '${rideController.tripDetails?.type == AppConstants.parcel ? 'parcel'.tr : 'trip'.tr} #${rideController.tripDetails?.refId}';
    }else{
      return null;
    }
  }
}

bool _isShowCouponButton(RideController rideController){
  if((rideController.tripDetails?.type == AppConstants.parcel) && Get.find<ParcelController>().currentParcelState == ParcelDeliveryState.initial){
    return true;
  }else if((rideController.tripDetails?.type != AppConstants.parcel) && rideController.currentRideState == RideState.initial){
    return true;
  }else{
    return false;
  }
}

void _setMapCurrentRoutes(){
  RideController rideController = Get.find<RideController>();
  MapController mapController = Get.find<MapController>();

  rideController.getRideDetails(rideController.currentTripDetails!.id!).then((value) {
    if (value.statusCode == 200) {
      if(rideController.currentTripDetails!.type == AppConstants.parcel){
        if(rideController.currentTripDetails!.currentStatus == AppConstants.pending){
          Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.findingRider);
          mapController.getPolyline();

        }else if(rideController.currentTripDetails!.currentStatus == AppConstants.accepted){
          Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.otpSent);
          mapController.getPolyline();
          rideController.startLocationRecord();
          mapController.notifyMapController();

        }else if(rideController.currentTripDetails!.currentStatus == AppConstants.ongoing){
          Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelOngoing);
          mapController.getPolyline();
          rideController.startLocationRecord();
          mapController.notifyMapController();
          if(rideController.currentTripDetails!.parcelInformation?.payer == AppConstants.sender &&
              rideController.currentTripDetails!.paymentStatus == 'unpaid'){
            Get.off(()=>const PaymentScreen(fromParcel: true));
          }

        }else{

          Get.offAll(()=> const DashboardScreen());
        }

      }else{
        if(rideController.currentTripDetails!.currentStatus == AppConstants.pending){
          rideController.updateRideCurrentState(RideState.findingRider);
          mapController.getPolyline();

        }else if(rideController.currentTripDetails!.currentStatus == AppConstants.outForPickup){
          rideController.updateRideCurrentState(RideState.outForPickup);
          mapController.getPolyline();
          rideController.startLocationRecord();
          mapController.notifyMapController();

        }else if(rideController.currentTripDetails!.currentStatus == AppConstants.ongoing){
          rideController.updateRideCurrentState(RideState.ongoingRide);
          mapController.getPolyline();
          rideController.startLocationRecord();
          mapController.notifyMapController();

        }else if((rideController.currentTripDetails!.currentStatus == AppConstants.completed && rideController.currentTripDetails!.paymentStatus == AppConstants.unPaid)
            || (rideController.currentTripDetails!.currentStatus == AppConstants.cancelled && rideController.currentTripDetails!.paymentStatus == AppConstants.unPaid &&
                rideController.currentTripDetails!.paidFare! > 0)){
          Get.off(()=>const PaymentScreen(fromParcel: false));
        } else{
          Get.offAll(()=> const DashboardScreen());
        }
      }
    }
  });
}
