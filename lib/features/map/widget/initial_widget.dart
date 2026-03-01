import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_text_field.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/fare_input_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/ride_category.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/trip_fare_summery.dart';
import 'package:ride_sharing_user_app/features/set_destination/widget/schedule_date_time_picker_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/ride_controller_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class InitialWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const InitialWidget({super.key, required this.expandableKey});

  @override
  State<InitialWidget> createState() => _InitialWidgetState();
}

class _InitialWidgetState extends State<InitialWidget> {
//  String? zoneExtraFareReason;


  @override
  void initState() {
    var rideController = Get.find<RideController>();
    if(Get.find<PaymentController>().paymentType == 'wallet' &&
        (rideController.discountAmount.toDouble() > 0 ? rideController.discountFare : rideController.estimatedFare) >
            Get.find<ProfileController>().profileModel!.data!.wallet!.walletBalance!
    ){
      Get.find<PaymentController>().setPaymentType(0);
    }
  //  zoneExtraFareReason = _getExtraFairReason(Get.find<ConfigController>().config?.zoneExtraFare, Get.find<LocationController>().zoneID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){
      return GetBuilder<LocationController>(builder: (locationController){
        return Column(mainAxisSize: MainAxisSize.min, children:  [
          RideCategoryWidget(onTap:(value) async {
            if(rideController.isCouponApplicable){
              await Future.delayed(const Duration(milliseconds: 500));
              widget.expandableKey.currentState?.expand(duration: 1000);
            }else{
              widget.expandableKey.currentState?.contract(duration: 500);
              widget.expandableKey.currentState?.expand(duration: 1000);
            }

          }),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
            ),
            padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
            child: Row(spacing: Dimensions.paddingSizeSmall, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('pickup_time'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

              InkWell(
                onTap: (){
                  if(Get.find<ConfigController>().config?.scheduleTripStatus ?? false){
                    Get.bottomSheet(const ScheduleDateTimePickerWidget(),enableDrag: false, isScrollControlled: true);
                  }
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6, // Limit width to 60% of screen
                  ),
                  child: Row(spacing: Dimensions.paddingSizeExtraSmall, mainAxisSize: MainAxisSize.min, children: [
                    Image.asset(
                      rideController.rideType == RideType.scheduleRide ?
                        Images.scheduleCalenderIcon : Images.clockIcon,
                        height: 14,width: 14,
                    ),

                    Flexible(
                      child: Text(
                        rideController.rideType == RideType.scheduleRide ?
                        '${'schedule'.tr}: ${
                            DateFormat('d MMM y').format(RideControllerHelper.dateFormatToShow(rideController.scheduleTripDate))}, '
                            '${DateFormat('hh:mm a').format(RideControllerHelper.timeFormatToShow(rideController.scheduleTripTime))}' :
                        'pickup_now'.tr,
                        style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall, overflow: TextOverflow.ellipsis),
                      ),
                    ),

                    if(rideController.rideType == RideType.regularRide)
                      Icon(Icons.keyboard_arrow_down_outlined)
                  ]),
                ),
              )
            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          RouteWidget(
            totalDistance: rideController.fareList.isEmpty ? '0' :
            rideController.fareList[rideController.rideCategoryIndex].estimatedDistance ?? '0',
            fromAddress: locationController.fromAddress?.address??'',
            extraOneAddress: locationController.extraRouteAddress?.address ?? '',
            extraTwoAddress: locationController.extraRouteTwoAddress?.address ?? '',
            toAddress: locationController.toAddress?.address??'',
            entrance: locationController.entranceController.text,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          if(rideController.fareList[rideController.rideCategoryIndex].extraFareReason != '') ...[
            Text('${'fares_are_a_bit_higher'.tr}${rideController.fareList[rideController.rideCategoryIndex].extraFareReason}', style: textRegular.copyWith(color: Theme.of(context).colorScheme.inverseSurface,fontSize: 11), textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          ],

          const SizedBox(height: Dimensions.paddingSizeSmall),

          TripFareSummery(
            tripFare: rideController.estimatedFare, fromParcel: false,
            discountFare: rideController.discountFare, discountAmount: rideController.discountAmount,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          if(rideController.isCouponApplicable)...[
            Align(alignment: Alignment.centerRight,
              child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: Dimensions.paddingSizeExtraSmall,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha:0.15),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  ),
                  child: Text('coupon_applied'.tr,style: textBold.copyWith(color: Theme.of(context).primaryColor))
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
          ],

          CustomTextField(
            prefix: false,
            borderRadius: Dimensions.radiusSmall,
            hintText: "add_note".tr,
            controller: rideController.noteController,
            onTap: () async{
              await Future.delayed(const Duration(milliseconds: 500));
              widget.expandableKey.currentState?.expand(duration: 1000);
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          rideController.isLoading || rideController.isSubmit ?
          Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
          (Get.find<ConfigController>().config!.bidOnFare! && rideController.rideType != RideType.scheduleRide) ?
          FareInputWidget(
            expandableKey: widget.expandableKey,
            fromRide: true,
            fare: rideController.discountAmount.toDouble() > 0 ?
            rideController.discountFare.toString() :
            rideController.estimatedFare.toString(),
          ) :
          ButtonWidget(buttonText: "find_rider".tr, onPressed: () {
            if(rideController.rideType == RideType.regularRide) {
              _sendFindRiderRequest(rideController);
            }else{
              rideController.submitRideRequest(rideController.noteController.text, false).then((value){
                if(value.statusCode == 200){
                  Get.find<MapController>().initializeData();
                  showCustomSnackBar(
                      '${'your_trip'.tr} #${rideController.tripDetails?.refId} ${'has_been_successfully_scheduled'.tr}',
                      subMessage: 'you_will_be_notified_when_a_driver_start_for_your'.tr
                  );
                  Get.offAll(() =>  TripDetailsScreen(tripId: rideController.tripDetails?.id ?? ''));
                }
              });
            }
          }),
        ]);
      });
    });
  }

  // String? _getExtraFairReason(List<ZoneExtraFare>? list, String? zoneId){
  //   for(int i = 0; i < (list?.length ?? 0); i++) {
  //
  //     if(list?[i].zoneId == zoneId || list?[i].zoneId == 'all') {
  //       return list?[i].reason ?? '';
  //     }
  //   }
  //   return null;
  //
  // }

  void _sendFindRiderRequest(RideController rideController){
    rideController.submitRideRequest(rideController.noteController.text, false).then((value) {
      if (value.statusCode == 200) {
        Get.find<AuthController>().saveFindingRideCreatedTime();
        rideController.updateRideCurrentState(RideState.findingRider);
        Get.find<MapController>().initializeData();
        Get.find<MapController>().setOwnCurrentLocation(
            LatLng(
                Get.find<LocationController>().fromAddress?.latitude ?? 0,
                Get.find<LocationController>().fromAddress?.longitude ?? 0
            )
        );
        Get.find<MapController>().notifyMapController();
      }
    });
  }
}
