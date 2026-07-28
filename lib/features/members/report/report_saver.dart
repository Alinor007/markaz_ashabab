import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../widgets/feedback/app_snackbar.dart';

/// Generates a report PDF off the UI thread (so a large dataset never
/// freezes the interface) and writes it straight to the user's Downloads
/// folder, reporting the saved path. Shared by every report kind (Members
/// Report, Class Tutorial Report, …) — [filenamePrefix] names the file and
/// [build] does the actual PDF rendering (typically via `Isolate.run`, since
/// the caller already has the report's isolate-sendable data ready to hand
/// off; this function only loads the logo, which isolates can't do via
/// `rootBundle`).
Future<void> downloadReport(
  BuildContext context, {
  required String filenamePrefix,
  required Future<Uint8List> Function(Uint8List logoBytes) build,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  showAppSnackBar(
    context,
    'Generating report…',
    tone: SnackTone.info,
  );

  try {
    final logoAsset = await rootBundle.load('assets/images/logo.png');
    final bytes = await build(logoAsset.buffer.asUint8List());
    final file = await _write(filenamePrefix, bytes);
    if (!context.mounted) return;
    messenger.clearSnackBars();
    showAppSnackBar(
      context,
      'Report saved to ${file.path}',
      tone: SnackTone.success,
      // Long enough to actually read the destination path.
      duration: const Duration(seconds: 8),
    );
  } catch (e) {
    if (!context.mounted) return;
    messenger.clearSnackBars();
    showAppSnackBar(
      context,
      'Failed to generate report: $e',
      tone: SnackTone.error,
      duration: const Duration(seconds: 8),
    );
  }
}

/// Subfolder every generated report lands in, inside the platform's
/// user-visible Downloads folder.
const _reportsFolder = 'markazosshabab_reports';

/// Writes [bytes] into the user-visible Downloads folder.
///
/// On Android that is shared storage — `/storage/emulated/0/Download/
/// $_reportsFolder` — which `path_provider` cannot return directly
/// (`getDownloadsDirectory` is desktop-only and throws on Android), so the
/// storage root is derived from the app-specific external directory instead
/// of being hardcoded, keeping multi-user devices and unusual mounts working.
Future<File> _write(String filenamePrefix, Uint8List bytes) async {
  final dir = await _reportsDir();

  final now = DateTime.now();
  String two(int v) => v.toString().padLeft(2, '0');
  // Timestamped so repeated exports never silently overwrite each other.
  final name = '${filenamePrefix}_'
      '${now.year}-${two(now.month)}-${two(now.day)}_'
      '${two(now.hour)}${two(now.minute)}${two(now.second)}.pdf';

  final file = File(p.join(dir.path, name));
  await file.writeAsBytes(bytes);
  return file;
}

Future<Directory> _reportsDir() async {
  if (Platform.isAndroid) {
    final external = await getExternalStorageDirectory();
    // …/Android/data/<package>/files → the shared-storage root is everything
    // before "/Android/".
    final root = external?.path.split('/Android/').first;
    if (root != null && root.isNotEmpty) {
      final shared = Directory(p.join(root, 'Download', _reportsFolder));
      try {
        if (!await shared.exists()) await shared.create(recursive: true);
        return shared;
      } on FileSystemException {
        // Shared storage blocked (scoped storage / no permission) — fall back
        // to app-specific external storage, which never needs a permission.
      }
    }
    final fallback = external ?? await getApplicationDocumentsDirectory();
    return _ensure(Directory(p.join(fallback.path, _reportsFolder)));
  }

  Directory? downloads;
  try {
    downloads = await getDownloadsDirectory();
  } on UnsupportedError {
    downloads = null;
  }
  downloads ??= await getApplicationDocumentsDirectory();
  return _ensure(Directory(p.join(downloads.path, _reportsFolder)));
}

Future<Directory> _ensure(Directory dir) async {
  if (!await dir.exists()) await dir.create(recursive: true);
  return dir;
}
