import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeSmall),
      child: ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, item) => Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[50]!,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha:0.07),
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
              ),
              child: Column(
                children:  [
                   const ImageWidget(
                     image: '',
                     radius: Dimensions.radiusDefault,
                     height: 50, width: 50,
                     placeholder: Images.carPlaceholder,
                   ),
                  const SizedBox(height: Dimensions.paddingSizeSmall,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(width: 70, height: 5, color: Colors.white,),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
