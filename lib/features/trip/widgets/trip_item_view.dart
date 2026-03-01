import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/domain/enums/refund_status_enum.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/payment/screens/payment_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class TripItemView extends StatefulWidget {
  final TripDetails tripDetails;
  const TripItemView({super.key, required this.tripDetails});

  @override
  State<TripItemView> createState() => _TripItemViewState();
}

class _TripItemViewState extends State<TripItemView> {


  @override
  void initState() {

    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(widget.tripDetails.currentStatus == AppConstants.accepted || widget.tripDetails.currentStatus == AppConstants.outForPickup ||
            widget.tripDetails.currentStatus == AppConstants.ongoing|| widget.tripDetails.currentStatus == AppConstants.pending){
          if(widget.tripDetails.type == AppConstants.parcel){
            _screenNavigationForParcel(widget.tripDetails);

          }else{
            if(widget.tripDetails.type == 'scheduled_request'){
              _screenNavigationForScheduleRide(widget.tripDetails);

            }else{
              _screenNavigationForRide(widget.tripDetails);

            }
          }

        }else{
          if(widget.tripDetails.currentStatus == AppConstants.completed && widget.tripDetails.paymentStatus == AppConstants.unPaid){
            Get.find<RideController>().getFinalFare(widget.tripDetails.id!).then((value){
              Get.to(()=> PaymentScreen(fromParcel: widget.tripDetails.type == AppConstants.parcel ? true : false));
            });

          }else{
            Get.to(()=> TripDetailsScreen(tripId: widget.tripDetails.id!));
          }
        }
      },
      child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Stack(children: [
            Container(width: 80, height: Get.height * 0.105,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.04) ,
              ),
              child: Center(child: Column(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    child: widget.tripDetails.type != AppConstants.parcel ?
                    ImageWidget(
                      width: 60, height: 60,
                      image : '${Get.find<ConfigController>().config!.imageBaseUrl!.vehicleCategory!}/${widget.tripDetails.vehicleCategory?.image!}',
                      fit: BoxFit.cover,
                    ) :
                    Image.asset(Images.parcel,height: 60,width: 30)
                ),

                Text(
                  widget.tripDetails.type != AppConstants.parcel ?
                  widget.tripDetails.vehicleCategory != null ?
                  widget.tripDetails.vehicleCategory!.name!
                      : '' :
                  AppConstants.parcel.tr,
                  style: textMedium.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.7),
                  ),
                ),
              ])),
            ),

            Positioned(
              right: 0,
              child: Container(
                height: 20,width: 20,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color:  widget.tripDetails.currentStatus == AppConstants.cancelled ?
                    Theme.of(context).colorScheme.error.withValues(alpha:0.15) :
                    widget.tripDetails.currentStatus == AppConstants.completed ?
                    Theme.of(context).colorScheme.surfaceTint.withValues(alpha:0.15) :
                    widget.tripDetails.currentStatus == 'returning' ?
                    Theme.of(context).colorScheme.surfaceContainer.withValues(alpha:0.15) :
                    widget.tripDetails.currentStatus == 'returned' ?
                    Theme.of(context).colorScheme.surfaceTint.withValues(alpha:0.15) :
                    Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha:0.3) ,
                    shape: BoxShape.circle
                ),
                child: widget.tripDetails.currentStatus == AppConstants.cancelled ?
                Image.asset(Images.crossIcon,color: Theme.of(context).colorScheme.error) :
                widget.tripDetails.currentStatus == AppConstants.completed ?
                Image.asset(Images.selectedIcon,color: Theme.of(context).colorScheme.surfaceTint) :
                widget.tripDetails.currentStatus == 'returning' ?
                Image.asset(Images.returnIcon,color: Theme.of(context).colorScheme.surfaceContainer) :
                widget.tripDetails.currentStatus == 'returned' ?
                Image.asset(Images.returnIcon,color: Theme.of(context).colorScheme.surfaceTint) :
                Image.asset(Images.ongoingMarkerIcon,color: Theme.of(context).colorScheme.tertiaryContainer),
              ),
            )
          ]),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text (
                  '${'trip_id'.tr}: ${widget.tripDetails.refId}',
                  style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyMedium?.color ,
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeThree)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Text(
                    DateConverter.isoStringToTripHistoryFormat(widget.tripDetails.createdAt!),
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).textTheme.bodyMedium?.color ,
                    ),
                  ),
                ),
              ]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(spacing: Dimensions.paddingSizeSmall, children: [
              if(widget.tripDetails.type != AppConstants.parcel)
              Image.asset(
                Images.activityDirection,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),height: 14,width: 14,
              ),

              Expanded(
                child: Text( widget.tripDetails.type == AppConstants.parcel ?
                widget.tripDetails.parcelInformation?.parcelCategoryName ?? '' :
                widget.tripDetails.destinationAddress ?? '',
                  style: textRegular.copyWith(
                    color: Get.isDarkMode ?
                    Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) :
                    Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.7),
                  ),overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            SizedBox(width: Get.width*0.6, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              widget.tripDetails.estimatedFare!= null ?
              Text(PriceConverter.convertPrice(
                (
                    widget.tripDetails.currentStatus == AppConstants.cancelled || widget.tripDetails.currentStatus == AppConstants.completed ||
                    (widget.tripDetails.parcelInformation?.payer == AppConstants.sender && widget.tripDetails.currentStatus == AppConstants.ongoing) ||
                    widget.tripDetails.currentStatus == 'returning' || widget.tripDetails.currentStatus == 'returned'
                ) ?
                  widget.tripDetails.paidFare! :
                ( widget.tripDetails.discountActualFare! > 0 ? widget.tripDetails.discountActualFare! : widget.tripDetails.actualFare!),
              ),
                style: textRobotoBold.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ) :
              const SizedBox(),

              if((widget.tripDetails.parcelRefund?.status == RefundStatus.pending || widget.tripDetails.parcelRefund?.status == RefundStatus.approved))
                Image.asset(Images.tripDetailsRefundIcon,height: 16,width: 16),

              if(widget.tripDetails.customerSafetyAlert != null)
                Image.asset(Images.safelyShieldIcon1,height: 16,width: 16)

            ]))
          ])),
        ]),
      ),
    );
  }

}

