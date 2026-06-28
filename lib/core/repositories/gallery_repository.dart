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
  }) {
    return _db.into(_db.galleryPhotos).insert(GalleryPhotosCompanion.insert(
          id: _id(),
          title: title,
          titleAr: Value(titleAr),
          year: Value(year),
          event: Value(event),
          eventAr: Value(eventAr),
          iconKey: Value(iconKey),
          accent: Value(accent),
          // Cover = first image (kept for the masonry thumbnail).
          imagePath: Value(imagePaths.isNotEmpty ? imagePaths.first : ''),
          imagePaths: Value(jsonEncode(imagePaths)),
          heightHint: Value(heightHint),
        ));
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
