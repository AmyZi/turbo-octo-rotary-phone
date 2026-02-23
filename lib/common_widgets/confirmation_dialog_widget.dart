import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  final String icon;
  final String? title;
  final String description;
  final Function onYesPressed;
  final bool isLogOut;
  final Function? onNoPressed;
  final bool isLoading;
  const ConfirmationDialogWidget({super.key, required this.icon, this.title, required this.description, required this.onYesPressed,
    this.isLogOut = false, this.onNoPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(surfaceTintColor: Theme.of(context).cardColor,
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.none,
      child: SizedBox(width: 500, child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Stack(clipBehavior: Clip.none, children: [

            Positioned(top: -70, left: Get.width / 3.8,right: Get.width / 3.8,
              child: Container(decoration: BoxDecoration(color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(100)),
                child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Image.asset(icon, width: 50, height: 50, color: Theme.of(context).primaryColor),
                ),
              ),
            ),

            Column(mainAxisSize: MainAxisSize.min, children: [
              title != null ? Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Text(title ?? '', textAlign: TextAlign.center,
                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red))) : const SizedBox(),


              Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Text(description, style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center)),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              isLoading? Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)):
              Row(children: [Expanded(child: TextButton(
                  onPressed: () => isLogOut ? onYesPressed() : onNoPressed != null ? onNoPressed!() : Get.back(),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).disabledColor.withValues(alpha:0.3), minimumSize: const Size(Dimensions.webMaxWidth, 40),
                    padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall))),


                  child: Text(isLogOut ? 'yes'.tr : 'no'.tr, textAlign: TextAlign.center,
                    style: textBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)))),
                const SizedBox(width: Dimensions.paddingSizeLarge),


                Expanded(child: ButtonWidget(buttonText: isLogOut ? 'no'.tr : 'yes'.tr,
                  onPressed: () => isLogOut ? Get.back() : onYesPressed(),
                  radius: Dimensions.radiusSmall, height: 40)),
              ]),

            ]),
          ],
        ),
      )),
    );
  }
}
