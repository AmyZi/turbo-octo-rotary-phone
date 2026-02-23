import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/widgets/after_send_alert_bottomsheet.dart';
import 'package:ride_sharing_user_app/features/safety_setup/widgets/other_emergency_number_widget.dart';
import 'package:ride_sharing_user_app/features/safety_setup/widgets/predefine_alert_content_widget.dart';
import 'package:ride_sharing_user_app/features/safety_setup/widgets/safety_alert_content_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';


class SafetyAlertBottomSheetWidget extends StatefulWidget {
  final bool fromTripDetailsScreen;
  const SafetyAlertBottomSheetWidget({super.key, this.fromTripDetailsScreen = false});

  @override
  State<SafetyAlertBottomSheetWidget> createState() => _SafetyAlertBottomSheetWidgetState();
}

class _SafetyAlertBottomSheetWidgetState extends State<SafetyAlertBottomSheetWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Get.find<SafetyAlertController>().getSafetyAlertReasonList();
    Get.find<SafetyAlertController>().getOthersEmergencyNumberList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
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
        child: GetBuilder<SafetyAlertController>(builder: (safetyAlertController){
          return Column(spacing: Dimensions.paddingSizeSmall,mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              safetyAlertController.currentState == SafetyAlertState.otherNumberState ?
              BackButton(
                onPressed: ()=> Get.find<SafetyAlertController>().updateSafetyAlertState(SafetyAlertState.initialState),
                color: Get.isDarkMode ? Colors.white : null,
              ) :
              const SizedBox(),

              InkWell(
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
            ]),

            safetyAlertController.currentState == SafetyAlertState.initialState ?
            SafetyAlertContentWidget() :
            safetyAlertController.currentState == SafetyAlertState.predefineAlert ?
            PredefineAlertContentWidget(fromTripDetailsScreen: widget.fromTripDetailsScreen) :
            safetyAlertController.currentState == SafetyAlertState.afterSendAlert ?
            AfterSendAlertBottomSheet() :
            OtherEmergencyNumberWidget()
          ]);
        })
      ),
    );
  }
}
