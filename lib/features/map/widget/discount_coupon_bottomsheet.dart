
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_widget.dart';
import 'package:ride_sharing_user_app/features/coupon/controllers/coupon_controller.dart';
import 'package:ride_sharing_user_app/features/coupon/widget/offer_coupon_card_widget.dart';
import 'package:ride_sharing_user_app/features/my_offer/controller/offer_controller.dart';
import 'package:ride_sharing_user_app/features/my_offer/widgets/no_coupon_widget.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class DiscountAndCouponBottomSheet extends StatefulWidget {
  const DiscountAndCouponBottomSheet({super.key});

  @override
  State<DiscountAndCouponBottomSheet> createState() => _DiscountAndCouponBottomSheetState();
}

class _DiscountAndCouponBottomSheetState extends State<DiscountAndCouponBottomSheet> {
  bool isCoupon = false;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius:const BorderRadius.only(
              topRight: Radius.circular(Dimensions.paddingSizeLarge),
              topLeft: Radius.circular(Dimensions.paddingSizeLarge),
            )
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 30,height: 5,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(50)
            ),
          ),

          InkWell(
            onTap: ()=> Get.back(),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Image.asset(Images.crossIcon,height: 10,width: 10),
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.25)),
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              InkWell(
                onTap: (){
                  isCoupon = false;
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isCoupon ? null : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                    child: Text('discounts'.tr, style: textSemiBold.copyWith(
                      color: isCoupon ?
                      Theme.of(context).textTheme.bodyMedium!.color?.withValues(alpha:0.65) :
                      Theme.of(context).cardColor,
                    )),
                  ),
                ),
              ),

              InkWell(
                onTap: (){
                  isCoupon = true;
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isCoupon ? Theme.of(context).primaryColor : null,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                    child: Text('coupons'.tr, style: textSemiBold.copyWith(
                        color: !isCoupon ?
                        Theme.of(context).textTheme.bodyMedium!.color?.withValues(alpha:0.65) :
                        Theme.of(context).cardColor
                    )),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          !isCoupon ?
          _DiscountWidget(scrollController: scrollController) :
          _CouponWidget(scrollController: scrollController)

        ]),
      ),
    );
  }
}

class _CouponWidget extends StatelessWidget {
  final ScrollController scrollController;
  const _CouponWidget({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(builder: (couponController){
      return (couponController.couponModel!.data != null && couponController.couponModel!.data!.isNotEmpty) ?
      Expanded(child: PaginatedListWidget(
        scrollController: scrollController,
        onPaginate: (int? offset) async {
          await couponController.getCouponList(offset!);
        },
        totalSize: couponController.couponModel?.totalSize,
        offset: int.parse(couponController.couponModel!.offset.toString()),
        itemView: Flexible(
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
            itemCount: couponController.couponModel!.data!.length,
            itemBuilder: (context, index){
              return OfferCouponCardWidget(fromCouponScree: false,coupon: couponController.couponModel!.data![index],index: index,);
            },
            separatorBuilder: (context, index){
              return const SizedBox(height: Dimensions.paddingSizeDefault,);
            },
          ),
        ),
      )) :
      NoCouponWidget(
        title: 'no_coupon_available'.tr,
        description: 'sorry_there_is_no_coupon'.tr,
      );
    });
  }
}


class _DiscountWidget extends StatelessWidget {
  final ScrollController scrollController;
  const _DiscountWidget({ required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfferController>(builder: (offerController){
      return (offerController.bestOfferModel!.data!= null && offerController.bestOfferModel!.data!.isNotEmpty) ?
      Expanded(child: PaginatedListWidget(
        scrollController: scrollController,
        onPaginate: (int? offset) async {
          await offerController.getOfferList(offset!);
        },
        totalSize: offerController.bestOfferModel?.totalSize,
        offset: int.parse(offerController.bestOfferModel!.offset.toString()),
        itemView: Flexible(child: ListView.separated(
          controller: scrollController,
          itemCount: offerController.bestOfferModel!.data!.length,
          itemBuilder: (context, index){
            return Container(
              width: Get.width,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).hintColor.withValues(alpha:0.1),
                  border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.15))
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(spacing: Dimensions.paddingSizeExtraSmall, children: [
                  Image.asset(Images.offerIcon, color: Theme.of(context).colorScheme.tertiaryContainer, height: 18, width: 18),

                  Text(offerController.bestOfferModel!.data![index].title ?? '',style: textBold),

                  Flexible(
                    child: SizedBox(height: Get.height * 0.03,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: offerController.bestOfferModel?.data?[index].moduleDiscount?.length ?? 0,
                        itemBuilder: (ctx, position){
                          return Container(
                            decoration: BoxDecoration(
                                color: offerController.bestOfferModel?.data?[index].moduleDiscount?[position] == 'parcel' ?
                                Colors.green.withValues(alpha: 0.2):
                                Colors.blue.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            child: Text('${offerController.bestOfferModel?.data?[index].moduleDiscount?[position].tr}'),
                          );
                        },
                        separatorBuilder: (ctx, index){
                          return const SizedBox(width: Dimensions.paddingSizeThree);
                        },
                      ),
                    ),
                  )
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text(
                  offerController.bestOfferModel!.data![index].shortDescription ?? '',
                  style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                IntrinsicHeight(
                  child: Row(children: [
                    Text(
                      '${'valid'.tr}: ${DateConverter.stringToLocalDateOnly(offerController.bestOfferModel!.data![index].endDate!)}',
                      style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.5)),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeThree),
                      child: VerticalDivider(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha:0.2)),
                    ),

                    Expanded(
                      child: Text(
                        '${offerController.bestOfferModel?.data?[index].zoneDiscount.toString().replaceAll("[", "").replaceAll("]", "").tr}',
                        style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.5)),
                      ),
                    )
                  ]),
                ),
              ]),
            );
          },
          separatorBuilder: (context, index){
            return const SizedBox(height: Dimensions.paddingSizeDefault,);
          },
        )),
      )) :
      NoCouponWidget(
        title: 'no_discount_found'.tr,
        description: 'sorry_there_is_no_discount'.tr,
      );
    });
  }

}

