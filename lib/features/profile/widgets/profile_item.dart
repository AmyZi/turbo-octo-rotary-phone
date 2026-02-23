import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final String icon;
  final Function()? onTap;
  final bool divider;
  const ProfileMenuItem({super.key, required this.title, required this.icon, this.onTap,this.divider = true});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      SizedBox( child: ListTile(

        leading: Image.asset(icon,width: 20,height: 20,fit: BoxFit.cover,color: Theme.of(context).primaryColor),
        title: Text(title.tr, style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.9))),
        onTap: onTap,
      )),

      divider ? Divider(color: Theme.of(context).primaryColor.withValues(alpha:0.2),thickness: 0.8) : const SizedBox(),

    ]);
  }
}