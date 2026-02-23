import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class LoyaltyPointHelpWidget extends StatelessWidget {
  const LoyaltyPointHelpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor:Get.isDarkMode ? Theme.of(context).hintColor  : Theme.of(context).cardColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
          vertical: 10,
        ),
        child: SizedBox(width: Get.width,
          child: Column(mainAxisSize:MainAxisSize.min, children: [
            Align(alignment: Alignment.topRight,
              child: InkWell(onTap: ()=> Get.back(), child: Container(
                decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Image.asset(
                  Images.crossIcon,
                  height: Dimensions.paddingSizeSmall,
                  width: Dimensions.paddingSizeSmall,
                  color: Theme.of(context).cardColor,
                ),
              )),
            ),

            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text('how_to_use'.tr,style: textBold.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
            )),

            const SizedBox(height: Dimensions.paddingSizeSmall),
            Image.asset(Images.loyaltyPoint, height: 70, width: 70),

            const SizedBox(height: Dimensions.paddingSizeDefault),
            Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(margin:const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  height: 7,width: 7,
                  decoration: BoxDecoration(color: Theme.of(context).hintColor,
                    borderRadius:const BorderRadius.all(Radius.circular(100)),
                  ),
                ),

                Expanded(
                  child: Text('convert_your_loyalty_point_to_wallet_money'.tr,style: textRegular.copyWith(
                    color: Theme.of(context).hintColor,
                  )),
                )
              ],
            ),

            Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(margin:const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  height: 7,width: 7,decoration: BoxDecoration(color: Theme.of(context).hintColor,
                    borderRadius:const BorderRadius.all(Radius.circular(100)),
                  ),
                ),

                Expanded(child:
                 Text('${'minimum'.tr} ${Get.find<ConfigController>().config?.conversionRate}'
                     '${'points_required_to_convert_into_currency'.tr}',
                  style: textRegular.copyWith(color: Theme.of(context).hintColor),
                )),

              ],
            ),

          ]),
        ),
      ),
    );
  }
}
