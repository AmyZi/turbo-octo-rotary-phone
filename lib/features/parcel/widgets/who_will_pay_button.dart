import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';

class WhoWillPayButton extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const WhoWillPayButton({super.key, required this.expandableKey});

  @override
  State<WhoWillPayButton> createState() => _WhoWillPayButtonState();
}

class _WhoWillPayButtonState extends State<WhoWillPayButton> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController){
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha:0.1),
        ),
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 3, 3, 3),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Image.asset(Images.parcel, width: 14),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text('who_will_pay'.tr,style: textRegular.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) : null)),
          ]),

          Row(children: [
            InkWell(
              onTap: () {
                parcelController.updatePaymentPerson(false);
                parcelController.focusOnBottomSheet(widget.expandableKey);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
                  color: parcelController.payReceiver?
                  Theme.of(context).colorScheme.onPrimary.withValues(alpha:0.1):
                  Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSeven,
                  vertical: Dimensions.paddingSizeSeven,
                ),
                child: Text(
                  'sender_pay'.tr,
                  style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: parcelController.payReceiver ?
                    Get.isDarkMode ?
                    Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.5) :
                    Theme.of(context).textTheme.bodyMedium!.color :
                    Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            InkWell(
              onTap: () {
                widget.expandableKey.currentState?.expand();
                parcelController.updatePaymentPerson(true);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
                  color: parcelController.payReceiver ?
                  Theme.of(context).primaryColor :
                  Theme.of(context).colorScheme.onPrimary.withValues(alpha:0.1),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeSeven,
                ),
                child: Text(
                  'receiver_pay'.tr, style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: !parcelController.payReceiver ?
                  Get.isDarkMode ?
                  Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.5) :
                  Theme.of(context).textTheme.bodyMedium!.color :
                  Colors.white,
                ),
                ),
              ),
            ),
          ])
        ]),
      );
    });
  }
}
