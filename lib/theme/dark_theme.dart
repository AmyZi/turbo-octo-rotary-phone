import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/theme/custom_theme_color.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF00735f),
  primaryColorDark: const Color(0xff016655),
  disabledColor: const Color(0xFFBABFC4),
  scaffoldBackgroundColor: const Color(0xFF163935),
  canvasColor: const Color(0xFF1C1F1F),
  shadowColor: Colors.white.withValues(alpha:0.03),
  brightness: Brightness.dark,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: const Color(0xFF242424),
  textTheme:  const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Color(0xffd5e1e0)),
    bodyLarge: TextStyle(color: Color(0xffffffff)),
    titleMedium: TextStyle(color: Color(0xff1D2D2B)),
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF02B8A2),
    error: Color(0xFFFF6767),
    surface: Color(0xFFF3F3F3),
    secondary: Color(0xFF008C7B),
    tertiary: Color(0xFF7CCD8B),
    tertiaryContainer: Color(0xFFC98B3E),
    secondaryContainer: Color(0xFFEE6464),
    onTertiary: Color(0xFFD9D9D9),
    onSecondary: Color(0xFF00FEE1),
    onSecondaryContainer: Color(0xFFA8C5C1),
    onTertiaryContainer: Color(0xFF425956),
    outline: Color(0xFF8CFFF1),
    onPrimaryContainer: Color(0xFFDEFFFB),
    errorContainer: Color(0xFFF6F6F6),
    primaryContainer: Color(0xFFFFA800),
    onSurface: Color(0xFFFFE6AD),
    onPrimary: Color(0xFF14B19E),
    inverseSurface: Color(0xFF0148AF),
    surfaceContainer: Color(0xFF0094FF),
    secondaryFixedDim: Color(0xff808080),

  ),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: const Color(0xFF00735f))),

  extensions: <ThemeExtension<CustomThemeColors>>[
    CustomThemeColors.dark(),
  ],
);
