import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_typography.dart';
import 'locale_controller.dart';

/// Localization conveniences for feature modules.
///
/// Rather than threading every label through the central [AppStrings] table,
/// module-local strings can be supplied inline as (english, arabic) pairs.
extension LocalizedContext on BuildContext {
  bool get isArabic => watch<LocaleController>().isArabic;

  /// Pick the english or arabic variant for the active language.
  ///
  /// Uses [watch], so it rebuilds on language change — only call from `build`.
  String tr(String en, String ar) => isArabic ? ar : en;

  /// Non-listening language check, safe to call from callbacks, validators,
  /// and async gaps (does not register a build dependency).
  bool get isArabicNow => read<LocaleController>().isArabic;

  /// Like [tr] but safe outside `build` (event handlers, validators).
  String trRead(String en, String ar) => isArabicNow ? ar : en;
}

/// Renders a bilingual string: the Arabic variant (in Amiri, RTL) when the
/// language is Arabic, otherwise the English variant in the provided style.
class LocalizedText extends StatelessWidget {
  const LocalizedText(
    this.en,
    this.ar, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.arabicColor,
  });

  final String en;
  final String ar;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  /// Optional override color for the Arabic rendering (defaults to [style] color).
  final Color? arabicColor;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final base = style ?? DefaultTextStyle.of(context).style;
    if (!isArabic) {
      return Text(en,
          style: base,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);
    }
    return Text(
      ar,
      textDirection: TextDirection.rtl,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: AppTypography.arabic(
        fontSize: base.fontSize ?? 16,
        fontWeight: base.fontWeight ?? FontWeight.w400,
        color: arabicColor ?? base.color ?? const Color(0xFF22251F),
        height: base.height ?? 1.5,
      ),
    );
  }
}
