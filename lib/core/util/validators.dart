import 'package:flutter/widgets.dart';

import '../i18n/localized.dart';

/// Reusable, bilingual form validators.
///
/// Each method takes the [BuildContext] and resolves its message via
/// `context.trRead` (the read-based localization helper that is safe to call
/// during `FormState.validate()`, i.e. outside `build` — see
/// `lib/core/i18n/localized.dart`).
///
/// Usage:
/// ```dart
/// TextFormField(validator: (v) => Validators.required(context, v));
/// ```
///
/// "optional" validators allow an empty value and only validate the format when
/// the user has actually entered something.
abstract final class Validators {
  /// Non-empty (after trimming) required field.
  static String? required(BuildContext c, String? v) =>
      (v == null || v.trim().isEmpty) ? c.trRead('Required', 'مطلوب') : null;

  /// Empty allowed; otherwise must be a whole number within [min]..[max].
  static String? optionalInt(BuildContext c, String? v, {int? min, int? max}) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return null;
    final n = int.tryParse(s);
    if (n == null) {
      return c.trRead('Enter a whole number', 'أدخل رقمًا صحيحًا');
    }
    if (min != null && n < min) {
      return c.trRead('Must be $min or more', 'يجب أن يكون $min أو أكثر');
    }
    if (max != null && n > max) {
      return c.trRead('Must be $max or less', 'يجب أن يكون $max أو أقل');
    }
    return null;
  }

  /// Empty allowed; otherwise must be a non-negative number (int or decimal).
  static String? optionalAmount(BuildContext c, String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return null;
    final n = num.tryParse(s);
    if (n == null) {
      return c.trRead('Enter a valid amount', 'أدخل مبلغًا صحيحًا');
    }
    if (n < 0) {
      return c.trRead('Cannot be negative', 'لا يمكن أن يكون سالبًا');
    }
    return null;
  }

  /// Empty allowed; otherwise a sensible 4-digit year.
  static String? optionalYear(BuildContext c, String? v) =>
      optionalInt(c, v, min: 1900, max: DateTime.now().year + 2);

  /// Empty allowed; otherwise must look like an email address.
  static String? optionalEmail(BuildContext c, String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return null;
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return re.hasMatch(s)
        ? null
        : c.trRead('Enter a valid email', 'أدخل بريدًا إلكترونيًا صحيحًا');
  }

  /// Required + a minimum length (passwords).
  static String? password(BuildContext c, String? v, {int min = 4}) {
    if (v == null || v.isEmpty) return c.trRead('Required', 'مطلوب');
    if (v.length < min) {
      return c.trRead('At least $min characters', '$min أحرف على الأقل');
    }
    return null;
  }
}
