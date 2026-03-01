import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/ride_category.dart';
import 'package:ride_sharing_user_app/features/set_destination/widget/input_field_for_set_route.dart';
import 'package:ride_sharing_user_app/features/set_destination/widget/pick_location_widget.dart';
import 'package:ride_sharing_user_app/features/set_destination/widget/pickup_time_date_widget.dart';
import 'package:ride_sharing_user_app/features/set_destination/widget/process_button_widget.dart';
import 'package:ride_sharing_user_app/features/set_destination/widget/reservation_note_widget.dart';
import 'package:ride_sharing_user_app/helper/route_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/view/pick_map_screen.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/divider_widget.dart';
import 'dart:math' as math;

class SetDestinationScreen extends StatefulWidget {
  final Address? address;
  final String? searchText;
  final RideType rideType;
  const SetDestinationScreen({super.key, this.address,this.searchText, this.rideType = RideType.regularRide});

  @override
  State<SetDestinationScreen> createState() => _SetDestinationScreenState();
}

class _SetDestinationScreenState extends State<SetDestinationScreen> {
  FocusNode pickLocationFocus = FocusNode();
  FocusNode destinationLocationFocus = FocusNode();
  ScrollController scrollController = ScrollController();
  double dialogTopPosition = 0;
  double bottomWhiteSpace = 0;
  var keyboardVisibilityController = KeyboardVisibilityController();
  late StreamSubscription<bool> keyboardSubscription;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    Get.find<RideController>().setRideType(widget.rideType);
    Get.find<LocationController>().initAddLocationData();
    Get.find<LocationController>().initTextControllers();
    Get.find<RideController>().clearExtraRoute();
    Get.find<MapController>().initializeData();
    Get.find<RideController>().initData();
    Get.find<ParcelController>().updatePaymentPerson(false, notify: false);
    Get.find<LocationController>().setPickUp(Get.find<LocationController>().getUserAddress());

