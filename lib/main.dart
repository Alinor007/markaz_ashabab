import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/markaz_app.dart';
import 'core/util/app_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Tablet, landscape-only archive system.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Restore the saved language (if any) before the first frame.
  final prefs = AppPreferences();
  final savedLocale = await prefs.loadLocale();

  runApp(MarkazApp(
    initialLocale: savedLocale,
    onLocaleChanged: prefs.saveLocale,
  ));
}
