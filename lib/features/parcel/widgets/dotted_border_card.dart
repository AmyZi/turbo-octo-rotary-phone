import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';

class DottedBorderCard extends StatelessWidget {
  const DottedBorderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {
        if(Get.find<ParcelController>().parcelCategoryList == null || Get.find<ParcelController>().parcelCategoryList!.isEmpty) {
          showCustomSnackBar('no_parcel_category_found'.tr);
        }else {
          Get.to(() => const MapScreen(fromScreen: MapScreenType.parcel));
        }
      },
      child: Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            dashPattern: const [5,5],
              color: Theme.of(context).primaryColor.withValues(alpha:0.3),
              radius: const Radius.circular(Dimensions.paddingSizeDefault)
          ),
          child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
            child: Container(decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('send'.tr,style: textMedium.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeOverLarge),),
                      Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        child: Text('safest_delivery'.tr,style: textMedium.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeDefault)))]),
                  const Spacer(),
                  Image.asset(Images.parcelDeliveryman,height: 60,),
                  const SizedBox()



                ],),
              ),),
          ),
        ),
      ),
    );
  }
}
