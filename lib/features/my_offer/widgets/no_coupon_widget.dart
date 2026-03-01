import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class NoCouponWidget extends StatelessWidget {
  final String title;
  final String description;
  const NoCouponWidget({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Image.asset(Images.noDiscountIcon,height: 100,width: 100),

          Text(
            title.tr ,
            style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
             description.tr ,
            style: textBold.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault),
            textAlign: TextAlign.center,
          ),
        ],
      )),
    );
  }
}
