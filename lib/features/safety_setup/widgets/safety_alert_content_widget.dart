import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetyAlertContentWidget extends StatelessWidget {
  const SafetyAlertContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(spacing: Dimensions.paddingSizeSmall,children: [
      Image.asset(Images.safelyShieldIcon3,height: 70,width: 70),

      Text('trip_safety'.tr,style: textBold),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
        child: Text('hey_there_do_you_feel_unsafe'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),textAlign: TextAlign.center),
      ),

      ButtonWidget(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
        buttonText: 'send_safety_alert'.tr,
        onPressed: ()=> Get.find<SafetyAlertController>().updateSafetyAlertState(SafetyAlertState.predefineAlert),
      ),

      if(Get.find<ConfigController>().config?.safetyFeatureEmergencyGovtNumber != null)
      ButtonWidget(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
        backgroundColor: Theme.of(context).cardColor,
        borderColor: Theme.of(context).primaryColor,
        showBorder: true,
        textColor: Theme.of(context).textTheme.bodyMedium!.color,
        buttonText: '${'call_emergency'.tr} (${Get.find<ConfigController>().config?.safetyFeatureEmergencyGovtNumber})',
        onPressed: (){
          launchUrl(Uri.parse("tel: ${Get.find<ConfigController>().config?.safetyFeatureEmergencyGovtNumber}"));
        },
      ),

      GetBuilder<SafetyAlertController>(builder: (safetyAlertController){
        return safetyAlertController.otherEmergencyNumberModel?.data != null && (safetyAlertController.otherEmergencyNumberModel?.data?.isNotEmpty ?? false) ?
        InkWell(
          onTap:()=> Get.find<SafetyAlertController>().updateSafetyAlertState(SafetyAlertState.otherNumberState),
          child: Text(
            'other_emergency_numbers'.tr,
            style: textRegular.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.surfaceContainer,
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
          ),
        ) :
        const SizedBox();
      }),
      const SizedBox(height: Dimensions.paddingSizeSmall)
    ]);
  }
}
