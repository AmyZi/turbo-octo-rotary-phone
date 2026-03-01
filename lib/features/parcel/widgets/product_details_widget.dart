import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';

class ProductDetailsWidget extends StatefulWidget {
  const ProductDetailsWidget({super.key});

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController){
      return ExpansionTile(
        initiallyExpanded: true,
        collapsedBackgroundColor: Theme.of(context).primaryColor.withValues(alpha:.4),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Image.asset(Images.parcelDetails,width: Dimensions.iconSizeSmall),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Text('parcel_details'.tr,style: textRegular.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.7) : null)),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            InkWell(
              onTap: (){
                parcelController.updateParcelState(ParcelDeliveryState.addOtherParcelDetails);
                Get.find<MapController>().notifyMapController();
              },
              child: Image.asset(Images.editIcon,width: 15,height: 15),
            ),
          ]),
        ]),

        children: <Widget>[
          Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                color: Theme.of(context).colorScheme.onPrimary.withValues(alpha:0.1),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(children: [
                RowText(title: 'weight', leadingText: '${parcelController.parcelWeightController.text} kg'),

                RowText(title: 'type', leadingText: parcelController.parcelTypeController.text),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
          ])
        ],
      );
    });
  }
}

class RowText extends StatelessWidget {
  final String title;
  final String? leadingText;
  const RowText({super.key, required this.title, required this.leadingText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title.tr,style: textMedium.copyWith(
            color: Get.isDarkMode ?
            Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.7) :
            Theme.of(context).textTheme.displayLarge!.color,
            fontSize: Dimensions.fontSizeDefault,
        )),
        Text(leadingText??'',style: textMedium.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeDefault)),
      ]),
    );
  }
}
