import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MyOfferShimmerWidget extends StatefulWidget {
  const MyOfferShimmerWidget({super.key});

  @override
  State<MyOfferShimmerWidget> createState() => _MyOfferShimmerWidgetState();
}

class _MyOfferShimmerWidgetState extends State<MyOfferShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSize,bottom: Dimensions.paddingSizeSmall,top: Dimensions.paddingSizeExtraSmall),

      child: Column(children: [
        Padding( padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: Shimmer(color:Theme.of(context).shadowColor,
                      child: Container(width: 80, height: 15, color:Get.isDarkMode? Colors.black : Colors.white,))),

              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: Shimmer(color:Theme.of(context).shadowColor,
                      child: Container(width: 80, height: 15, color:Get.isDarkMode? Colors.black : Colors.white,))),
            ])),

        const SizedBox(height: Dimensions.paddingSizeDefault,),
        SizedBox(width: Get.width,height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,itemBuilder: (context,index){
            return Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
              child: SizedBox(height: MediaQuery.of(context).size.height * 0.12,width: MediaQuery.of(context).size.width * 0.65,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusLarge ),
                      child: Shimmer(color:Theme.of(context).shadowColor,
                          child: Container(width: MediaQuery.of(context).size.width * 0.65,
                            height: MediaQuery.of(context).size.height * 0.12, color:Get.isDarkMode? Colors.black : Colors.white,))
                      ),

                  const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                  Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault                 ),
                    child: Shimmer(color:Theme.of(context).shadowColor,
                        child: Container(width: 60, height: 15, color:Get.isDarkMode? Colors.black : Colors.white,)),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                  Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                    child: Shimmer(color:Theme.of(context).shadowColor,
                        child: Container(width: 50, height: 15, color:Get.isDarkMode? Colors.black : Colors.white,)),
                  )
                ],),
              ),
            );
          },),
        )


      ]),
    );
  }
}
