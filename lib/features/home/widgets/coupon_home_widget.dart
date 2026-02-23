import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/coupon/controllers/coupon_controller.dart';
import 'package:ride_sharing_user_app/features/home/widgets/coupon_home_shimmer.dart';
import 'package:ride_sharing_user_app/features/my_offer/screens/my_offer_screen.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class HomeCouponWidget extends StatelessWidget {
  const HomeCouponWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(builder: (couponController){
      return couponController.couponModel != null ?
      (couponController.couponModel!.data != null && couponController.couponModel!.data!.isNotEmpty) ?
      Container(color: Theme.of(context).primaryColor.withValues(alpha:0.2),
        padding: const EdgeInsets.only(top:Dimensions.paddingSizeDefault,left: Dimensions.paddingSize,bottom: Dimensions.paddingSizeDefault),
        child: Column(children: [
          Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('coupons'.tr,style: textBold.copyWith(
                  color: Get.isDarkMode ?
                  Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.9) :
                  Theme.of(context).textTheme.bodyLarge!.color
              )),

              InkWell(
                onTap: () => Get.to(() => MyOfferScreen(isCoupon: true, fromDashboard: true)),
                child: Text('see_all'.tr,style: textRegular.copyWith(
                  color: Get.isDarkMode ?
                  Theme.of(context).primaryColor :
                  Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.75),
                )),
              ),
            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          SizedBox(
            width: Get.width,height: 75,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: couponController.couponModel!.data!.length,itemBuilder: (context,index){
              return Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    width: Get.width * 0.65,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                    ),
                    child: Row(children: [
                      SizedBox(
                        width: Get.width * 0.38,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Row(children: [
                            Text('${'code'.tr}: ',style: textRegular.copyWith(
                                color: Get.isDarkMode ?
                                Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8) :
                                Theme.of(context).hintColor
                            )),

                            Expanded(child: Text(
                                couponController.couponModel!.data![index].couponCode!,
                              style: textBold.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) : null),
                              overflow: TextOverflow.ellipsis,
                            )),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Text('${couponController.couponModel!.data![index].amountType! == 'percentage' ?
                          '${double.parse(couponController.couponModel!.data![index].coupon!).toStringAsFixed(0)} %' :
                          PriceConverter.convertPrice(double.parse(couponController.couponModel!.data![index].coupon!))} OFF',
                            style: textRobotoRegular.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8),
                              overflow: TextOverflow.ellipsis,
                            ),maxLines: 1,
                          )
                        ]),
                      ),

                      Expanded(child: DottedLine(direction: Axis.vertical,dashColor: Theme.of(context).primaryColor.withValues(alpha:0.1),lineThickness: 2)),

                      InkWell(
                        onTap: () {
                          couponController.customerAppliedCoupon(couponController.couponModel!.data![index].id!, index);
                        },
                        child: couponController.couponModel!.data![index].isLoading ?
                        SpinKitCircle(color: Theme.of(context).primaryColor.withValues(alpha:0.50), size: 40.0) :
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall,horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: couponController.couponModel!.data![index].isApplied! ? Theme.of(context).primaryColor.withValues(alpha:0.15) :
                            Theme.of(context).primaryColor,
                          ),
                          child: Text(couponController.couponModel!.data![index].isApplied! ? 'applied'.tr : 'apply'.tr,
                            style: textRegular.copyWith(
                              color: Get.isDarkMode ?
                              Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) :
                              couponController.couponModel!.data![index].isApplied! ?
                              Theme.of(context).primaryColor : Theme.of(context).cardColor,
                            ),
                          ),
                        ) ,
                      ),

                    ]),
                  ),
                ),

                Positioned(
                  bottom: -22,left: Get.width * 0.38,
                  child: Container(
                    width: 22, height : 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),

                Positioned(
                  top: -22,left: Get.width * 0.38,
                  child: Container(
                    width: 22, height : 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ]);
            },
            ),
          )

        ]),
      ) :
      const SizedBox() :
      const CouponHomeShimmer();
    });
  }
}
