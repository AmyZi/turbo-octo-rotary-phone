import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class PickButtonWidget extends StatelessWidget {
  final String title;
  final String image;
  final Function onTap;
  const PickButtonWidget({
    super.key, required this.title, required this.image, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> onTap(),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
        ),
        child: Row(children: [
          Text(title,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Image.asset(image,height: 18,width: 18,color: Theme.of(context).textTheme.bodyMedium!.color)
        ]),
      ),
    );
  }
}
