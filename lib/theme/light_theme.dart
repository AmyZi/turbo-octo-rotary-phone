 import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/theme/custom_theme_color.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF14B19E),
  primaryColorDark: const Color(0xFF007B6C),
  disabledColor: const Color(0xFFBABFC4),
  scaffoldBackgroundColor: const Color(0xFF008C7B),
  shadowColor: Colors.black.withValues(alpha:0.03),
  textTheme:  const TextTheme(
    bodyMedium: TextStyle(color: Color(0xff1D2D2B)),
    bodySmall: TextStyle(color: Color(0xff6B7675)),
    bodyLarge: TextStyle(color: Color(0xff48615E)),
    titleMedium: TextStyle(color: Color(0xff1D2D2B)),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: const Color(0xFFEEEEEE)
  ),

  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),

  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF008C7B),
    secondary: Color(0xFF008C7B),
    error: Color(0xFFFF6767),
    surface: Color(0xFFF3F3F3),
    tertiary: Color(0xFF7CCD8B),
    tertiaryContainer: Color(0xFFC98B3E),
    secondaryContainer: Color(0xFFEE6464),
    onTertiary: Color(0xFFD9D9D9),
    onSecondary: Color(0xFF00FEE1),
    onSecondaryContainer: Color(0xFFA8C5C1),
    onTertiaryContainer: Color(0xFF425956),
    outline: Color(0xFF8CFFF1),
    onPrimaryContainer: Color(0xFFDEFFFB),
    primaryContainer: Color(0xFFFFA800),
    onErrorContainer: Color(0xFFFFE6AD),
    onPrimary: Color(0xFF14B19E),
    surfaceTint: Color(0xFF0B9722),
    errorContainer: Color(0xFFF6F6F6),
    inverseSurface: Color(0xFF0148AF),
    surfaceContainer: Color(0xFF0094FF),
    secondaryFixedDim: Color(0xff808080),
  ),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: const Color(0xFF14B19E))),

  extensions: <ThemeExtension<CustomThemeColors>>[
    CustomThemeColors.light(),
  ],
);
