import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/theme/custom_theme_color.dart';


extension ContextInfo on BuildContext {
  //theme context
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  CustomThemeColors get customThemeColors => theme.extension<CustomThemeColors>()!;

  //scaffold context
  ScaffoldMessengerState get scaffoldMessengerState => ScaffoldMessenger.of(this);



}