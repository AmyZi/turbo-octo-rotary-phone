import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/payment/screens/payment_screen.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelItem extends StatelessWidget {
  final TripDetails rideRequest;
  final int index;
  const ParcelItem({super.key, required this.rideRequest, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController){
      return GetBuilder<RideController>(builder: (rideController) {
        return InkWell(
          onTap: (){
            parcelController.setParcelLoadingActive(index);
            if(rideRequest.currentStatus == AppConstants.accepted){
              Get.find<RideController>().getRideDetails(rideRequest.id!).then((value){
                if(value.statusCode == 200){
                  parcelController.setParcelLoadingDeactive(index);
                  Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.otpSent);
                  Get.find<RideController>().startLocationRecord();
                  Get.find<MapController>().notifyMapController();
                  Get.to(() => const MapScreen(fromScreen: MapScreenType.parcel));
                }
              });
            }else if(rideRequest.currentStatus == "returning" && rideRequest.type == AppConstants.parcel){
              rideController.getRideDetails(rideRequest.id!).then((value){
                Get.to(()=> TripDetailsScreen(tripId: rideRequest.id!,fromNotification: true));
              });
            }else{
              if(rideRequest.paymentStatus == AppConstants.paid){
                rideController.getFinalFare(rideRequest.id!).then((value) {
                  if(value.statusCode == 200){
                    rideController.getRideDetails(rideRequest.id!).then((value){
                      if(value.statusCode == 200){
                        Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelOngoing);
                        Get.find<RideController>().startLocationRecord();
                        parcelController.setParcelLoadingDeactive(index);
                        Get.to(()=> const MapScreen(fromScreen: MapScreenType.parcel));
                      }
                    });
                  }
                });

              }else{
                if(rideRequest.parcelInformation!.payer == AppConstants.sender && rideRequest.driver != null){
                  rideController.getFinalFare(rideRequest.id!).then((value) {
                    if(value.statusCode == 200){
                      rideController.getRideDetails(rideRequest.id!).then((value){
                        if(value.statusCode == 200){
                          Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelOngoing);
                          Get.find<RideController>().startLocationRecord();
                          parcelController.setParcelLoadingDeactive(index);
                          Get.off(()=>const PaymentScreen(fromParcel: true));
                        }
                      });
                    }
                  });
                }else{
                  if(rideRequest.driver != null){
                    rideController.getRideDetails(rideRequest.id!).then((value){
                      if(value.statusCode == 200){
                        Get.find<MapController>().getPolyline();
                        Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelOngoing);
                        parcelController.setParcelLoadingDeactive(index);
                        Get.to(() => const MapScreen(fromScreen: MapScreenType.parcel));
                      }
                    });
                  }else{
                    rideController.getRideDetails(rideRequest.id!);
                    Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.findingRider);
                    Get.find<RideController>().startLocationRecord();
                    Get.find<MapController>().notifyMapController();
                    parcelController.setParcelLoadingDeactive(index);
                    Get.to(() => const MapScreen(fromScreen: MapScreenType.parcel));
                  }
                }
              }
            }
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
                      rideRequest.currentStatus == AppConstants.pending ?
                      Images.searchImageIcon :
                      Images.parcel,
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('${'parcel'.tr} # ${rideRequest.refId}',style: textMedium),

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
                        rideRequest.currentStatus == AppConstants.pending ? 'searching_driver'.tr : rideRequest.currentStatus == 'returning' ?'returning'.tr : 'on_the_way'.tr,
                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                      ),
                    )
                  ]),

                  Text(DateConverter.isoStringToDateTimeString(rideRequest.createdAt!),
                    style: textRegular.copyWith(
                      color: Theme.of(context).hintColor.withValues(alpha:.85),
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),

                  Text('${'total'.tr} ${PriceConverter.convertPrice(
                      (rideRequest.parcelInformation?.payer == AppConstants.sender && rideRequest.currentStatus == AppConstants.ongoing) ?
                      rideRequest.paidFare! :
                      rideRequest.discountActualFare! > 0 ?
                      rideRequest.discountActualFare! : rideRequest.actualFare!
                  )}',style: textRobotoRegular),
                ])),
              ]),
            ),
          ),
        );
      });
    });
  }

}
