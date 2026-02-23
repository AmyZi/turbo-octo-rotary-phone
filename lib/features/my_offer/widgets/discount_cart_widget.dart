import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/my_offer/domain/models/best_offer_model.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/extensin_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class DiscountCartWidget extends StatelessWidget {
  final OfferModel offerModel;
  const DiscountCartWidget({super.key, required this.offerModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          width: Get.width,
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeDefault), topRight: Radius.circular(Dimensions.paddingSizeDefault)),
            child: ImageWidget(image: offerModel.image!,fit: BoxFit.cover),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(width: Get.width *0.8,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(spacing: Dimensions.paddingSizeExtraSmall, children: [
                  Text(offerModel.title ?? '', style: textSemiBold),

                  Expanded(
                    child: SizedBox(height: Get.height * 0.03,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: offerModel.moduleDiscount?.length ?? 0,
                        itemBuilder: (ctx, position){
                          return Container(
                            decoration: BoxDecoration(
                                color: offerModel.moduleDiscount?[position] == 'parcel' ?
                                Colors.green.withValues(alpha: 0.2):
                                context.customThemeColors.infoColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                              border: Border.all(color: context.customThemeColors.infoColor, width: 0.5)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: Text(
                              '${offerModel.moduleDiscount?[position].tr}',
                              style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                            ),
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
                  offerModel.shortDescription ?? '',
                  style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.7)),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                IntrinsicHeight(
                  child: Row(children: [
                    Text(
                      '${'valid'.tr}: ${DateConverter.stringToLocalDateOnly(offerModel.endDate!)}',
                      style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha:0.7)),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeThree),
                      child: VerticalDivider(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha:0.2)),
                    ),

                    Expanded(
                      child: Text(
                        offerModel.zoneDiscount.toString().replaceAll("[", "").replaceAll("]", "").tr,
                        style: textRegular.copyWith(color: context.customThemeColors.infoColor),
                      ),
                    )
                  ]),
                ),
              ]),
            ),

            Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).primaryColor)
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall)
      ]),
    );
  }
}
