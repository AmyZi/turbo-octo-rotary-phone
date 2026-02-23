import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/widget/accepting_ongoing_bottomsheet.dart';
import 'package:ride_sharing_user_app/features/map/widget/initial_widget.dart';
import 'package:ride_sharing_user_app/features/map/widget/otp_sent_bottomsheet.dart';
import 'package:ride_sharing_user_app/features/map/widget/risefare_bottomsheet.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/finding_rider_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/features/payment/screens/payment_screen.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/confirmation_trip_dialog.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/rider_details.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_dialog_widget.dart';

class RideExpendableBottomSheet extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const RideExpendableBottomSheet({super.key, required this.expandableKey});

  @override
  State<RideExpendableBottomSheet> createState() => _RideExpendableBottomSheetState();
}

class _RideExpendableBottomSheetState extends State<RideExpendableBottomSheet> {
  bool isFinished = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius : const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.paddingSizeDefault),
            topRight : Radius.circular(Dimensions.paddingSizeDefault),
          ),
          boxShadow: [BoxShadow(
            color: Theme.of(context).hintColor,
            blurRadius: 5, spreadRadius: 1, offset: const Offset(0,2),
          )],
        ),
        child: Padding(
            padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child : Column(mainAxisSize: MainAxisSize.min, children: [
              Container(height: 7, width: 70, decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              )),

              const Padding(
                padding:  EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall,
                  Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
              ),

              GetBuilder<LocationController>(builder: (locationController) {
                String firstRoute = '';
                String secondRoute = '';
                List<dynamic> extraRoute = [];
                if(rideController.tripDetails?.intermediateAddresses != null && rideController.tripDetails?.intermediateAddresses != '["",""]') {
                  extraRoute = jsonDecode(rideController.tripDetails!.intermediateAddresses!);
                  if(extraRoute.isNotEmpty) {
                    firstRoute = extraRoute[0].toString();
                  }
                  if(extraRoute.isNotEmpty && extraRoute.length > 1) {
                    secondRoute = extraRoute[1].toString();
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    (rideController.currentRideState == RideState.initial) ?
                    InitialWidget(expandableKey: widget.expandableKey) :

                    (rideController.currentRideState == RideState.riseFare) ?
                    RaiseFareBottomSheet(expandableKey: widget.expandableKey) :

                    (rideController.currentRideState == RideState.findingRider) ?
                    FindingRiderWidget(expandableKey: widget.expandableKey, fromPage: FindingRide.ride) :

                    (rideController.currentRideState == RideState.outForPickup || rideController.currentRideState == RideState.ongoingRide) ?
                    AcceptingAndOngoingBottomSheet(
                      firstRoute: firstRoute,
                      secondRoute: secondRoute, expandableKey: widget.expandableKey,
                    ) :

                    (rideController.currentRideState == RideState.otpSent) ?
                    OtpSentBottomSheet(
                      firstRoute: firstRoute,
                      secondRoute: secondRoute,expandableKey: widget.expandableKey,
                    ):

                    (rideController.currentRideState == RideState.ongoingRide) ?
                    GestureDetector(
                      onTap: () {
                        showDialog(context: context, builder: (_) {
                          return ConfirmationDialogWidget(icon: Images.endTrip,
                            description: 'end_this_trip_at_your_destination'.tr, onYesPressed: () async {
                              Get.back();
                              Get.dialog(const ConfirmationTripDialog(isStartedTrip: false), barrierDismissible: false);
                              await Future.delayed( const Duration(seconds: 5));
                              Get.find<RideController>().stopLocationRecord();
                              rideController.updateRideCurrentState(RideState.completeRide);
                              Get.find<MapController>().notifyMapController();
                              Get.off(()=>const PaymentScreen());
                            },
                          );
                        });
                      },
                      child: Column(children: [
                        TollTipWidget(title: 'trip_is_ongoing'.tr),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                          child: Text.rich(TextSpan(
                            style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                            ),
                            children:  [
                              TextSpan(
                                text: "the_car_just_arrived_at".tr,
                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                              ),

                              TextSpan(text: " ".tr),

                              TextSpan(
                                text: "your_destination".tr,
                                style: textMedium.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          )),
                        ),

                        const ActivityScreenRiderDetails(),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                      ]),
                    ) :
                    const SizedBox(),

                  ]),
                );
              }),
            ])
        ),
      );
    });
  }
}
