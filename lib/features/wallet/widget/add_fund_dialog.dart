import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_text_field.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/screens/digital_add_fund_screen.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class AddFundDialog extends StatefulWidget {
  const AddFundDialog({super.key});

  @override
  State<AddFundDialog> createState() => _AddFundDialogState();
}

class _AddFundDialogState extends State<AddFundDialog> {
  final TextEditingController _amountController = TextEditingController();
  @override
  void initState() {
    Get.find<PaymentController>().initPayment();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      insetPadding: EdgeInsets.all(Dimensions.paddingSizeDefault).copyWith(top: Get.height * 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: GetBuilder<PaymentController>(builder: (paymentController){
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
              child: InkWell(
                onTap: ()=> Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Image.asset(Images.crossIcon,height: 10,width: 10, color: Theme.of(context).cardColor),
                ),
              ),
            ),
          ),

          Flexible(child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(top: 0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('add_fund'.tr, style: textMedium),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(
                'add_fund_from_secured_digital'.tr,
                style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    color: Theme.of(context).hintColor.withValues(alpha: 0.1)
                ),
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(children: [
                  CustomTextField(
                    controller: _amountController,
                    textAlignment: TextAlign.center,
                    borderRadius: Dimensions.paddingSizeExtraSmall,
                    inputType: TextInputType.number,
                    isAmount: true,
                    hintText: 'enter_amount'.tr,
                    onChanged: (String amount){
                      _amountController.text = '${Get.find<ConfigController>().config?.currencySymbol ?? '\$'}'
                          '${amount.replaceAll(Get.find<ConfigController>().config?.currencySymbol ?? '\$', '')}';
                    },
                  ),
                  const SizedBox(height: 2),

                  Text(
                    '${'minimum_add_fund'.tr}: ${PriceConverter.convertPrice(Get.find<ConfigController>().config?.walletMinimumDepositLimit ?? 0)}',
                    style: textRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall),
                  )
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Flexible(child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                    color: (paymentController.paymentGateways ?? []).isNotEmpty ? Theme.of(context).cardColor : Theme.of(context).hintColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    border: (paymentController.paymentGateways ?? []).isNotEmpty ? Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)) : null
                ),
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  if((paymentController.paymentGateways ?? []).isNotEmpty)...[
                    Row(children: [
                      Text('add_money_via_online'.tr, style: textRegular.copyWith(fontSize: 11)),

                      Text(' (${'fast_and_secured_way_to_add'.tr})', style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7), fontSize: 8))
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Flexible(child: ListView.builder(
                        itemCount: paymentController.paymentGateways?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: ()=> paymentController.setDigitalPaymentType(index, paymentController.paymentGateways![index].gateway ?? ''),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Row(children: [
                                ImageWidget(image: '${AppConstants.baseUrl}/storage/app/public/payment_modules/gateway_image/${paymentController.paymentGateways![index].gatewayImage}', fit: BoxFit.contain, height: 20),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Text('${paymentController.paymentGateways![index].gatewayTitle}', style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
                              ]),

                              RadioGroup(
                                groupValue: paymentController.paymentGatewayIndex,
                                onChanged: (value)=> paymentController.setDigitalPaymentType(index, paymentController.paymentGateways![index].gateway ?? ''),
                                child: Radio(value: index),
                              )
                            ]),
                          );
                        }
                    ))
                  ]
                  else...[
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(
                      'currently_no_payment_method_is_available'.tr,
                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeSmall)
                  ]

                ]),
              )),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              ButtonWidget(
                  onPressed: (paymentController.paymentGateways ?? []).isNotEmpty ? (){
                    String textBalance = _amountController.text.trim().replaceAll(Get.find<ConfigController>().config?.currencySymbol ?? '\$', '').replaceAll(' ', '').replaceAll(',', '');
                    double balance = double.tryParse(textBalance) ?? -1;

                    if(balance == -1){
                      showCustomSnackBar('enter_amount'.tr);
                    }else if(balance < (Get.find<ConfigController>().config?.walletMinimumDepositLimit ?? 0)){
                      showCustomSnackBar('amount_should_be_greater_than_minimum_amount'.tr);
                    }else if(paymentController.paymentGatewayIndex == -1){
                      showCustomSnackBar('select_payment_method'.tr);
                    }else{
                      Get.back();
                      Get.to(()=> DigitalAddFundScreen(totalAmount: balance, paymentMethod: paymentController.gateWay));
                    }
                  } : null,
                  buttonText: 'add_fund'.tr,
                  radius: Dimensions.paddingSizeSmall
              )
            ]),
          )),
        ]);
      }),
    );
  }
}
