import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherEmergencyNumberWidget extends StatelessWidget {
  const OtherEmergencyNumberWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SafetyAlertController>(builder: (safetyAlertController){
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min, spacing: Dimensions.paddingSizeSmall, children: [
            Text('other_emergency_number'.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

            Text('here_a_list_of_number_that_you'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).hintColor)),

            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: safetyAlertController.otherEmergencyNumberModel?.data?.length ?? 0,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: ()=> launchUrl(Uri.parse("tel: ${safetyAlertController.otherEmergencyNumberModel?.data?[index].number}")),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(safetyAlertController.otherEmergencyNumberModel?.data?[index].title ?? ''),

                            Text(safetyAlertController.otherEmergencyNumberModel?.data?[index].number ?? '')
                          ]),

                          Image.asset(Images.circularCallIcon,height: 35,width: 35)
                        ]),
                      ),
                    );
                  },
                  separatorBuilder: (context, index){
                    return Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.3));
                  },
                ),
              ),
            )
          ]),
        ),
      );
    });
  }
}
