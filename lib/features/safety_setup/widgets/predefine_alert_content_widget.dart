import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/widgets/safety_alert_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

import 'safety_radio_button.dart';

class PredefineAlertContentWidget extends StatefulWidget {
  final bool fromTripDetailsScreen;
  const PredefineAlertContentWidget({super.key, this.fromTripDetailsScreen = false});

  @override
  State<PredefineAlertContentWidget> createState() => _PredefineAlertContentWidgetState();
}

class _PredefineAlertContentWidgetState extends State<PredefineAlertContentWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SafetyAlertController>(builder: (safetyAlertController){
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Column(mainAxisSize: MainAxisSize.min,spacing: Dimensions.paddingSizeSmall, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('select_safety_alert_reason'.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

            Flexible(
              child: ListView.separated(
                itemCount: safetyAlertController.safetyAlertReasonModel?.data?.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      safetyAlertController.selectSafetyReason(index);
                    },
                    child: SafetyRadioButton(
                      isSelected: safetyAlertController.safetyAlertReasonModel?.data?[index].isActive ?? false ,
                      text: safetyAlertController.safetyAlertReasonModel?.data?[index].reason ?? '',
                    ),
                  );
                },
                separatorBuilder: (context, index){
                  return const SizedBox(height: Dimensions.paddingSizeSmall);
                },
              ),
            ),

            Text('comments'.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

            TextField(
              cursorColor: Theme.of(context).primaryColor,
              controller: controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  borderSide: BorderSide(width: 0.5, color: Theme.of(context).hintColor.withValues(alpha:0.5)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  borderSide: BorderSide(width: 0.5, color: Theme.of(context).hintColor.withValues(alpha:0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  borderSide: BorderSide(width: 0.5, color: Theme.of(context).hintColor.withValues(alpha:0.5)),
                ),
                hintText: 'type_here_your_safety_alert_reason'.tr,
                hintStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ),
              maxLines: 2,

            ),

            safetyAlertController.isStoring ?
            SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0):
            ButtonWidget(
              buttonText: 'send_alert'.tr,
              onPressed: (){
                safetyAlertController.storeSafetyAlert(controller.text).then((value){
                  if(value){
                    Get.back();
                    if(!widget.fromTripDetailsScreen){
                      Get.find<RideController>().showSafetyAlertTooltip();
                    }
                    Get.find<SafetyAlertController>().updateSafetyAlertState(SafetyAlertState.afterSendAlert,isUpdate: false);
                    Get.showSnackbar(GetSnackBar(
                      dismissDirection: DismissDirection.horizontal,
                      isDismissible: false,
                      duration: Duration(seconds: 15),
                      backgroundColor: Get.isDarkMode ? Colors.white : Theme.of(Get.context!).textTheme.titleMedium!.color!,
                      messageText: GetBuilder<SafetyAlertController>(builder: (safetyAlertController){
                        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(
                              '${'safety_alert_send_to'.tr} ${Get.find<ConfigController>().config?.businessName}',
                              style: textMedium.copyWith(color: Get.isDarkMode ? Theme.of(Get.context!).textTheme.titleMedium!.color : Colors.white, fontSize: Dimensions.fontSizeSmall)
                          ),

                          Row(spacing: Dimensions.paddingSizeSmall, children: [
                            InkWell(
                              onTap: (){
                                Get.back();
                                Get.bottomSheet(
                                  isScrollControlled: true,
                                  const SafetyAlertBottomSheetWidget(),
                                  backgroundColor: Theme.of(Get.context!).cardColor,isDismissible: false,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall ,horizontal: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(Get.context!).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                ),
                                child: Text('view'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              ),
                            ),

                            safetyAlertController.isLoading ?
                            CircularProgressIndicator(color: Theme.of(context).primaryColor) :
                            InkWell(
                              onTap: ()=> safetyAlertController.undoSafetyAlert(),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall ,horizontal: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(Get.context!).cardColor),
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                ),
                                child: Text('undo'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(Get.context!).cardColor)),
                              ),
                            )
                          ])

                        ]);
                      }),

                    ));
                  }
                });
              },
            ),

            Center(child: InkWell(
              onTap:()=> Get.find<SafetyAlertController>().updateSafetyAlertState(SafetyAlertState.initialState),
              child: Text(
                'go_back'.tr,
                style: textRegular.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).colorScheme.surfaceContainer,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
              ),
            )),
            const SizedBox(height: Dimensions.paddingSizeSmall)
          ]),
        ),
      );
    });
  }
}
