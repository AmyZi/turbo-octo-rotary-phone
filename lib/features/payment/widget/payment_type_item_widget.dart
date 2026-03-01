import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';

class PaymentTypeItem extends StatelessWidget {
  final String title;
  final int index;
  final int selectedIndex;

  const PaymentTypeItem({super.key, required this.title, required this.index, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (paymentController) {
          return InkWell(
            onTap: () => paymentController.setPaymentType(index),
            child:(Get.find<PaymentController>().paymentGateways?.isEmpty ?? false) && title == 'digital' ?
            const SizedBox() :
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,
                Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault
              ),
              child: Row(children: [
                Container(width: 20,height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeThree),
                    color: index == selectedIndex ? Theme.of(context).primaryColor: null,
                    border: Border.all(
                      width: 2,
                      color: index == selectedIndex ? Theme.of(context).primaryColor :
                      Theme.of(context).hintColor,
                    ),
                  ),
                    child:  Center(child: Icon(
                        Icons.check, size: Dimensions.iconSizeSmall,
                        color: index == selectedIndex ? Colors.white : Colors.transparent ,
                    )),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Text(title.tr,
                    style: index == selectedIndex ?
                    textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color) :
                    textRegular.copyWith(color: Theme.of(context).hintColor)),
              ]),
            ),
          );
        });
  }
}