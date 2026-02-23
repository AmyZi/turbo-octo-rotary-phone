import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class BodyWidget extends StatefulWidget {
  final Widget body;
  final AppBarWidget appBar;
  final double topMargin;
  const BodyWidget({super.key, required this.body, required this.appBar, this.topMargin = 10});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return  Column(children: [
      widget.appBar,

      Expanded(child: Container(
        margin: EdgeInsets.only(top: widget.topMargin),
        width: Dimensions.webMaxWidth,
        decoration:  BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25), topLeft: Radius.circular(25),
        ),
          color: Theme.of(context).cardColor,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
            child: widget.body,
        ),
      )),

    ]);
  }
}
