import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography tokens for the design system.
///
/// - [serif] (Cormorant Garamond): display & headings — scholarly, institutional.
/// - [sans] (Inter): body, labels, all functional UI text.
/// - [arabicFamily] (Amiri): every Arabic string in the app.
///
/// If the bundled font assets are unavailable at build time, set
/// [useBundledFonts] to false and the app falls back to system fonts so it
/// still runs (weights/sizes are preserved).
abstract final class AppTypography {
  static const bool useBundledFonts = true;

  static String? get serif => useBundledFonts ? 'Cormorant Garamond' : null;
  static String? get sans => useBundledFonts ? 'Inter' : null;
  static String get arabicFamily => useBundledFonts ? 'Amiri' : 'serif';

  /// Arabic text style helper — always Amiri, RTL-friendly, slightly larger
  /// line height for legibility of harakat.
  static TextStyle arabic({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.charcoal,
    double height = 1.6,
  }) {
    return TextStyle(
      fontFamily: arabicFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  /// Base text theme built on Inter (sans) with Cormorant (serif) for the
  /// large display/headline roles.
  static TextTheme get textTheme => TextTheme(
        displayLarge: TextStyle(
          fontFamily: serif,
          fontSize: 40,
          fontWeight: FontWeight.w600,
          height: 1.1,
          color: AppColors.charcoal,
        ),
        displayMedium: TextStyle(
          fontFamily: serif,
          fontSize: 34,
          fontWeight: FontWeight.w600,
          height: 1.15,
          color: AppColors.charcoal,
        ),
        displaySmall: TextStyle(
          fontFamily: serif,
          fontSize: 30,
          fontWeight: FontWeight.w600,
          height: 1.2,
          color: AppColors.charcoal,
        ),
        headlineMedium: TextStyle(
          fontFamily: serif,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.2,
          color: AppColors.charcoal,
        ),
        headlineSmall: TextStyle(
          fontFamily: serif,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.25,
          color: AppColors.charcoal,
        ),
        titleLarge: TextStyle(
          fontFamily: sans,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: AppColors.charcoal,
        ),
        titleMedium: TextStyle(
          fontFamily: sans,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: AppColors.charcoal,
        ),
        titleSmall: TextStyle(
          fontFamily: sans,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: AppColors.charcoal,
        ),
        bodyLarge: TextStyle(
          fontFamily: sans,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: AppColors.charcoal,
        ),
        bodyMedium: TextStyle(
          fontFamily: sans,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: AppColors.textMuted,
        ),
        bodySmall: TextStyle(
          fontFamily: sans,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: AppColors.textMuted,
        ),
        labelLarge: TextStyle(
          fontFamily: sans,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: AppColors.charcoal,
        ),
        labelMedium: TextStyle(
          fontFamily: sans,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
          color: AppColors.textMuted,
        ),
        labelSmall: TextStyle(
          fontFamily: sans,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: AppColors.textMuted,
        ),
      );
}
