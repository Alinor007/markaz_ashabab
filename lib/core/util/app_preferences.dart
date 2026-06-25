import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A tiny on-device key/value store for lightweight UI preferences (currently
/// the chosen language). Backed by a JSON file in the app support directory —
/// no extra plugin or drift table required.
///
/// Every operation is defensive: if the platform channel is unavailable (e.g.
/// in unit tests) or the file is missing/corrupt, it degrades to defaults
/// instead of throwing, so callers never need a try/catch.
class AppPreferences {
  AppPreferences();

  static const _fileName = 'preferences.json';
  static const _localeKey = 'locale';

  File? _cachedFile;

  Future<File?> _file() async {
    if (_cachedFile != null) return _cachedFile;
    try {
      final dir = await getApplicationSupportDirectory();
      return _cachedFile = File(p.join(dir.path, _fileName));
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> _read() async {
    try {
      final file = await _file();
      if (file == null || !await file.exists()) return {};
      final raw = await file.readAsString();
      if (raw.trim().isEmpty) return {};
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : {};
    } catch (_) {
      return {};
    }
  }

  Future<void> _write(Map<String, dynamic> data) async {
    try {
      final file = await _file();
      if (file == null) return;
      await file.writeAsString(jsonEncode(data));
    } catch (_) {
      // Best-effort: a failed write simply means the preference isn't saved.
    }
  }

  /// Returns the persisted locale, or null if none was saved.
  Future<Locale?> loadLocale() async {
    final code = (await _read())[_localeKey];
    if (code is String && code.isNotEmpty) return Locale(code);
    return null;
  }

  /// Persists [locale] by its language code.
  Future<void> saveLocale(Locale locale) async {
    final data = await _read();
    data[_localeKey] = locale.languageCode;
    await _write(data);
  }
}
