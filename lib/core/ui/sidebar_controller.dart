import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether the app sidebar is collapsed to an icon-only rail. Global —
/// applies across every screen — and persisted across app restarts.
class SidebarController extends ChangeNotifier {
  static const _prefsKey = 'sidebar_collapsed';

  bool _collapsed = false;
  bool get collapsed => _collapsed;

  /// Loads the persisted state. Call once at app startup; the sidebar
  /// renders expanded until this resolves. Swallows failures (e.g. no
  /// platform implementation registered, as in widget tests) so a missing
  /// preferences backend can never crash the app — it just stays expanded.
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _collapsed = prefs.getBool(_prefsKey) ?? false;
      notifyListeners();
    } catch (_) {
      // No-op: keep the default (expanded).
    }
  }

  Future<void> toggle() async {
    _collapsed = !_collapsed;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, _collapsed);
    } catch (_) {
      // No-op: the in-memory toggle still applies for this session.
    }
  }
}
