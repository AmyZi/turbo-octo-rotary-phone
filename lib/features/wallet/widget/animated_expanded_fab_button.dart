import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/wallet/widget/transfer_money_dialog_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';



 Widget animatedExpandedFabButton() => AnimatedContainer(
   duration:const Duration(milliseconds: 200),
   curve: Curves.linear,
   width: 150,height: 50,
   decoration: BoxDecoration(
       border: Border.all(color: Theme.of(Get.context!).primaryColor.withValues(alpha:0.5),width: 5),
       color: Theme.of(Get.context!).cardColor,
       borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtremeLarge)
   ),
   padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
   child: InkWell(
     onTap: (){
       Get.dialog(barrierDismissible: false, const TransferMoneyDialogWidget());
     },
     child: Row(children: [
       Image.asset(Images.transferMoneyIcon,height: 20,width: 20),
       const SizedBox(width: Dimensions.paddingSizeExtraSmall),

       Expanded(child: Text('transfer_money'.tr,style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall,overflow: TextOverflow.ellipsis)))
     ]),
   ),
 );
