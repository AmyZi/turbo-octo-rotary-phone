import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/payment/screens/payment_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class RideItemWidget extends StatelessWidget {
  final TripDetails? tripDetails;
  final int index;
  const RideItemWidget({super.key, required this.tripDetails, required this.index});

  @override
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
      return InkWell(
        onTap: (){
          rideController.getRideDetails(tripDetails?.id ?? '').then((value){
            _checkUserNeedSafety();

            if(rideController.tripDetails?.currentStatus == AppConstants.outForPickup || rideController.tripDetails?.currentStatus == AppConstants.ongoing) {
              rideController.updateRideCurrentState(rideController.tripDetails?.currentStatus == AppConstants.outForPickup ?  RideState.outForPickup : RideState.ongoingRide );
              rideController.startLocationRecord();
              Get.find<MapController>().notifyMapController();
              Get.to(() => const MapScreen(fromScreen: MapScreenType.splash));

            }else if(rideController.tripDetails?.currentStatus == AppConstants.accepted){
              Get.offAll(()=> TripDetailsScreen(tripId: tripDetails?.id ?? ''));

            } else if(rideController.tripDetails?.currentStatus == AppConstants.pending) {
              if(rideController.tripDetails?.type == 'ride_request'){
                Get.find<RideController>().updateRideCurrentState(RideState.findingRider);
                Get.find<RideController>().getBiddingList(tripDetails!.id!, 1);
                Get.find<MapController>().notifyMapController();
                Get.to(() => const MapScreen(fromScreen: MapScreenType.splash));

              }else{
                Get.to(() => TripDetailsScreen(tripId: tripDetails?.id ?? ''));
              }

            } else if (rideController.tripDetails?.currentStatus == AppConstants.completed || rideController.tripDetails?.currentStatus == AppConstants.cancelled) {
              if(rideController.tripDetails?.paymentStatus == 'unpaid'){
                rideController.getFinalFare(tripDetails?.id ?? '');
                Get.off(() => const PaymentScreen());
              }else{
                rideController.getRunningRideList();
              }
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeExtraSmall,
          ),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(
                  color: Theme.of(context).hintColor.withValues(alpha:.20),blurRadius: 1,
                  spreadRadius: 1,offset: const Offset(1,1),
                )]
            ),
            child: Row(children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha:.15),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                ),
                height: Dimensions.orderStatusIconHeight,width: Dimensions.orderStatusIconHeight,
                child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Image.asset(
                    tripDetails?.currentStatus == 'pending' ?
                    Images.searchImageIcon :
                    tripDetails!.vehicleCategory?.type == 'car' ? Images.car : Images.bike,
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${'trip'.tr} # ${tripDetails?.refId}',style: textMedium),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: Dimensions.paddingSizeExtraSmall,
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha:0.25),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                    ),
                    child: Text(
                      tripDetails?.currentStatus == 'pending' ? 'searching_driver'.tr : 'on_the_way'.tr,
                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                    ),
                  )
                ]),

                Text(DateConverter.isoStringToDateTimeString(tripDetails!.createdAt!),
                  style: textRegular.copyWith(
                    color: Theme.of(context).hintColor.withValues(alpha:.85),
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),

                Text('${'total'.tr} ${PriceConverter.convertPrice(
                    (tripDetails?.parcelInformation?.payer == 'sender' && tripDetails?.currentStatus == 'ongoing') ?
                    tripDetails!.paidFare! :
                    tripDetails!.discountActualFare! > 0 ?
                    tripDetails!.discountActualFare! : tripDetails!.actualFare!
                )}',style: textRobotoRegular),
              ])),
            ]),
          ),
        ),
      );
    });
  }
}

void _checkUserNeedSafety(){
  if(Get.find<RideController>().tripDetails?.currentStatus == 'ongoing'){
    if(Get.find<RideController>().tripDetails?.customerSafetyAlert != null){
      Get.find<SafetyAlertController>().updateSafetyAlertState(SafetyAlertState.afterSendAlert);
    }else{
      Get.find<RideController>().remainingDistance(Get.find<RideController>().tripDetails?.id ?? '');
      Get.find<SafetyAlertController>().checkDriverNeedSafety();
    }
  }
}