import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/coupon/domain/models/coupon_model.dart';

class CouponWidget extends StatefulWidget {
  final Coupon coupon;
  const CouponWidget({super.key, required this.coupon});

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  JustTheController tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
        Dimensions.paddingSizeDefault,0,
      ),
      child: SizedBox(height: 130, width: Get.width,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
            child: Center(child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Dimensions.paddingSizeSignUp, 0, Dimensions.paddingSizeSignUp,
                Dimensions.paddingSizeDefault,
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: SizedBox(width: Dimensions.couponIconSize, child: Image.asset(Images.coupon)),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeDefault,
                    horizontal: Dimensions.paddingSizeDefault,
                  ),
                  child: DottedLine(
                    direction: Axis.vertical,
                    lineLength: double.infinity,
                    lineThickness: 4.0,
                    dashLength:8.0,
                    dashColor: Theme.of(context).hintColor.withValues(alpha:.25),
                    dashRadius: 0.0,
                    dashGapLength: 7.0,
                    dashGapColor: Colors.transparent,
                    dashGapRadius: 0.0,
                  ),
                ),

                Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' ${widget.coupon.amountType == 'percentage' ?
                        '${double.parse(widget.coupon.coupon!).toStringAsFixed(0)} %' :
                        PriceConverter.convertPrice(double.parse(widget.coupon.coupon!))} OFF',
                        style: textRobotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodySmall!.color,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        child: Text(
                          widget.coupon.name??'',
                          style: textMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        child: Text(
                          '${'code'.tr} : ${widget.coupon.couponCode??''}',
                          style: textMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Text(
                        '${'expire_date'.tr}: ${widget.coupon.endDate}',
                        style: textRegular.copyWith(
                          color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ],
                  ),
                )),
              ]),
            )),
          ),

          Positioned(
            top: 0,right: Get.find<LocalizationController>().isLtr ? 0 : null,
            left: Get.find<LocalizationController>().isLtr? null : 0,
            child: JustTheTooltip(
              backgroundColor: Get.isDarkMode ?
              Theme.of(context).primaryColor :
              Theme.of(context).textTheme.bodyMedium!.color,
              controller: tooltipController,
              preferredDirection: AxisDirection.down,
              tailLength: 10,
              tailBaseWidth: 20,
              content: Container(width: 90, padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Text('copied'.tr,
                  style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault),
                ),
              ),
              child: InkWell(
                onTap: () async {
                  tooltipController.showTooltip();
                  await Clipboard.setData(ClipboardData(text: widget.coupon.couponCode!)).then((value) {
                    /*showCustomSnackBar('copied'.tr, isError: false);*/});
                },
                child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Icon(Icons.copy_rounded,
                    color: Get.find<ThemeController>().darkTheme ?
                    Theme.of(context).hintColor :
                    Theme.of(context).primaryColor.withValues(alpha:.65),
                  ),
                ),
              ),
            ),
          ),

          Positioned(top: 50,left: -18,
            child: Container(width: 35, height : 35,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          Positioned(top: 50,right: -18,
            child: Container(
              width: 35, height : 35,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

        ]),
      ),
    );
  }
}
