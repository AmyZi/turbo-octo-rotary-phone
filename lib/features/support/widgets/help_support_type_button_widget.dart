
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/support/controllers/help_support_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class HelpSupportTypeButtonWidget extends StatelessWidget {
  final int index;
  final String profileTypeName;
  const HelpSupportTypeButtonWidget({super.key, required this.index, required this.profileTypeName});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HelpSupportController>(builder: (supportController) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
        child: InkWell(
          onTap: ()=> supportController.updateCurrentTabIndex(index, isUpdate: true),
          child: Container(
            width: MediaQuery.of(context).size.width/2.5,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              border: Border.all(
                width: .5,
                color: index == supportController.currentTabIndex ?
                Theme.of(context).colorScheme.onSecondary: Theme.of(context).primaryColor,
              ),
              color: index == supportController.currentTabIndex ?
              Theme.of(context).primaryColor : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment : CrossAxisAlignment.center,children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  profileTypeName.tr,
                  textAlign: TextAlign.center,
                  style: textSemiBold.copyWith(
                      color : index == supportController.currentTabIndex ?
                      Colors.white:
                      Theme.of(context).hintColor.withValues(alpha:.65), fontSize: Dimensions.fontSizeLarge),
                ),
              ),
            ],
            ),
          ),
        ),
      );
    });
  }
}
