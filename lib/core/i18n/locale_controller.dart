import 'package:flutter/material.dart';

/// App-wide language state. Toggles between English (LTR) and Arabic (RTL).
///
/// The whole widget tree reads [locale] / [textDirection] through Provider so
/// switching language re-lays-out and re-localizes every screen.
class LocaleController extends ChangeNotifier {
  LocaleController({Locale initial = const Locale('en'), this.onChanged})
      : _locale = initial;

  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  /// Invoked whenever the locale changes — used to persist the choice. Optional
  /// so tests can construct the controller without any storage side effects.
  final void Function(Locale)? onChanged;

  Locale _locale;
  Locale get locale => _locale;

  bool get isArabic => _locale.languageCode == 'ar';

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  void toggle() => setLocale(isArabic ? english : arabic);

  void setLocale(Locale locale) {
    if (locale == _locale) return;
    _locale = locale;
    onChanged?.call(_locale);
    notifyListeners();
  }
}
