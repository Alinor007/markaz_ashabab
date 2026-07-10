import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/markaz_app.dart';

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

  runApp(const MarkazApp());
}
