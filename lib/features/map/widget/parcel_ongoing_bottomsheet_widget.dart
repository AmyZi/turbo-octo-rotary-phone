import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/common_widgets/swipable_button_widget/slider_button_widget.dart';
import 'package:ride_sharing_user_app/features/map/widget/parcel_cancelation_list.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/estimated_fare_and_distance.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/rider_details.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelOngoingBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelOngoingBottomSheetWidget({super.key, required this.expandableKey});

  @override
  State<ParcelOngoingBottomSheetWidget> createState() => _ParcelOngoingBottomSheetWidgetState();
}

class _ParcelOngoingBottomSheetWidgetState extends State<ParcelOngoingBottomSheetWidget> {
  int currentState = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController){
      return GetBuilder<RideController>(builder: (rideController){
        return currentState == 0 ?
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          TollTipWidget(title: '${'drop_off'.tr} ${DateConverter.dateToTimeOnly(DateTime.now().add(Duration(seconds:rideController.remainingDistanceModel.isNotEmpty ? (rideController.remainingDistanceModel[0].durationSec ?? 0) : 0)))}'),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          const EstimatedFareAndDistance(isParcel: true),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          const ActivityScreenRiderDetails(),
          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Text('trip_details'.tr,style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColor),),),

          if(rideController.tripDetails != null)
            RouteWidget(totalDistance: rideController.estimatedDistance,
                fromAddress: rideController.tripDetails?.pickupAddress??'',
                toAddress: rideController.tripDetails?.destinationAddress??'',
                extraOneAddress: '',
                extraTwoAddress: '',
                entrance:  rideController.tripDetails?.entrance??''),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Center(child: SliderButton(
            action: (){
              currentState = 1;
              widget.expandableKey.currentState?.expand();
              setState(() {});
            },
            label: Text('cancel_parcel'.tr,style: TextStyle(color: Theme.of(context).colorScheme.error)),
            dismissThresholds: 0.5, dismissible: false, shimmer: false,
            width: 1170, height: 40, buttonSize: 40, radius: 20,
            icon: Center(child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).cardColor),
              child: Center(
                child: Icon(
                  Get.find<LocalizationController>().isLtr ? Icons.arrow_forward_ios_rounded : Icons.keyboard_arrow_left,
                  color: Colors.grey, size: 20.0,
                ),
              ),
            )),
            isLtr: Get.find<LocalizationController>().isLtr,
            boxShadow: const BoxShadow(blurRadius: 0),
            buttonColor: Colors.transparent,
            backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha:0.15),
            baseColor: Theme.of(context).primaryColor,
          ))

        ]) :
        currentState == 1 ?
        Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
          InkWell(
            onTap: (){
              setState(() {
                currentState = 0;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle
              ),
              margin: EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeSmall),
              padding: EdgeInsets.all(3),
              child: Icon(Icons.arrow_back_rounded,size: 18),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Text(
              Get.find<TripController>().parcelCancellationReasonList!.data!.ongoingRide!.length > 1 ?
              'please_select_your_cancel_reason'.tr : 'please_write_your_cancel_reason'.tr,
              style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ParcelCancellationList(isOngoing: true,expandableKey: widget.expandableKey),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          ButtonWidget(buttonText: 'next'.tr,
              showBorder: true,
              transparent: true,
              backgroundColor: Theme.of(context).primaryColor,
              borderColor: Theme.of(context).primaryColor,
              textColor: Theme.of(context).cardColor,
              radius: 50,
              onPressed: (){
                currentState = 2;
                setState(() {});
                widget.expandableKey.currentState?.expand(duration: 1000);
              })
        ]) :
        Column(children: [
          Text('return_fee_policy'.tr,style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: Dimensions.paddingSizeThree),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Text('if_you_cancel_your_parcel_will_back'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),textAlign: TextAlign.center),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text(PriceConverter.convertPrice(rideController.tripDetails?.returnFee ?? 0),style: textRobotoBold.copyWith(fontSize: 20)),
          const SizedBox(height: Dimensions.paddingSizeThree),

          Text('return_fee'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          ButtonWidget(buttonText: 'continue_delivery'.tr,
            showBorder: true,
            transparent: true,
            width: Get.width * 0.7,
            backgroundColor: Theme.of(context).primaryColor,
            borderColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).cardColor,
            radius: Dimensions.paddingSizeSmall,
            onPressed: (){
              currentState = 0;
              setState(() {});
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ButtonWidget(buttonText: 'yes_cancel'.tr,
            showBorder: true,
            transparent: true,
            width: Get.width * 0.7,
            textColor: Get.isDarkMode ? Colors.white : Colors.black,
            borderColor: Theme.of(context).primaryColor,
            radius: Dimensions.paddingSizeSmall,
            onPressed: (){
              Get.find<RideController>().stopLocationRecord();
              rideController.tripStatusUpdate(
                  rideController.tripDetails!.id!, 'cancelled', 'parcel_request_cancelled_successfully',
                  (Get.find<TripController>().parcelCancellationReasonList!.data!.ongoingRide!.length - 1) == Get.find<TripController>().parcelCancellationCauseCurrentIndex ?
                  Get.find<TripController>().othersCancellationController.text :
                  Get.find<TripController>().parcelCancellationReasonList!.data!.ongoingRide![Get.find<TripController>().parcelCancellationCauseCurrentIndex],
                  afterAccept: true
              ).then((value){
                if(rideController.tripDetails?.parcelInformation?.payer == 'receiver'){
                  rideController.getFinalFare(rideController.tripDetails!.id!);
                }
                Get.offAll(()=> TripDetailsScreen(tripId: rideController.tripDetails!.id!));
              });

            },
          )
        ]);
      });
    });
  }
}
