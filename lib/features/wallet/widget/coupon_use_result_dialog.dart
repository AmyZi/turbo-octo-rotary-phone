import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class CouponUserResultDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final String icon;
  final Function()? onTap;
  const CouponUserResultDialog({super.key, this.title, this.description, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {

    return Dialog(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
      child: Column(mainAxisSize: MainAxisSize.min,children: [
        Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge, top: Dimensions.paddingSizeOverLarge),
          child: SizedBox(width: Dimensions.iconSizeDoubleExtraLarge, child: Image.asset(icon))),

        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Text(title!.tr, style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color))),


       description != null? Text(description!):const SizedBox(),

        Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
          child: SizedBox(width: 80,child: ButtonWidget(buttonText: 'ok'.tr,
            radius: 10, onPressed: onTap)))
    ],),
    );
  }
}
