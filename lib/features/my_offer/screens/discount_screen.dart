import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/my_offer/domain/models/best_offer_model.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class DiscountScreen extends StatelessWidget {
  final OfferModel offerModel;
  const DiscountScreen({super.key,required this.offerModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(title: 'discount'.tr,showBackButton: true),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,width: Get.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
                        child: ImageWidget(image:offerModel.image!,fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Expanded(child: Text(offerModel.title ?? '',style: textBold.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) : null))),

                      InkWell(
                        onTap: ()=> Get.bottomSheet(
                          SizedBox(width: Get.width,
                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                              const SizedBox(height: 30),

                              Text('we_do_the_best_for_you'.tr,style: textSemiBold.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) : null)),

                              Divider(color: Theme.of(context).hintColor.withValues(alpha:0.15)),

                              Text(
                                'if_you_have_multiple_eligible_discounts_we_will_automatically_apply_the_discount_that_will_save_you_the_most_to_your_next_trip'.tr,
                                style: textRegular.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8) : Theme.of(context).hintColor), textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 50)
                            ]),
                          ) ,
                          backgroundColor: Theme.of(context).cardColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                          child: Icon(Icons.info,color: Theme.of(context).primaryColor),
                        ),
                      )
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      '${'valid'.tr}: ${DateConverter.stringToLocalDateOnly(offerModel.endDate!)}',
                      style: textRegular.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) : Theme.of(context).hintColor),
                    ),

                    Container(width: Get.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withValues(alpha:0.15),
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      margin: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeSmall),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        offerModel.zoneDiscount!.contains('all') ?
                        const SizedBox() :
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            margin:const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            height: 7,width: 7,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode ? Colors.white : Colors.black,
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                            ),
                          ),

                          Expanded(
                            child: RichText(text: TextSpan(
                                text: '${'this_offer_available_only_in'.tr} ',
                                style: textRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                                ),
                                children: [TextSpan(
                                  text: offerModel.zoneDiscount!.contains('all') ?
                                  'all_zone'.tr :
                                  offerModel.zoneDiscount.toString().substring(1,offerModel.zoneDiscount.toString().length -1),
                                  style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                )]
                            )),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        offerModel.moduleDiscount!.contains('all') ?
                        const SizedBox() :
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            margin:const EdgeInsets.all(Dimensions.paddingSizeExtraSmall) ,
                            height: 7,width: 7,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode ? Colors.white : Colors.black,
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                            ),
                          ),

                          Expanded(
                            child: RichText(text: TextSpan(
                                text: '${'discount_on'.tr} ',
                                style: textRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                                ),
                                children: [TextSpan(
                                  text:  offerModel.moduleDiscount!.contains('all') ?
                                  'all_modules'.tr :
                                  offerModel.moduleDiscount.toString().substring(1,offerModel.moduleDiscount.toString().length - 1),
                                  style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                )]
                            )),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        offerModel.customerLevelDiscount!.contains('all') ?
                        const SizedBox() :
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            margin:const EdgeInsets.all(Dimensions.paddingSizeExtraSmall) ,
                            height: 7,width: 7,
                            decoration:  BoxDecoration(
                              color:Get.isDarkMode ? Colors.white :  Colors.black,
                              borderRadius: const BorderRadius.all(Radius.circular(100),
                              ),
                            ),
                          ),

                          Expanded(
                            child: RichText(text: TextSpan(
                                text: '${'to_get_this_offer_user_must_be'.tr} ',
                                style: textRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                                ),
                                children: [TextSpan(
                                  text: offerModel.customerLevelDiscount!.contains('all') ?
                                  "all_levels".tr :
                                  offerModel.customerLevelDiscount.toString().substring(1,offerModel.customerLevelDiscount.toString().length-1),
                                  style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                )]
                            )),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Row(children: [
                          Container(
                            margin:const EdgeInsets.all(Dimensions.paddingSizeExtraSmall) ,
                            height: 7,width: 7,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode ? Colors.white : Colors.black,
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                            ),
                          ),

                          Expanded(
                            child: RichText(text: TextSpan(
                                text: '${'one_user_can_use_it_maximum'.tr} ',
                                style: textRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                                ),
                                children: [TextSpan(
                                  text:  '${offerModel.limit} ${'times'.tr}',
                                  style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                )]
                            )),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Row(children: [
                          Container(
                            margin:const EdgeInsets.all(Dimensions.paddingSizeExtraSmall) ,
                            height: 7,width: 7,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode ? Colors.white : Colors.black,
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                            ),
                          ),

                          Expanded(
                            child: RichText(text: TextSpan(
                                text: '${'you_need_to_spend_minimum'.tr} ',
                                style: textRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9)
                                ),
                                children: [TextSpan(
                                  text: '${Get.find<ConfigController>().config!.currencySymbol}${offerModel.minTripAmount}',
                                  style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                )]
                            )),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Row(children: [
                          Container(
                            margin:const EdgeInsets.all(Dimensions.paddingSizeExtraSmall) ,
                            height: 7,width: 7,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode ? Colors.white : Colors.black,
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                            ),
                          ),

                          Expanded(
                            child: RichText(text: TextSpan(
                                text: '${'discount_amount_is'.tr} ',
                                style: textRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                                ),
                                children: [TextSpan(
                                  text: offerModel.discountAmountType == 'percentage' ?
                                  '${offerModel.discountAmount}%' :
                                  '${Get.find<ConfigController>().config!.currencySymbol}${offerModel.discountAmount}',
                                  style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                )]
                            )),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        offerModel.discountAmountType == 'percentage' ?
                        Row(children: [
                          Container(
                            margin:const EdgeInsets.all(Dimensions.paddingSizeExtraSmall) ,
                            height: 7,width: 7,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode ? Colors.white : Colors.black,
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                            ),
                          ),

                          Expanded(
                            child: RichText(text: TextSpan(
                                text: '${'maximum_discount_amount'.tr} ',
                                style: textRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                                ),
                                children: [TextSpan(
                                  text:  '${Get.find<ConfigController>().config!.currencySymbol}${offerModel.maxDiscountAmount}',
                                  style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                )]
                            )),
                          ),
                        ]) :
                        const SizedBox(),
                      ]),
                    ),

                    Text(
                        'terms&condition'.tr,
                        style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall,
                        color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) : null)
                    ),

                    Text(
                      offerModel.termsConditions ?? '',
                      style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Get.isDarkMode ?
                        Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8) :
                        Theme.of(context).hintColor,
                      ),
                    ),

                  ]),
                ),

                ButtonWidget(buttonText: 'got_it'.tr,onPressed: () {
                  Get.back();
                }),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
