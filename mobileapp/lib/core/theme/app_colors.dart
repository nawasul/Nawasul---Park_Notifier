import 'package:flutter/material.dart';

/// Brand tokens — orange accent + near-black surfaces.
class AppColors {
  AppColors._();

  static const seedColor = Color(0xFFF2572B);

  static const primary = Color(0xFFF2572B);
  static const primaryContainer = Color(0xFFFFE8E2);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryContainer = Color(0xFF171717);

  static const secondary = Color(0xFF4D4D4D);
  static const secondaryContainer = Color(0xFFECECEC);
  static const onSecondary = Color(0xFFFFFFFF);

  static const tertiaryAccent = Color(0xFF4D4D4D);

  static const background = Color(0xFFDEDEDE);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceContainer = Color(0xFFECECEC);
  static const surfaceContainerHigh = Color(0xFFD4D4D4);

  static const outline = Color(0xFF4D4D4D);
  static const outlineVariant = Color(0xFFCFCFCF);

  static const textPrimary = Color(0xFF171717);
  static const textSecondary = Color(0xFF4D4D4D);
  static const textMuted = Color(0xFF4D4D4D);

  /// Text on dark (#171717) surfaces.
  static const textOnDark = Color(0xFFFFFFFF);
  static const textOnDarkSecondary = Color(0xFFA0A0A0);
  static const surfaceDarkElevated = Color(0xFF222222);

  static const success = Color(0xFF1B7A52);
  static const successContainer = Color(0xFFDCF3E9);

  static const warning = Color(0xFFC45A00);
  static const warningContainer = Color(0xFFFFE8CC);

  static const error = Color(0xFFC62828);
  static const errorContainer = Color(0xFFFBE9E7);

  static const errorDark = Color(0xFF9E1F1F);

  // Legacy aliases (screens still reference these names)
  static const accent = tertiaryAccent;
  static const accentSoft = primaryContainer;
  static const primaryDark = Color(0xFFD94A24);
  static const borderSubtle = outlineVariant;
  static const surfaceElevated = surfaceContainer;
  static const successBg = successContainer;
  static const errorBg = errorContainer;

  /// Core brand palette shortcuts.
  static const brandDark = Color(0xFF171717);
  static const brandAccent = primary;
  static const brandGrey = secondary;
  static const brandLight = background;
}
