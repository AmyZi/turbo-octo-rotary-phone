import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/wallet/widget/transfer_money_dialog_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';


Widget animatedFabButton ()=> AnimatedContainer(
  duration:const Duration(milliseconds: 300),
  curve: Curves.linear,
  width: 50,height: 50,
  decoration: BoxDecoration(
      border: Border.all(color: Theme.of(Get.context!).primaryColor.withValues(alpha:0.5),width: 5),
      color: Theme.of(Get.context!).cardColor,
      borderRadius: BorderRadius.circular(100)
  ),
  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
  child: InkWell(
    onTap: (){
      Get.dialog(barrierDismissible: false, const TransferMoneyDialogWidget());
    },
    child: Image.asset(Images.transferMoneyIcon),
  ),
);