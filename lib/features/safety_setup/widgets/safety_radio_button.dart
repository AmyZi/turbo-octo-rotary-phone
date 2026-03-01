import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class SafetyRadioButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  const SafetyRadioButton({super.key,required this.isSelected,required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Expanded(child: Text(
        text,
        style: TextStyle(
          color: !isSelected ? Theme.of(context).hintColor : Get.isDarkMode? Colors.white : Colors.black,
          fontWeight: FontWeight.w400,fontSize: Dimensions.fontSizeDefault,
        ),
      )),

      isSelected ?
      Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeThree)
        ),
        child: const Icon(Icons.check, color: Colors.white,size: 16),
      ) :
      Container(
        height: 16,width: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeThree),
          border: Border.all(color: Theme.of(context).hintColor),
        ),
        child: const SizedBox(),
      ),
      const SizedBox(width: 8),
    ]);
  }
}
