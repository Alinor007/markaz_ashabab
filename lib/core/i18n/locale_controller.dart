import 'package:flutter/material.dart';

/// App-wide language state. The app is English-only (LTR); Arabic support was
/// removed. This controller is retained (still provided app-wide) so existing
/// `context.watch<LocaleController>()` call sites keep compiling, but it always
/// reports English and never changes.
class LocaleController extends ChangeNotifier {
  LocaleController({Locale initial = const Locale('en'), this.onChanged});

  static const Locale english = Locale('en');

  /// Retained for constructor compatibility; never invoked (the locale is
  /// fixed to English).
  final void Function(Locale)? onChanged;

  Locale get locale => english;

  bool get isArabic => false;

  TextDirection get textDirection => TextDirection.ltr;
}
