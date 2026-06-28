import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Picks an image from the device gallery and copies it into the app's
/// documents directory so the path remains valid after the picker cache is
/// cleared. Returns the stored absolute path, or null if cancelled.
class PhotoService {
  const PhotoService();

  /// Picks an image and copies it into [subfolder] under the app documents
  /// directory. Member photos use the default; the gallery passes
  /// `gallery_photos`.
  Future<String?> pickAndStore({String subfolder = 'member_photos'}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(dir.path, subfolder));
    if (!photosDir.existsSync()) {
      photosDir.createSync(recursive: true);
    }
    final ext = p.extension(picked.path);
    final dest = p.join(
        photosDir.path, 'photo_${DateTime.now().microsecondsSinceEpoch}$ext');
    await File(picked.path).copy(dest);
    return dest;
  }

  /// Picks one or more images at full resolution (no size cap) and copies each
  /// into [subfolder] under the app documents directory. Returns the stored
  /// paths (empty if cancelled).
  Future<List<String>> pickMultipleAndStore(
      {String subfolder = 'gallery_photos'}) async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isEmpty) return const [];

    final dir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(dir.path, subfolder));
    if (!photosDir.existsSync()) {
      photosDir.createSync(recursive: true);
    }
    final stored = <String>[];
    var i = 0;
    for (final x in picked) {
      final ext = p.extension(x.path);
      final dest = p.join(photosDir.path,
          'photo_${DateTime.now().microsecondsSinceEpoch}_${i++}$ext');
      await File(x.path).copy(dest);
      stored.add(dest);
    }
    return stored;
  }

  /// Removes a previously stored image file. Safe to call with a null/empty
  /// path or a path that no longer exists; IO errors are swallowed so callers
  /// (e.g. delete flows) never fail because of file cleanup.
  Future<void> deleteStored(String? path) async {
    if (path == null || path.trim().isEmpty) return;
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // Best-effort cleanup.
    }
  }
}
