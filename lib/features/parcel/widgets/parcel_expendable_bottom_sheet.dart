import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/map/widget/parcel_accept_rider_widget.dart';
import 'package:ride_sharing_user_app/features/map/widget/parcel_info_details_widget.dart';
import 'package:ride_sharing_user_app/features/map/widget/parcel_ongoing_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/features/map/widget/parcel_otp_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/choose_effificent_vehicle_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/finding_rider_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/parcel_details_input_view.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/sender_receiver_info_widget.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/rise_fare_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';

class ParcelExpendableBottomSheet extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelExpendableBottomSheet({super.key, required this.expandableKey});

  @override
  State<ParcelExpendableBottomSheet> createState() => _ParcelExpendableBottomSheetState();
}

class _ParcelExpendableBottomSheetState extends State<ParcelExpendableBottomSheet> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController) {
      return GetBuilder<RideController>(builder: (rideController) {
        return Container(width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius : const BorderRadius.only(
                topLeft: Radius.circular(Dimensions.paddingSizeDefault),
                topRight : Radius.circular(Dimensions.paddingSizeDefault),
              ),
              boxShadow: [BoxShadow(
                  color: Theme.of(context).hintColor,
                  blurRadius: 5, spreadRadius: 1, offset: const Offset(0,2)
              )],
            ),
            child: Padding(
              padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              child : Column(mainAxisSize: MainAxisSize.min, children: [
                Container(height: 7, width: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  ),
                ),

                const Padding(
                  padding:  EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                ),

                Padding(padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
                  child: Column(mainAxisSize: MainAxisSize.min, children:  [
                    (parcelController.currentParcelState == ParcelDeliveryState.initial) ?
                    SenderReceiverInfoWidget(expandableKey: widget.expandableKey) :
                    (parcelController.currentParcelState == ParcelDeliveryState.addOtherParcelDetails) ?
                    ParcelDetailInputView(expandableKey: widget.expandableKey) :
                    (parcelController.currentParcelState == ParcelDeliveryState.parcelInfoDetails) ?
                    ParcelInfoDetailsWidget(expandableKey: widget.expandableKey):

                    (parcelController.currentParcelState == ParcelDeliveryState.riseFare)?
                    RiseFareWidget(expandableKey: widget.expandableKey, fromPage: RiseFare.parcel) :
                    (parcelController.currentParcelState == ParcelDeliveryState.suggestVehicle)?
                    const ChooseEfficientVehicleWidget() :
                    (parcelController.currentParcelState == ParcelDeliveryState.findingRider)?
                    FindingRiderWidget(fromPage: FindingRide.parcel,expandableKey: widget.expandableKey) :
                    (parcelController.currentParcelState == ParcelDeliveryState.acceptRider)?
                    ParcelAcceptedRideWidget(expandableKey: widget.expandableKey):
                    (parcelController.currentParcelState == ParcelDeliveryState.otpSent) ?
                    ParcelOtpBottomSheetWidget(expandableKey: widget.expandableKey):
                    (parcelController.currentParcelState == ParcelDeliveryState.parcelOngoing) ?
                    ParcelOngoingBottomSheetWidget(expandableKey: widget.expandableKey) :
                    const SizedBox(),

                  ]),
                )

              ]),
            ),
          );
      });
    });
  }
}
