import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/my_offer/controller/offer_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class OfferTypeButtonWidget extends StatelessWidget {
  final int index;
  final String offerTypeName;
  const OfferTypeButtonWidget({super.key, required this.index, required this.offerTypeName});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfferController>(builder: (offerController) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
        child: InkWell(
          onTap: ()=> offerController.currentTabIndex == index ? null :
          offerController.setCurrentTabIndex(index, isUpdate: true),
          child: Container(
            width: MediaQuery.of(context).size.width/2.5,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              border: Border.all(
                width: .5,
                color: index == offerController.currentTabIndex ?
                Theme.of(context).colorScheme.onSecondary: Theme.of(context).hintColor,
              ),
              color: index == offerController.currentTabIndex ?
              Theme.of(context).primaryColor : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment : CrossAxisAlignment.center,children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  offerTypeName.tr,
                  textAlign: TextAlign.center,
                  style: textSemiBold.copyWith(
                      color : index == offerController.currentTabIndex ?
                      Colors.white :
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
