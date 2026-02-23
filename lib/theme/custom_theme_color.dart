import 'package:flutter/material.dart';

class CustomThemeColors extends ThemeExtension<CustomThemeColors> {
  final Color blackColor;
  final Color infoColor;

  const CustomThemeColors({

    required this.blackColor,
    required this.infoColor,
  });

  // Predefined themes for light and dark modes
  factory CustomThemeColors.light() => const CustomThemeColors(
      blackColor: Color(0xFF000000),
      infoColor:  Color(0xFF0177CD)
  );

  factory CustomThemeColors.dark() => const CustomThemeColors(
      blackColor: Color(0xFF000000),
      infoColor:  Color(0xFF0177CD)
  );

  @override
  CustomThemeColors copyWith({
    Color? blackColor,
    Color? infoColor,
  }) {
    return CustomThemeColors(
        blackColor: blackColor ?? this.blackColor,
        infoColor: infoColor ?? this.infoColor
    );
  }

  @override
  CustomThemeColors lerp(ThemeExtension<CustomThemeColors>? other, double t) {
    if (other is! CustomThemeColors) return this;

    return CustomThemeColors(
      blackColor: Color.lerp(blackColor, other.blackColor, t)!,
      infoColor: Color.lerp(infoColor, other.infoColor, t)!,
    );
  }
}