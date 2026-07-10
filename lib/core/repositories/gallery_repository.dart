import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/app_database.dart';
import '../util/photo_service.dart';

/// Gallery archive photos. Each entry is an album of one or more images stored
/// as files (only the paths are kept in the database — never image BLOBs).
class GalleryRepository {
  GalleryRepository(this._db, [this._photos = const PhotoService()]);
  final AppDatabase _db;
  final PhotoService _photos;

  String _id() => 'photo_${DateTime.now().microsecondsSinceEpoch}';

  /// All image paths in an entry's album (falls back to the single cover path
  /// for legacy entries).
  static List<String> imagesOf(GalleryPhoto p) {
    if (p.imagePaths.trim().isNotEmpty) {
      return (jsonDecode(p.imagePaths) as List).map((e) => '$e').toList();
    }
    return p.imagePath.isEmpty ? const [] : [p.imagePath];
  }

  Stream<List<GalleryPhoto>> watchAll() => (_db.select(_db.galleryPhotos)
        ..orderBy([(p) => OrderingTerm.desc(p.year)]))
      .watch();

  Future<List<GalleryPhoto>> getAll() => _db.select(_db.galleryPhotos).get();

  Future<int> count() async => (await getAll()).length;

  Future<void> add({
    required String title,
    String titleAr = '',
    required int year,
    String event = '',
    String eventAr = '',
    String iconKey = 'photo',
    int accent = 0xFF0B5D3B,
    List<String> imagePaths = const [],
    int heightHint = 220,
    String? reportId,
  }) {
    return _db.into(_db.galleryPhotos).insert(GalleryPhotosCompanion.insert(
          id: _id(),
          title: title,
          year: Value(year),
          event: Value(event),
          iconKey: Value(iconKey),
          accent: Value(accent),
          // Cover = first image (kept for the masonry thumbnail).
          imagePath: Value(imagePaths.isNotEmpty ? imagePaths.first : ''),
          imagePaths: Value(jsonEncode(imagePaths)),
          heightHint: Value(heightHint),
          reportId: Value(reportId),
        ));
  }

  /// The album linked to a Program Completion Report (Form P-2), or null.
  Future<GalleryPhoto?> getForReport(String reportId) =>
      (_db.select(_db.galleryPhotos)..where((p) => p.reportId.equals(reportId)))
          .getSingleOrNull();

  /// Watches the album linked to [reportId] (for the report view screen).
  Stream<GalleryPhoto?> watchForReport(String reportId) =>
      (_db.select(_db.galleryPhotos)..where((p) => p.reportId.equals(reportId)))
          .watchSingleOrNull();

  /// Creates or updates the single Gallery album that holds a report's uploaded
  /// photos. Files dropped from [imagePaths] are removed from disk. When the
  /// report has no photos, any existing linked album is deleted.
  Future<void> setAlbumForReport({
    required String reportId,
    required String title,
    required int year,
    required List<String> imagePaths,
    String iconKey = 'photo',
    int accent = 0xFF0B5D3B,
  }) async {
    final existing = await getForReport(reportId);
    final previous = existing == null ? const <String>[] : imagesOf(existing);

    if (imagePaths.isEmpty) {
      if (existing != null) await delete(existing.id);
      return;
    }

    if (existing == null) {
      await add(
        title: title,
        year: year,
        iconKey: iconKey,
        accent: accent,
        imagePaths: imagePaths,
        reportId: reportId,
      );
    } else {
      await (_db.update(_db.galleryPhotos)
            ..where((p) => p.id.equals(existing.id)))
          .write(GalleryPhotosCompanion(
        title: Value(title),
        year: Value(year),
        imagePath: Value(imagePaths.first),
        imagePaths: Value(jsonEncode(imagePaths)),
      ));
    }

    // Clean up files no longer referenced.
    for (final path in previous) {
      if (!imagePaths.contains(path)) await _photos.deleteStored(path);
    }
  }

  Future<void> delete(String id) async {
    final photo = await (_db.select(_db.galleryPhotos)
          ..where((p) => p.id.equals(id)))
        .getSingleOrNull();
    await (_db.delete(_db.galleryPhotos)..where((p) => p.id.equals(id))).go();
    if (photo != null) {
      for (final path in imagesOf(photo)) {
        await _photos.deleteStored(path);
      }
    }
  }
}
