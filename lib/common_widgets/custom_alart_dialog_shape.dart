import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class CustomAlertDialogShape extends StatelessWidget {
  final Widget child;
  const CustomAlertDialogShape({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 4, width: 40, decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(25),
          )),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          child,

        ],
      ),
    );
  }
}
