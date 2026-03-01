import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class TransferMoneyDialogWidget extends StatefulWidget {
  const TransferMoneyDialogWidget({super.key});

  @override
  State<TransferMoneyDialogWidget> createState() => _TransferMoneyDialogWidgetState();
}

class _TransferMoneyDialogWidgetState extends State<TransferMoneyDialogWidget> {
  final TextEditingController _balanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Theme.of(context).cardColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
      child: GetBuilder<WalletController>(builder: (walletController){
        return Container(
          padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(onTap: ()=> Get.back(), child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).cardColor.withValues(alpha:0.5),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: const Icon(Icons.clear),
                )),
              ),

              Text('transfer_money'.tr,style: textBold),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Image.asset(Images.transferMoneySymbolIcon,height: 40,width: 40),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text('transfer_money_note1'.tr,style: textBold,textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text('transfer_money_note2'.tr,style: textRegular,textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              TextField(
                controller: _balanceController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                cursorColor: Theme.of(context).hintColor,
                style: textRobotoBold,
                decoration: InputDecoration(
                  hintText: '${Get.find<ConfigController>().config?.currencySymbol ?? '\$'}300',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    borderSide:  BorderSide(
                      color: Theme.of(context).primaryColor.withValues(alpha:0.25),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    borderSide:  BorderSide(
                      color: Theme.of(context).primaryColor.withValues(alpha:0.25),
                    ),
                  ),
                ),
                onChanged: (String value){
                  _balanceController.text = '${Get.find<ConfigController>().config?.currencySymbol ?? '\$'}'
                      '${value.replaceAll(Get.find<ConfigController>().config?.currencySymbol ?? '\$', '')}';
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              walletController.isLoading ?
              SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0) :
              ButtonWidget(
                  buttonText: 'transfer'.tr,
                  onPressed: (){
                    String balance = _balanceController.text.trim().replaceAll(Get.find<ConfigController>().config?.currencySymbol ?? '\$', '').replaceAll(' ', '').replaceAll(',', '');
                    if(balance.isEmpty){
                      showCustomSnackBar('this_field_is_required'.tr);
                    }else{
                      Get.find<WalletController>().transferWalletMoney(balance);
                    }
                  }
              )
            ],
          ),
        );
      })
    );
  }
}
