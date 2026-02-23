import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_dialog_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/common_widgets/swipable_button_widget/slider_button_widget.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/widget/parcel_cancelation_list.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/estimated_fare_and_distance.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/rider_details.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelAcceptedRideWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelAcceptedRideWidget({super.key, required this.expandableKey});

  @override
  State<ParcelAcceptedRideWidget> createState() => _ParcelAcceptedRideWidgetState();
}

class _ParcelAcceptedRideWidgetState extends State<ParcelAcceptedRideWidget> {
  int currentState = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController){
      return GetBuilder<RideController>(builder: (rideController){
        return currentState == 0 ?
        GestureDetector(onTap: () => Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.otpSent),
          child:  Column(children:  [
            const TollTipWidget(title: "rider_details"),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            const ActivityScreenRiderDetails(),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            if(rideController.tripDetails != null)
              RouteWidget(totalDistance: rideController.estimatedDistance,
                  fromAddress: rideController.tripDetails?.pickupAddress??'',
                  toAddress: rideController.tripDetails?.destinationAddress??'',
                  extraOneAddress: "",
                  extraTwoAddress: "",
                  entrance:  rideController.tripDetails?.entrance??''),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            const EstimatedFareAndDistance(),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Center(child: SliderButton(
              action: (){
                Get.dialog(ConfirmationDialogWidget(
                  isLoading: parcelController.isLoading,
                  icon: Images.cancelIcon,
                  description: 'are_you_sure'.tr,
                  onYesPressed: () {
                    Get.find<RideController>().stopLocationRecord();
                    Get.find<MapController>().notifyMapController();
                    rideController.tripStatusUpdate(rideController.tripDetails!.id!, 'cancelled', 'parcel_request_cancelled_successfully','').then((_){
                      Get.offAll(()=> TripDetailsScreen(tripId: rideController.tripDetails!.id!));
                    });

                    },
                ), barrierDismissible: false);
                },
              label: Text('cancel_parcel'.tr,style: TextStyle(color: Theme.of(context).colorScheme.error)),
              dismissThresholds: 0.5, dismissible: false, shimmer: false,
              width: 1170, height: 40, buttonSize: 40, radius: 20,
              icon: Center(child: Container(width: 36, height: 36,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                  ),
                  child: Center(child: Icon(
                    color: Colors.grey, size: 20.0,
                    Get.find<LocalizationController>().isLtr ? Icons.arrow_forward_ios_rounded : Icons.keyboard_arrow_left,
                  )),
              )),
              isLtr: Get.find<LocalizationController>().isLtr,
              boxShadow: const BoxShadow(blurRadius: 0),
              buttonColor: Colors.transparent,
              backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha:0.15),
              baseColor: Theme.of(context).primaryColor,
            )),

          ]),
        ):
        Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
          InkWell(
            onTap: (){
              setState(() {
                currentState = 0;
              });
            },
            child: const Padding(
              padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeSmall),
              child: Icon(Icons.arrow_back_rounded,size: 18),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Text(
                Get.find<TripController>().parcelCancellationReasonList!.data!.acceptedRide!.length > 1 ?
                'please_select_your_cancel_reason'.tr : 'please_write_your_cancel_reason'.tr,
                style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault)
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

           ParcelCancellationList(isOngoing: false,expandableKey: widget.expandableKey),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          ButtonWidget(buttonText: 'submit'.tr,
              showBorder: true,
              transparent: true,
              backgroundColor: Theme.of(context).primaryColor,
              borderColor: Theme.of(context).primaryColor,
              textColor: Theme.of(context).cardColor,
              radius: Dimensions.paddingSizeSmall,
              onPressed: (){
                Get.find<RideController>().stopLocationRecord();
                rideController.tripStatusUpdate(
                    rideController.tripDetails!.id!, 'cancelled', 'parcel_request_cancelled_successfully',
                    (Get.find<TripController>().parcelCancellationReasonList!.data!.acceptedRide!.length - 1) == Get.find<TripController>().parcelCancellationCauseCurrentIndex ?
                    Get.find<TripController>().othersCancellationController.text :
                    Get.find<TripController>().parcelCancellationReasonList!.data!.acceptedRide![Get.find<TripController>().parcelCancellationCauseCurrentIndex]
                ).then((_){
                  Get.offAll(()=> TripDetailsScreen(tripId: rideController.tripDetails!.id!));
                });

              })
        ]);
      });
    });
  }
}
