import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class TextFieldTitle extends StatelessWidget {
  final String title;
  final double textOpacity;
  final bool isRequired;
  const TextFieldTitle({super.key, required this.title,this.textOpacity=1, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.fromLTRB(0,15,0,5),
      child: Row(children: [
        Text(title,
          style: textMedium.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:textOpacity),
          ),
        ),

        if(isRequired)
          Text('*',
            style: textMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).colorScheme.error),
            ),
      ]),
    );
  }
}
