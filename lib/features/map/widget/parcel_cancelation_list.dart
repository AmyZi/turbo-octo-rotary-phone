import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/map/widget/parcel_custom_radio_button.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelCancellationList extends StatefulWidget {
  final bool isOngoing;
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelCancellationList({super.key, required this.isOngoing, required this.expandableKey});

  @override
  State<ParcelCancellationList> createState() => _ParcelCancellationListState();
}

class _ParcelCancellationListState extends State<ParcelCancellationList> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController) {
      return Column(children: [
        if((widget.isOngoing ?
        tripController.parcelCancellationReasonList!.data!.ongoingRide!.length :
        tripController.parcelCancellationReasonList!.data!.acceptedRide!.length) > 1)
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.isOngoing ?
          tripController.parcelCancellationReasonList!.data!.ongoingRide!.length :
          tripController.parcelCancellationReasonList!.data!.acceptedRide!.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return ParcelCustomRadioButton(
              text: widget.isOngoing ?
              tripController.parcelCancellationReasonList!.data!.ongoingRide![index] :
              tripController.parcelCancellationReasonList!.data!.acceptedRide![index],
              isSelected: tripController.parcelCancellationCauseCurrentIndex == index,
              onTap: () {
                tripController.setParcelCancellationCurrentIndex(index);
                setState(() {});
              },
            );
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge),
          child: TextField(
            cursorColor: Theme.of(context).primaryColor,
            controller: tripController.othersCancellationController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                borderSide: BorderSide(width: 0.5, color: Theme.of(context).hintColor.withValues(alpha:0.5)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                borderSide: BorderSide(width: 0.5, color: Theme.of(context).hintColor.withValues(alpha:0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                borderSide: BorderSide(width: 0.5, color: Theme.of(context).hintColor.withValues(alpha:0.5)),
              ),
              hintText: 'type_here_your_cancel_reason'.tr,
              hintStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
            ),
            maxLines: 2,
            readOnly: (widget.isOngoing ?
            tripController.parcelCancellationReasonList!.data!.ongoingRide!.length-1 :
            tripController.parcelCancellationReasonList!.data!.acceptedRide!.length -1) != tripController.parcelCancellationCauseCurrentIndex,
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            onTap: () => Get.find<ParcelController>().focusOnBottomSheet(widget.expandableKey),
          ),
        )
      ]);
    });
  }
}
