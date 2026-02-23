import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ConfirmationBottomsheetWidget extends StatelessWidget {
  final String icon;
  final String? title;
  final String? description;
  final Function onYesPressed;
  final bool isLogOut;
  final Function? onNoPressed;
  final bool isLoading;
  final Color? iconColor;
  const ConfirmationBottomsheetWidget({
    super.key, required this.icon, this.title, this.description, required this.onYesPressed,
    required this.onNoPressed, this.isLogOut = false, this.isLoading = false, this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.paddingSizeDefault), topLeft: Radius.circular(Dimensions.paddingSizeDefault))
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Container(
          height: 50, width: 50,
          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(50)
          ),
          child: Image.asset(icon, color: iconColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        if(title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              title ?? '', textAlign: TextAlign.center,
              style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ) ,

        if(description != null)
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(top: Dimensions.paddingSizeSmall),
            child: Text(description ?? '', style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
          ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15).copyWith(bottom: Dimensions.paddingSizeLarge),
          child: isLoading ?
          Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
          Row(children: [
            Expanded(child: TextButton(
              onPressed: () => isLogOut ? onYesPressed() : onNoPressed != null ? onNoPressed!() : Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).disabledColor.withValues(alpha:0.3),
                minimumSize: const Size(Dimensions.webMaxWidth, 40),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
              ),
              child: Text(
                isLogOut ? 'yes'.tr : 'no'.tr,
                textAlign: TextAlign.center, style: textBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
            )),
            const SizedBox(width: Dimensions.paddingSizeLarge),


            Expanded(child: ButtonWidget(
              buttonText: isLogOut ? 'no'.tr : 'yes'.tr,
              onPressed: () => isLogOut ? Get.back() : onYesPressed(),
              radius: Dimensions.radiusSmall, height: 40,
            )),

          ]),
        )
      ]),
    );
  }
}
