import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/support/screens/support_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class RefundRequestSendSuccessBottomSheet extends StatelessWidget {
  final String? parcelId;
  const RefundRequestSendSuccessBottomSheet({super.key, required this.parcelId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius:const BorderRadius.only(topRight: Radius.circular(Dimensions.paddingSizeLarge), topLeft: Radius.circular(Dimensions.paddingSizeLarge))
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          InkWell(onTap: ()=> Get.back(),
            child: Align(alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).hintColor.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Image.asset(Images.crossIcon,height: 10,width: 10),
              ),
            ),
          ),

          Image.asset(Images.refundRequestSendSuccessIcon,height: 110),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text('refund_request_send_successfully'.tr,style: textSemiBold),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text.rich(TextSpan(
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)),
              children:  [
                TextSpan(text:'your_parcel'.tr,
                  style: textMedium.copyWith(
                    color: Theme.of(context).colorScheme.secondaryFixedDim,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),

                TextSpan(text: ' #${Get.find<RideController>().tripDetails?.refId} ',style: textMedium.copyWith(
                  color: Theme.of(context).colorScheme.secondaryFixedDim,
                  fontSize: Dimensions.fontSizeSmall,
                )),

                TextSpan(
                  text: 'refund_request_have_been_successfully'.tr,
                  style: textMedium.copyWith(
                    color: Theme.of(context).colorScheme.secondaryFixedDim,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                )
              ],
            ),textAlign: TextAlign.center),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          InkWell(
            onTap: ()=> Get.to(()=> const HelpAndSupportScreen()),
            child: Text('contact_with_admin'.tr,style: textBold.copyWith(
                decoration: TextDecoration.underline,
                color: Theme.of(context).colorScheme.surfaceContainer,
              decorationColor: Theme.of(context).colorScheme.surfaceContainer,
            )),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtremeLarge),
        ]),
      ),
    );
  }
}
