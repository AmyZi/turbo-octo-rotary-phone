import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class TipsWidget extends StatefulWidget {
  const TipsWidget({super.key});

  @override
  State<TipsWidget> createState() => _TipsWidgetState();
}

class _TipsWidgetState extends State<TipsWidget> {
  int selectedIndex = -1;
  final List<int> _suggestedAmount = [0,10,20,30,40,50, 60,70, 100];
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    if (Get.find<PaymentController>().tipAmount != '0') {
      amountController.text =
          PriceConverter.convertPrice(double.parse(Get.find<PaymentController>().tipAmount));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(surfaceTintColor: Theme.of(context).cardColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
      child: Container(padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(onTap: ()=> Get.back(), child: Container(
                decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Image.asset(
                  Images.crossIcon,
                  height: Dimensions.paddingSizeSmall,
                  width: Dimensions.paddingSizeSmall,
                  color: Theme.of(context).cardColor,
                ),
              )),
            ),

            Padding(padding:const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Text('tip_amount'.tr, style: textSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeExtraLarge,
                  color: Get.isDarkMode ? Theme.of(context).cardColor : null
              )),
            ),

            IntrinsicWidth(child: TextFormField(
              textAlign: TextAlign.center,
              controller: amountController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'enter_amount'.tr,
                hintStyle: textRegular.copyWith(
                  color: Get.isDarkMode ? Theme.of(context).hintColor : Theme.of(context).hintColor.withValues(alpha:.5),
                ),
                enabledBorder: UnderlineInputBorder(
                    borderSide:  BorderSide(width: 0.5,
                        color: Theme.of(context).hintColor.withValues(alpha:0.0))),
                focusedBorder: UnderlineInputBorder(
                  borderSide:  BorderSide(width: 0.5,
                      color: Theme.of(context).hintColor.withValues(alpha:0.0)),
                ),
              ),
              style: textRobotoBold.copyWith(color: Theme.of(context).primaryColor),
              onChanged: (String amount){
                amountController.text = '${Get.find<ConfigController>().config?.currencySymbol ?? '\$'}'
                    '${amount.replaceAll(Get.find<ConfigController>().config?.currencySymbol ?? '\$', '')}';
              },

            )),

            Divider(color: Theme.of(context).primaryColor.withValues(alpha:.25)),

            Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall,
                bottom: Dimensions.paddingSizeDefault,
              ),
              child: SizedBox(height: 60, child: ListView.builder(itemCount: _suggestedAmount.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (amountContext, index){
                  return GestureDetector(
                    onTap: (){
                      amountController.text =
                          PriceConverter.convertPrice(_suggestedAmount[index].toDouble());
                      selectedIndex = index;
                      setState(() {});

                    },
                    child: Padding(
                      padding:const EdgeInsets.symmetric(
                        horizontal : Dimensions.paddingSizeExtraSmall,
                        vertical: Dimensions.paddingSizeSmall,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color:index == selectedIndex ? Theme.of(context).primaryColor :
                          Theme.of(context).cardColor, borderRadius: BorderRadius.circular(30),
                          border: Border.all(color:Get.isDarkMode ?
                          Theme.of(context).hintColor.withValues(alpha:.25) :
                          Theme.of(context).primaryColor.withValues(alpha:.35),
                          ),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Text(
                            index == 0 ? 'not_now'.tr :
                            '${Get.find<ConfigController>().config!.currencySymbol} ${_suggestedAmount[index]}',
                            style: textRegular.copyWith(color: index == selectedIndex
                                ? Theme.of(context).cardColor
                                : Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeThree),

                          _suggestedAmount[index] == Get.find<ConfigController>().config?.popularTips ?
                          Container(height: 13, width: 70, alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Center(child: Text('popular'.tr, style: textRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,color: Colors.white,
                            ))),
                          ) : const SizedBox(height: 5,width: 70,)

                        ]),
                      ),
                    ),
                  );
                },
              )),
            ),

            Text('tips_note'.tr,style: textRegular.copyWith(color: Theme.of(context).hintColor),
              textAlign: TextAlign.center,
            ),

            Padding(
              padding:const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault,
                top: Dimensions.paddingSizeExtraLarge,
              ),
              child: SizedBox(width: 100, child: ButtonWidget(buttonText: 'give_tips'.tr,
                radius: 10,
                onPressed: (){
                  Get.find<PaymentController>().setTipAmount(
                      amountController.text.trim().replaceAll(
                          Get.find<ConfigController>().config?.currencySymbol ?? '\$', '',
                      ),
                  );
                  Get.back();

                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
