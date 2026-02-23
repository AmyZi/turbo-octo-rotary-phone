import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/coupon/controllers/coupon_controller.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';

class ApplyCoupon extends StatefulWidget {
  final String tripId;
  const ApplyCoupon({super.key, required this.tripId});

  @override
  State<ApplyCoupon> createState() => _ApplyCouponState();
}

class _ApplyCouponState extends State<ApplyCoupon> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(builder: (couponController) {
      String text = Get.find<RideController>().finalFare?.coupon?.couponCode??'';
      return  (Get.find<RideController>().finalFare?.couponAmount != null && Get.find<RideController>().finalFare!.couponAmount! > 0) ?
        Container(height: 50, width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left:Dimensions.paddingSizeDefault,right:Dimensions.paddingSizeDefault,
            bottom: Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            border: Border.all(width: .5, color: Theme.of(context).primaryColor.withValues(alpha:.9))),
          child: Padding(padding:  EdgeInsets.only(left: Get.find<LocalizationController>().isLtr? Dimensions.paddingSizeSmall:0, right: Get.find<LocalizationController>().isLtr? 0 : Dimensions.paddingSizeSmall,),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Image.asset(Images.couponPercentageIcon,height: 20,width: 20,),

              const SizedBox(width: Dimensions.paddingSizeSmall,),
              Text(text,style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),

              const SizedBox(width: Dimensions.paddingSizeSmall,),
              Text(Get.find<RideController>().finalFare!.coupon!.amountType == 'percentage' ?
              '( ${Get.find<RideController>().finalFare!.couponAmount!}% ${'off'.tr} )' :
              '( - ${PriceConverter.convertPrice(Get.find<RideController>().finalFare!.couponAmount!.toDouble())} ${'off'.tr} )',style: textRobotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColor),)
            ])),
      ) : const SizedBox();
        }
    );
  }
}
