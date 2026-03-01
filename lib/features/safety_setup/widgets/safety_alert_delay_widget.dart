import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/safety_setup/widgets/safety_alert_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SafetyAlertDelayWidget extends StatelessWidget {
  const SafetyAlertDelayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius:const BorderRadius.only(
              topRight: Radius.circular(Dimensions.paddingSizeLarge),
              topLeft: Radius.circular(Dimensions.paddingSizeLarge),
            )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Column(spacing: Dimensions.paddingSizeSmall, mainAxisSize: MainAxisSize.min, children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Image.asset(Images.crossIcon,height: 10,width: 10,color: Get.isDarkMode ? Colors.white : null),
                ),
              ),
            ),
            Image.asset(Images.safetyAlarmIcon,height: 70,width: 70),

            Text('safety_check_in'.tr,style: textSemiBold),

            Text(_typeWiseConvertTime(
              (Get.find<ConfigController>().config?.safetyFeatureMinimumTripDelayTime ?? 0),
              (Get.find<ConfigController>().config?.safetyFeatureMinimumTripDelayTimeType ?? ''),
            ),
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              textAlign: TextAlign.center,
            ),

            ButtonWidget(
              buttonText: 'yes_need_safety'.tr,
              onPressed: (){
                Get.back();
                Get.bottomSheet(
                  isScrollControlled: true,
                  const SafetyAlertBottomSheetWidget(fromTripDetailsScreen: true),
                  backgroundColor: Theme.of(context).cardColor,isDismissible: false,
                );
              },
            ),

            ButtonWidget(
              buttonText: 'skip_for_now'.tr,
              textColor: Theme.of(context).primaryColor,
              onPressed: () => Get.back(),
              backgroundColor: Theme.of(context).cardColor,
              borderColor: Theme.of(context).primaryColor,
              showBorder: true,
            )
          ]),
        ),
      ),
    );
  }

  String _typeWiseConvertTime(int time, String type){
    int calculateTime = 0;
    if(type == 'second'){
      calculateTime = time;
    }else if(type == 'minute'){
      calculateTime = (time/60).toInt();
    }else{
      calculateTime = (time/3600).toInt();
    }

    return '${'we_notice_that_you_are_stuck_at_a_place'.tr}$calculateTime'
        ' ${(Get.find<ConfigController>().config?.safetyFeatureMinimumTripDelayTimeType ?? '').tr} ${'if_you_face_any_safety_issue'.tr}';
  }
}
