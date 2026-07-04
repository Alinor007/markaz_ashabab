import 'package:flutter/widgets.dart';

/// Localization conveniences for feature modules.
///
/// The app is English-only. These helpers are retained so existing call sites
/// keep working: the language check is always `false` and the bilingual
/// `tr(...)` pickers always return the English variant. The optional Arabic
/// argument is ignored.
extension LocalizedContext on BuildContext {
  bool get isArabic => false;

  /// Always returns the English variant (the app is English-only).
  String tr(String en, [String? ar]) => en;

  /// Non-listening variant of [isArabic], kept for callback/validator call
  /// sites. Always `false`.
  bool get isArabicNow => false;

  /// Always returns the English variant (the app is English-only).
  String trRead(String en, [String? ar]) => en;
}
