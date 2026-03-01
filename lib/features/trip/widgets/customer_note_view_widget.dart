import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class CustomerNoteViewWidget extends StatelessWidget {
  final String title;
  final String details;
  final EdgeInsets? edgeInsets ;
  const CustomerNoteViewWidget({
    super.key, required this.title, required this.details, this.edgeInsets,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: edgeInsets ?? const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
            color: title == 'Denied Note' ?
            Theme.of(context).colorScheme.error.withValues(alpha:0.05) :
            Theme.of(context).primaryColor.withValues(alpha:0.05),
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall))
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            title,
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).colorScheme.secondaryFixedDim),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(
            details,
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
          )
        ]),
      ),
    );
  }
}
