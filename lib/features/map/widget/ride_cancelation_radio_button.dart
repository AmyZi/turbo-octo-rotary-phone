import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:ride_sharing_user_app/common_widgets/custom_radio_button.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';

import 'package:ride_sharing_user_app/util/dimensions.dart';

import 'package:ride_sharing_user_app/util/styles.dart';


class CancellationRadioButton extends StatefulWidget {
  final bool isOngoing;
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const CancellationRadioButton({super.key, required this.isOngoing, required this.expandableKey});
  @override
  State<CancellationRadioButton> createState() => _CancellationRadioButtonState();

}

class _CancellationRadioButtonState extends State<CancellationRadioButton> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Text('why_do_you_want_to_cancel'.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
      const SizedBox(height: Dimensions.paddingSizeDefault),

      GetBuilder<TripController>(builder: (tripController){
        int length = widget.isOngoing ?
        tripController.rideCancellationReasonList!.data!.ongoingRide!.length :
        tripController.rideCancellationReasonList!.data!.acceptedRide!.length;
        return Column(children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.15)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: length,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context,index){
                  return CustomRadioButton(
                    text: widget.isOngoing ?
                    tripController.rideCancellationReasonList!.data!.ongoingRide![index] :
                    tripController.rideCancellationReasonList!.data!.acceptedRide![index],
                    isSelected: tripController.rideCancellationCauseCurrentIndex == index,
                    onTap: (){
                      tripController.setRideCancellationCurrentIndex(index);
                      setState(() {});
                      },
                  length: length,index: index,
                  );
                },
                separatorBuilder: (context,index){
                  return Divider(color: Theme.of(context).primaryColor.withValues(alpha:0.15),height: 0);
                },
              ),
            ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          TextField(
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
            tripController.rideCancellationReasonList!.data!.ongoingRide!.length-1 :
            tripController.rideCancellationReasonList!.data!.acceptedRide!.length -1) != tripController.rideCancellationCauseCurrentIndex,
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            onTap: () => Get.find<ParcelController>().focusOnBottomSheet(widget.expandableKey),
          )
        ]);
      }),
    ]);
  }
}