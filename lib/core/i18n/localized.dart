import 'package:flutter/material.dart';

/// English-only text helpers.
///
/// The app was previously bilingual (English / Arabic); it is now English-only.
/// These helpers are retained so call sites keep a stable API, but they always
/// resolve to English.
extension LocalizedContext on BuildContext {
  /// Retained for source compatibility — the app is English-only.
  bool get isArabic => false;

  /// Returns the English string. The optional second argument is ignored and
  /// kept only so existing call sites continue to compile.
  String tr(String en, [String? ar]) => en;

  /// Retained for source compatibility — the app is English-only.
  bool get isArabicNow => false;

  /// Returns the English string (see [tr]).
  String trRead(String en, [String? ar]) => en;
}

/// Renders an English string. Kept as a thin wrapper over [Text] so existing
/// call sites (which used to pass an Arabic variant plus styling) continue to
/// work unchanged; the [ar] argument is ignored.
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

  /// Ignored (English-only); retained so call sites still compile.
  final Color? arabicColor;

  @override
  Widget build(BuildContext context) => Text(
        en,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
}
