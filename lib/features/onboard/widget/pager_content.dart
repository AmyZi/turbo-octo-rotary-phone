import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/svg_image_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class PagerContent extends StatelessWidget {
  const PagerContent({super.key, required this.image, required this.text1, required this.text2, required this.text3, required this.text4, required this.index});
  final String image;
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final int index;

  @override
  Widget build(BuildContext context) {
    if(index != 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
              child: RichText(text: TextSpan(
                  children: [
                    TextSpan(text: text1, style: textMedium.copyWith(fontSize: 30, color: Theme.of(context).primaryColor)),
                    TextSpan(text: text2, style: textMedium.copyWith(fontSize: 30, color: Theme.of(context).textTheme.bodyMedium?.color)),
                    TextSpan(text: text3, style: textMedium.copyWith(fontSize: 30, color: Theme.of(context).primaryColor)),
                    TextSpan(text: text4, style: textMedium.copyWith(fontSize: 30, color: Theme.of(context).textTheme.bodyMedium?.color)),
                  ]
              ))
            ),
          ),

          const Spacer(),

          Padding(
            padding: EdgeInsets.only(left: index == 1 ? Dimensions.paddingSizeSmall : 0),
            child: FutureBuilder<String>(
                future: loadSvgAndChangeColors(image, Theme.of(context).primaryColor),
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    return SvgPicture.string(
                      snapshot.data!, width: Get.width,
                    );
                  }
                  return SvgPicture.asset(image, width: Get.width);
                }
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.05)
        ],
      );
    }

     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         SizedBox(height: Get.height * 0.03),

         FutureBuilder<String>(
             future: loadSvgAndChangeColors(image, Theme.of(context).primaryColor),
             builder: (context, snapshot){
               if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                 return SvgPicture.string(
                     snapshot.data!
                 );
               }
               return const SizedBox(height: 150, child: Center(child: CircularProgressIndicator()));
             }
         ),
         const SizedBox(height: Dimensions.paddingSizeExtraLarge),

         Padding(
           padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
           child: RichText(text: TextSpan(
               children: [
                 TextSpan(text: text1, style: textMedium.copyWith(fontSize: 30, color: Theme.of(context).primaryColor)),
                 TextSpan(text: text2, style: textMedium.copyWith(fontSize: 30, color: Theme.of(context).textTheme.bodyMedium?.color)),
                 TextSpan(text: text3, style: textMedium.copyWith(fontSize: 30, color: Theme.of(context).primaryColor)),
                 TextSpan(text: text4, style: textMedium.copyWith(fontSize: 30, color: Theme.of(context).textTheme.bodyMedium?.color)),
               ]
           )),
         ),

       ],
     );
   }
}