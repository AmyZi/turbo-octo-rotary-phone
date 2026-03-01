import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/splash/domain/models/config_model.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class DigitalCardPaymentWidget extends StatelessWidget {
  final PaymentGateways digitalPaymentModel;
  final int index;
  const DigitalCardPaymentWidget({super.key, required this.digitalPaymentModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraSmall),
      child: GetBuilder<PaymentController>(
        builder: (paymentController) {
          return InkWell(onTap: ()=> Get.find<PaymentController>().setDigitalPaymentType(index, digitalPaymentModel.gateway??''),
            child: Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
              child: Container(decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                color: Get.isDarkMode? Theme.of(context).canvasColor :Theme.of(context).cardColor,
                boxShadow: Get.isDarkMode? null : [BoxShadow(color: paymentController.paymentGatewayIndex == index?
                Theme.of(context).primaryColor: Theme.of(context).hintColor,
                    spreadRadius: .25, blurRadius: 1, offset: const Offset(0,0.5))]),
                child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Text(digitalPaymentModel.gatewayTitle??'',style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),
                      paymentController.paymentGatewayIndex == index?
                      const Icon(Icons.check_circle, color: Colors.green,) : const SizedBox()
                    ],),

                    SizedBox(width: 70,height: 30, child: ImageWidget(image: '${AppConstants.baseUrl}/storage/app/public/payment_modules/gateway_image/${digitalPaymentModel.gatewayImage??''}'))
                  ],
                ),
              ),),
            ),
          );
        }
      ),
    );
  }
}