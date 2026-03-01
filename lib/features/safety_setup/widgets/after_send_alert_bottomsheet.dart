import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/widgets/other_emergency_number_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class AfterSendAlertBottomSheet extends StatefulWidget {
  const AfterSendAlertBottomSheet({super.key});

  @override
  State<AfterSendAlertBottomSheet> createState() => _AfterSendAlertBottomSheetState();
}

class _AfterSendAlertBottomSheetState extends State<AfterSendAlertBottomSheet> {
  @override
  void initState() {
    Get.find<SafetyAlertController>().getSafetyAlertDetails(Get.find<RideController>().currentTripDetails?.id ?? Get.find<RideController>().rideDetails?.id ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SafetyAlertController>(builder: (safetyAlertController){
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Column(spacing: Dimensions.paddingSizeSmall,mainAxisSize: MainAxisSize.min, children: [
            Text('safety_alert_reason'.tr,style: textRegular.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.7),
                fontSize: Dimensions.fontSizeLarge
            )),

            if(safetyAlertController.customerAlertDetails?.data?.comment != null)
              Container(width: Get.width,
                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                ),
                child: Text(
                  '${safetyAlertController.customerAlertDetails?.data?.comment}',
                  style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),textAlign: TextAlign.center,
                ),
              ),

            Flexible(
              child: ListView.separated(
                itemCount: safetyAlertController.customerAlertDetails?.data?.reason?.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return Container(
                    padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                    ),
                    child: Text('${safetyAlertController.customerAlertDetails?.data?.reason?[index]}',style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),textAlign: TextAlign.center),
                  );
                },
                separatorBuilder: (context,index){
                  return const SizedBox(height: Dimensions.paddingSizeExtraSmall);
                },
              ),
            ),

            Text(
              safetyAlertController.customerAlertDetails?.data?.status != 'solved' ?
              'until_wow_you_cannot_your_safety'.tr :
              'your_safety_issue_solved'.tr,
              textAlign: TextAlign.center,
              style: textRegular.copyWith(
               color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.7),
                  fontSize: Dimensions.fontSizeSmall
              ),
            ),

            if(safetyAlertController.customerAlertDetails?.data?.status != 'solved')
              safetyAlertController.isLoading ?
              SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0) :
              ButtonWidget(
                buttonText: 'make_as_solved'.tr,
                onPressed: ()=> safetyAlertController.marAsSolveSafetyAlert(),
              ),

            if(safetyAlertController.customerAlertDetails?.data?.status != 'solved')
              safetyAlertController.isStoring ?
              SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0) :
              ButtonWidget(
                buttonText: 'resend_alert'.tr,
                textColor: Theme.of(context).textTheme.bodyMedium!.color,
                onPressed: ()=> safetyAlertController.resendSafetyAlert(),
                backgroundColor: Theme.of(context).cardColor,
                borderColor: Theme.of(context).primaryColor,
                showBorder: true,
              ),

            if(Get.find<ConfigController>().config?.safetyFeatureEmergencyGovtNumber != null)
            InkWell(
              onTap: ()=> launchUrl(Uri.parse("tel: ${Get.find<ConfigController>().config?.safetyFeatureEmergencyGovtNumber}")),
              child: Row(mainAxisSize:MainAxisSize.min, spacing: Dimensions.paddingSizeExtraSmall, children: [
                Image.asset(Images.customerCall,height: 18,width: 18,color: Theme.of(context).colorScheme.surfaceContainer),

                Text(
                  '${'call'.tr} (${Get.find<ConfigController>().config?.safetyFeatureEmergencyGovtNumber})',
                  style: textRegular.copyWith(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                ),
              ]),
            ),

            GetBuilder<SafetyAlertController>(builder: (safetyAlertController){
              return safetyAlertController.otherEmergencyNumberModel?.data != null && (safetyAlertController.otherEmergencyNumberModel?.data?.isNotEmpty ?? false) ?
              InkWell(
                onTap:(){
                  Get.back();
                  Get.bottomSheet(
                    isScrollControlled: true,
                    Padding(
                      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
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

                        const  OtherEmergencyNumberWidget()
                      ]),
                    ),
                    backgroundColor: Theme.of(Get.context!).cardColor,isDismissible: false,
                  );
                },
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
          ]),
        ),
      );
    });
  }
}
