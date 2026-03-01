import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CouponHomeShimmer extends StatelessWidget {
  const CouponHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(color: Theme.of(context).primaryColor.withValues(alpha:0.1),
      padding: const EdgeInsets.only(top:Dimensions.paddingSizeDefault,left: Dimensions.paddingSizeDefault,bottom: Dimensions.paddingSizeDefault),
      child: Column(children: [
        Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall,right: Dimensions.paddingSizeSmall),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: Shimmer(color:Theme.of(context).shadowColor,
                      child: Container(width: 80, height: 15, color:Get.isDarkMode? Colors.black : Colors.white,))),

              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: Shimmer(color:Theme.of(context).shadowColor,
                      child: Container(width: 80, height: 15, color:Get.isDarkMode? Colors.black : Colors.white,)))])),

        const SizedBox(height: Dimensions.paddingSizeDefault,),
        SizedBox(width: Get.width,height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,itemBuilder: (context,index){
            return Stack(children: [

              Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  width: Get.width * 0.65,
                  decoration: BoxDecoration(color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall))),
                  child: Row(children: [
                    SizedBox(width: Get.width * 0.38,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                        ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: Shimmer(color:Theme.of(context).shadowColor,
                                child: Container(width: 50, height: 15, color:Get.isDarkMode? Colors.black : Colors.white,))),

                        const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                        ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: Shimmer(color:Theme.of(context).shadowColor,
                                child: Container(width: 40, height: 15, color:Get.isDarkMode? Colors.black : Colors.white,))),
                      ],),
                    ),

                    Expanded(child: DottedLine(direction: Axis.vertical,dashColor: Theme.of(context).hintColor,)),

                    Container(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall), decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50)),
                      child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: Shimmer(color:Theme.of(context).shadowColor,
                              child: Container(width: 30, height: 15, color:Get.isDarkMode? Colors.black : Colors.white,))),),

                  ]),
                ),
              ),

              Positioned(bottom: -25,left: Get.width * 0.38,
                  child: Container(width: 32, height : 32,decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(100)),)),

              Positioned(top: -25,left: Get.width * 0.38,
                  child: Container(width: 32, height : 32,decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(100)),)),
            ],
            );
          },),
        )


      ]),
    );
  }
}