    if(widget.address != null) {
      Get.find<LocationController>().setDestination(widget.address);
    }
    if(widget.searchText != null){
      Get.find<LocationController>().setDestination(Address(address: widget.searchText));
      Future.delayed(const Duration(seconds: 1)).then((_){
        Get.find<LocationController>().searchLocation(Get.context!, widget.searchText ?? '', type: LocationType.to);
      });
    }

    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      if(!visible){
        bottomWhiteSpace = 0;
      }
    });

  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(top: false, child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<RideController>(builder: (rideController){
        return BodyWidget(
          appBar: AppBarWidget(
            title: rideController.rideType == RideType.scheduleRide ? 'schedule_trip_setup'.tr : 'trip_setup'.tr, centerTitle: true,
            onBackPressed: () {
              if(Navigator.canPop(context)) {
                Get.back();
              }else {
                Get.offAll(()=> const DashboardScreen());
              }
            },
          ),
          body: GetBuilder<LocationController>(builder: (locationController) {
            return Stack(clipBehavior: Clip.none, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall,
                ),
                child: SingleChildScrollView(controller: scrollController, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,children: [
                  RideCategoryWidget(),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  PickupTimeDateWidget(),

                  Text('set_your_location'.tr, style: textSemiBold),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    ),
                    child: Column(children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _LocationFromToWidget(),

                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            PickLocationWidget(
                              locationType: LocationType.from,
                              rideDetails: rideController.rideDetails,
                              focusNode: pickLocationFocus,
                              textEditingController: locationController.pickupLocationController,
                              isShowCrossButton: false,
                              textFieldHint: 'pick_location'.tr,
                              locationIconTap: (){
                                RouteHelper.goPageAndHideTextField(context, PickMapScreen(
                                    type: LocationType.from,
                                    address: locationController.fromAddress
                                ));
                              },
                              textFieldTap: (){
                                setScrollAndDialogPosition(LocationType.from, locationController);
                              },
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall,),
                              child: Text('to'.tr, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color)),
                            ),

                            if(locationController.extraOneRoute)
                              PickLocationWidget(
                                locationType: LocationType.extraOne,
                                textFieldHint: 'extra_route_one'.tr,
                                rideDetails: rideController.rideDetails,
                                focusNode: null,
                                textEditingController: locationController.extraRouteOneController,
                                isShowCrossButton: true,
                                locationIconTap: (){
                                  RouteHelper.goPageAndHideTextField(context, PickMapScreen(
                                      type: LocationType.extraOne,
                                      address: locationController.extraRouteAddress
                                  ));
                                },
                                textFieldTap: (){
                                  setScrollAndDialogPosition(LocationType.extraOne, locationController);
                                },
                              ),

                            SizedBox(height: locationController.extraOneRoute ? Dimensions.paddingSizeDefault : 0),

                            if(locationController.extraTwoRoute)
                              PickLocationWidget(
                                locationType: LocationType.extraTwo,
                                textFieldHint: 'extra_route_two'.tr,
                                rideDetails: rideController.rideDetails,
                                focusNode: null,
                                textEditingController: locationController.extraRouteTwoController,
                                isShowCrossButton: true,
                                locationIconTap: (){
                                  RouteHelper.goPageAndHideTextField(context, PickMapScreen(
                                      type: LocationType.extraTwo,
                                      address: locationController.extraRouteTwoAddress
                                  ));
                                },
                                textFieldTap: (){
                                  setScrollAndDialogPosition(LocationType.extraTwo, locationController);
                                },
                              ),

                            SizedBox(height: locationController.extraTwoRoute ? Dimensions.paddingSizeDefault : 0),

                            Row(children: [
                              Expanded(child: PickLocationWidget(
                                locationType: LocationType.to,
                                textFieldHint: 'destination'.tr,
                                rideDetails: rideController.rideDetails,
                                focusNode: destinationLocationFocus,
                                textEditingController: locationController.destinationLocationController,
                                isShowCrossButton: false,
                                locationIconTap: (){
                                  RouteHelper.goPageAndHideTextField(context, PickMapScreen(
                                      type: LocationType.to,
                                      address: locationController.toAddress
                                  ));
                                },
                                textFieldTap: (){
                                  setScrollAndDialogPosition(LocationType.to, locationController);
                                },
                              )),

                              SizedBox(width: locationController.extraTwoRoute ? 0 : Dimensions.paddingSizeSmall),

                              if(!(!Get.find<ConfigController>().config!.addIntermediatePoint! || locationController.extraTwoRoute))
                                InkWell(
                                  onTap: () => locationController.setExtraRoute(),
                                  child: Container(
                                    height: 35,width: 35,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                    ),
                                    child: const Icon(Icons.add, color: Colors.white),
                                  ),
                                ),
                            ]),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            locationController.addEntrance ?
                            SizedBox(width: 200, height: 40, child: InputField(
                              showSuffix: false,
                              controller: locationController.entranceController,
                              node: locationController.entranceNode,
                              hint: 'enter_entrance'.tr,
                            )) :
                            InkWell(
                              onTap: () => locationController.setAddEntrance(),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                SizedBox(height: 30, child: Transform(
                                  alignment: Alignment.center,
                                  transform: Get.find<LocalizationController>().isLtr ?
                                  Matrix4.rotationY(0) :
                                  Matrix4.rotationY(math.pi),
                                  child: Image.asset(Images.curvedArrow,color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.7)),
                                )),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Row(crossAxisAlignment: CrossAxisAlignment.end,children: [
                                  Icon(Icons.add, color: Theme.of(context).primaryColor,size: 16),

                                  Padding(
                                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                                    child: Text(
                                      'add_entrance'.tr,
                                      style: textRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall,),
                                    ),
                                  ),
                                ]),
                              ]),
                            ),
                          ]),
                        )),
                      ]),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          Dimensions.paddingSizeExtraLarge, 0,
                          Dimensions.paddingSizeExtraLarge,Dimensions.paddingSizeSmall,
                        ),
                        child: Text(
                          'you_can_add_multiple_route_to'.tr,
                          style: textRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ]),
                  ),

                  if(rideController.rideType == RideType.scheduleRide)
                    ReservationNoteWidget(globalKey: _key),

                  SizedBox(height: bottomWhiteSpace)
                ])),
              ),

              if(locationController.resultShow)
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: InkWell(
                    onTap: () => locationController.setSearchResultShowHide(show: false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ?
                        Theme.of(context).canvasColor :
                        Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                      ),
                      margin: EdgeInsets.fromLTRB(30, dialogTopPosition, 30, 0),
                      child: ListView.builder(
                        itemCount: locationController.predictionList?.data?.suggestions?.length ?? 0,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          return  InkWell(
                            onTap: () {
                              pickLocationFocus.unfocus();
                              destinationLocationFocus.unfocus();
                              Get.find<LocationController>().setLocation(
                                fromSearch: true,
                                locationController.predictionList?.data?.suggestions?[index].placePrediction?.placeId ?? '',
                                locationController.predictionList?.data?.suggestions?[index].placePrediction?.text?.text ?? '', null,
                                type: locationController.locationType,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeDefault,
                                horizontal: Dimensions.paddingSizeSmall,
                              ),
                              child: Row(children: [
                                const Icon(Icons.location_on),

                                Expanded(child: Text(
                                  locationController.predictionList?.data?.suggestions?[index].placePrediction?.text?.text ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                    color: Theme.of(context).textTheme.bodyLarge!.color,
                                    fontSize: Dimensions.fontSizeDefault,
                                  ),
                                )),
                              ]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ) ,
            ]);
          }),
        );
      }),
      bottomNavigationBar: ProcessButtonWidget(
        pickLocationFocus: pickLocationFocus,
        destinationLocationFocus: destinationLocationFocus,
      ),
    ));
  }

  void setScrollAndDialogPosition(LocationType locationType, LocationController locationController){

    scrollController.jumpTo(MediaQuery.of(context).size.height + Get.height * 0.3);
    bottomWhiteSpace = Get.find<RideController>().rideType == RideType.scheduleRide ? (Get.height * 0.4 -  (_key.currentContext?.size?.height ?? 0)) : Get.height * 0.4;

    if(locationType == LocationType.from) {
      dialogTopPosition = Get.height * 0.2;
    }else if(locationType == LocationType.extraOne) {
      dialogTopPosition = locationController.extraTwoRoute ? Get.height * 0.18 : Get.height * 0.23;
    }else if(locationType == LocationType.extraTwo) {
      dialogTopPosition = Get.height * 0.23;
    }else if(locationType == LocationType.to) {
      dialogTopPosition = Get.height * 0.28;
    }
    setState(() {});
  }
}

class _LocationFromToWidget extends StatelessWidget {
  const _LocationFromToWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,Dimensions.paddingSizeLarge, 0, 0),
      child: Column(children: [
        SizedBox(
          width: Dimensions.iconSizeLarge,
          child: Image.asset(
            Images.currentLocation,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),

        SizedBox(height: 60, width: 10, child: CustomDivider(
          height: 5, dashWidth: .75,
          axis: Axis.vertical,
          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5),
        )),

        SizedBox(
          width: Dimensions.iconSizeMedium,
          child: Transform(
            alignment: Alignment.center,
            transform: Get.find<LocalizationController>().isLtr ?
            Matrix4.rotationY(0) :
            Matrix4.rotationY(math.pi),
            child: Image.asset(
              Images.activityDirection,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
        ),
      ]),
    );
  }
}
