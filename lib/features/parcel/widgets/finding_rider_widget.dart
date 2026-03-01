import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/common_widgets/swipable_button_widget/slider_button_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';

enum FindingRide{ride, parcel}

class FindingRiderWidget extends StatefulWidget {
  final FindingRide fromPage;
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const FindingRiderWidget({super.key, required this.fromPage, required this.expandableKey});

  @override
  State<FindingRiderWidget> createState() => _FindingRiderWidgetState();
}

class _FindingRiderWidgetState extends State<FindingRiderWidget> {

  bool isSearching = true;

  @override
  void initState() {
    //Call Here ---->>>>mapController.getPolyline(); ///TODO

    Get.find<RideController>().countingTimeStates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){
      return GetBuilder<ParcelController>(builder: (parcelController){
         return Padding(
           padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
           child: isSearching ?
           Column(children: [
            TollTipWidget(
              title: rideController.tripDetails?.type == 'parcel' ?
              'finding_deliveryman' : 'rider_finding',
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(width: MediaQuery.of(context).size.width *0.27,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.withValues(alpha:.50),
                    color: Theme.of(context).primaryColor,value: rideController.firstCount,
                  ),
              ),

              SizedBox(width: MediaQuery.of(context).size.width *0.27,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.withValues(alpha:.50),
                    color: Theme.of(context).primaryColor,value: rideController.secondCount,
                  ),
              ),

              SizedBox(width: MediaQuery.of(context).size.width *0.27,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.withValues(alpha:.50),
                    color: Theme.of(context).primaryColor,value: rideController.thirdCount,
                  ),
              ),
            ]),

            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeDefault
              ),
              child: Image.asset(
                rideController.stateCount  == 3 ? Images.newBidFareIcon : Images.findRiderIcon, width: 70,
              ),
            ),

            Text(
              widget.fromPage == FindingRide.parcel ?
                'finding_deliveryman'.tr :
                rideController.stateCount  == 0 ?
                'searching_for_rider'.tr :
                rideController.stateCount == 1 ?
                'please_wait_just_for_a_moment'.tr :
                rideController.stateCount == 2 ?
                'looks_like_riders_around_you_are_busy_now'.tr :
                'looks_like_riders_around_you_are_not_interested'.tr,
              style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
              textAlign: TextAlign.center,
            ),

            (rideController.stateCount  == 2 || widget.fromPage == FindingRide.parcel) ?
            Text('please_hold_on_a_little_more'.tr,
              style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
            ):
            const SizedBox(),

            if(rideController.stateCount  != 3 && widget.fromPage == FindingRide.ride)
            const SizedBox(height: Dimensions.paddingSizeLarge * 2),

            if(rideController.stateCount  == 3 && widget.fromPage == FindingRide.ride)...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical:Dimensions.paddingSizeDefault,
                  horizontal:Dimensions.paddingSizeExtraOverLarge,
                ),
                child: ButtonWidget(
                  buttonText: 'keep_searching'.tr,
                  onPressed: (){
                    widget.expandableKey.currentState?.contract();
                    rideController.initCountingTimeStates(isRestart: true);
                  },
                  backgroundColor: Colors.grey.withValues(alpha:0.25),
                  radius: 10,
                  textColor: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeExtraOverLarge ,
                  right: Dimensions.paddingSizeExtraOverLarge ,
                  bottom: Dimensions.paddingSizeDefault,
                ),
                child: ButtonWidget(
                  buttonText: rideController.tripDetails?.type == AppConstants.scheduleRequest ? 'cancel'.tr : 'rise_fare'.tr,
                  backgroundColor: rideController.tripDetails?.type == AppConstants.scheduleRequest ?
                  Theme.of(context).colorScheme.error.withValues(alpha: 0.2) : Theme.of(context).primaryColor,
                  textColor: rideController.tripDetails?.type == AppConstants.scheduleRequest ? Theme.of(context).colorScheme.error : null,
                  onPressed: (){
                   if(rideController.tripDetails?.type == AppConstants.scheduleRequest){
                     _cancelRideRequest(rideController);
                   }else{
                     rideController.updateRideCurrentState(RideState.riseFare);
                   }

                  },
                  radius: 10,
                ),
              ),
            ],

            if(widget.fromPage == FindingRide.parcel)
              const SizedBox(height: Dimensions.paddingSizeDefault),

            !(rideController.stateCount  == 3 && widget.fromPage == FindingRide.ride) ?
            Center(child: SliderButton(
                action: (){
                  isSearching = false;
                  widget.expandableKey.currentState?.expand();
                  setState(() {});
                },
                label: Text(
                  'cancel_searching'.tr,style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                dismissThresholds: 0.5, dismissible: false, shimmer: false,
                width: 1170, height: 40, buttonSize: 40, radius: 20,
                icon: Center(child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                  child: Center(child: Icon(
                      Get.find<LocalizationController>().isLtr ?
                      Icons.arrow_forward_ios_rounded :
                      Icons.keyboard_arrow_left,
                      color: Colors.grey, size: 20.0,
                    )),
                )),
                isLtr: Get.find<LocalizationController>().isLtr,
                boxShadow: const BoxShadow(blurRadius: 0),
                buttonColor: Colors.transparent,
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha:0.15),
                baseColor: Theme.of(context).primaryColor,
              )) :
            const SizedBox(),
          ]) :
           Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Image.asset(Images.cancelRideIcon, width: 70),
            ),

            Text('are_you_sure'.tr, style: textMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),

            Text('you_want_to_cancel_searching'.tr, style: textMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).hintColor,
            )),

            rideController.isLoading ?
             Padding(
              padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
            ) :
            Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical:Dimensions.paddingSizeDefault,
                  horizontal:Dimensions.paddingSizeExtraOverLarge,
                ),
                child: ButtonWidget(
                  buttonText: 'keep_searching'.tr,
                  onPressed: (){
                    widget.expandableKey.currentState?.contract();
                    isSearching = true;
                    setState(() {});
                    rideController.initCountingTimeStates(isRestart: true);
                  },
                  backgroundColor: Colors.grey.withValues(alpha:0.25),
                  radius: 10,
                  textColor: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeExtraOverLarge ,
                  right: Dimensions.paddingSizeExtraOverLarge ,
                  bottom: Dimensions.paddingSizeDefault,
                ),
                child: ButtonWidget(
                  buttonText: 'cancel_searching'.tr,
                  onPressed: (){
                    widget.expandableKey.currentState?.contract();

                    _cancelRideRequest(rideController);
                  },
                  radius: 10,
                ),
              ),

            ]),

            if(rideController.isLoading)
              const SizedBox(height: Dimensions.paddingSizeSignUp),

          ]),
         );
      });
    });
  }

}

void _cancelRideRequest(RideController rideController){
  rideController.tripStatusUpdate(rideController.tripDetails!.id!,'cancelled', 'ride_request_cancelled_successfully','',).then((value){
    if(value.statusCode == 200){
      rideController.updateRideCurrentState(RideState.initial);
      Get.find<MapController>().notifyMapController();
      Get.find<RideController>().clearRideDetails();
      Get.find<BottomMenuController>().navigateToDashboard();

    }
  });
}
