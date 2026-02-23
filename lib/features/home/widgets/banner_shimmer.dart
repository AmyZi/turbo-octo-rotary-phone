import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:shimmer/shimmer.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha:0.07),
          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),

        child: Container(width: Get.width,height: 130,
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(20)
          ),),
      ),
    );
  }
}