void _screenNavigationForParcel(TripDetails tripDetails){
  Get.find<RideController>().getRideDetails(tripDetails.id!).then((value) {
    if(tripDetails.currentStatus == AppConstants.accepted){
      Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.otpSent);
      Get.to(()=> const MapScreen(fromScreen: MapScreenType.parcel));

    }else if (tripDetails.currentStatus == AppConstants.ongoing){
      Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelOngoing);
      if(value.body['data']['parcel_information']['payer'] == AppConstants.sender &&
          value.body['data']['payment_status'] == AppConstants.unPaid){
        Get.off(()=>const PaymentScreen(fromParcel: true));

      }else{
        Get.to(()=> const MapScreen(fromScreen: MapScreenType.parcel));

      }
    }else{
      Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.findingRider);
      Get.to(()=> const MapScreen(fromScreen: MapScreenType.parcel));

    }
  });
}

void _screenNavigationForRide(TripDetails tripDetails){
  Get.find<RideController>().getRideDetails(tripDetails.id!).then((value){
    if(tripDetails.currentStatus == AppConstants.outForPickup){
      Get.find<RideController>().updateRideCurrentState(RideState.outForPickup);
    }else if (tripDetails.currentStatus == AppConstants.ongoing){
      Get.find<RideController>().updateRideCurrentState(RideState.ongoingRide);
    }else{
      Get.find<RideController>().updateRideCurrentState(RideState.findingRider);
    }
    Get.to(()=> const MapScreen(fromScreen: MapScreenType.ride));
  });
}

void _screenNavigationForScheduleRide(TripDetails tripDetails){
  Get.find<RideController>().getRideDetails(tripDetails.id!).then((value){
    if(tripDetails.currentStatus == AppConstants.outForPickup){
      Get.find<RideController>().updateRideCurrentState(RideState.outForPickup);
      Get.to(()=> const MapScreen(fromScreen: MapScreenType.ride));
    }else if (tripDetails.currentStatus == AppConstants.ongoing){
      Get.find<RideController>().updateRideCurrentState(RideState.ongoingRide);
      Get.to(()=> const MapScreen(fromScreen: MapScreenType.ride));
    }else{
      Get.to(()=> TripDetailsScreen(tripId: tripDetails.id ?? ''));
    }

  });
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
