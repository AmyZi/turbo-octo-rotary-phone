import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:shimmer/shimmer.dart';

class AddressShimmer extends StatelessWidget {
  const AddressShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 60,
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, item) => Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[50]!,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha:0.07),
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
              ),
              child: Row(
                children:  [
                   const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: ImageWidget(
                      image: '',
                      radius: Dimensions.radiusDefault,
                      height: 30, width: 30,
                      placeholder: Images.carPlaceholder,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(width: 80, height: 15, color: Colors.white,),
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
