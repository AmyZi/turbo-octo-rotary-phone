import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';

class ThemeButton extends StatelessWidget {
  final bool isDarkTheme;
  final bool isSelected;
  const ThemeButton({super.key, required this.isDarkTheme, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () => Get.find<ThemeController>().changeThemeSetting(isDarkTheme),
      child: Row(children: [
        Container(height: 15, width: 15,
          decoration: BoxDecoration(shape: BoxShape.circle,
            color: Theme.of(context).hintColor.withValues(alpha:0.2)),
          child: isSelected ?
          Center(child: Icon(Icons.circle, size: 10, color: Get.isDarkMode? Colors.white: Colors.black)) :
          const SizedBox.shrink()),
        const SizedBox(width: 7),

        Text(isDarkTheme ? 'dark'.tr : 'light'.tr),

      ]),
    );
  }
}
