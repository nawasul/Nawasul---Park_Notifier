import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get displayL => GoogleFonts.poppins(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -0.8,
        color: AppColors.textPrimary,
      );

  static TextStyle get headingXL => displayL;

  static TextStyle get headingL => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get headingM => GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyL => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyM => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.textMuted,
      );

  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.surface,
      );

  static TextStyle get link => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: AppColors.primary,
        decoration: TextDecoration.underline,
        decorationColor: AppColors.primary,
      );

  static TextStyle arabicHeading(String text) => GoogleFonts.notoKufiArabic(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.5,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      );

  static TextStyle arabicBody(String text) => GoogleFonts.notoKufiArabic(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  static TextTheme get textTheme => TextTheme(
        displayLarge: displayL,
        headlineMedium: headingL,
        titleMedium: headingM,
        bodyLarge: bodyL,
        bodyMedium: bodyM,
        labelSmall: caption,
        labelLarge: button,
      );

  /// Arabic uses Noto Kufi. Latin stays on the Poppins text theme.
  static TextTheme textThemeFor(Locale locale) {
    if (locale.languageCode == 'ar') {
      return GoogleFonts.notoKufiArabicTextTheme(textTheme);
    }
    return textTheme;
  }
}
