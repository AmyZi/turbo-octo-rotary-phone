import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SavedAndRecentItem extends StatelessWidget {
  final String title;
  final String icon;
  final String subTitle;
  final bool isSeeMore;
  final Function()? onTap;
  const SavedAndRecentItem({super.key, required this.title, required this.icon, required this.subTitle, this.isSeeMore = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Text(title.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge))),

      GestureDetector(onTap: onTap,
        child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0,
            Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [


            Container(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha:.08),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
              child: SizedBox(width: Dimensions.iconSizeMedium,
                  child: Image.asset(icon, color: Theme.of(context).primaryColor))),
            const SizedBox(width: Dimensions.paddingSizeSmall,),



            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(subTitle.tr, style: textRegular.copyWith(color: Theme.of(context).primaryColor),),
                isSeeMore?
                Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                      vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha:.125),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSeven)),
                    child: Text('see_more'.tr, style: textRegular.copyWith(color: Theme.of(context).hintColor),),
                  ),
                ):const SizedBox(),
              ],
            )
          ],),
        ),
      )
    ],);
  }
}