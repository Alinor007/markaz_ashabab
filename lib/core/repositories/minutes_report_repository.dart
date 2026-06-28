import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/app_database.dart';
import '../util/photo_service.dart';

/// Executive Minutes-of-Meeting / Resolution reports (the sidebar Reports
/// archive). Each report owns an album of image paths stored as a JSON list.
class MinutesReportRepository {
  MinutesReportRepository(this._db, [this._photos = const PhotoService()]);
  final AppDatabase _db;
  final PhotoService _photos;

  String _id() => 'minrep_${DateTime.now().microsecondsSinceEpoch}';

  /// Decodes a report's stored image paths.
  static List<String> imagesOf(MinutesReport r) {
    if (r.imagePaths.trim().isEmpty) return const [];
    final decoded = jsonDecode(r.imagePaths);
    return (decoded as List).map((e) => '$e').toList();
  }

  Stream<List<MinutesReport>> watchAll() => (_db.select(_db.minutesReports)
        ..orderBy([
          (r) => OrderingTerm.desc(r.year),
          (r) => OrderingTerm.desc(r.createdAt),
        ]))
      .watch();

  Future<void> create({
    required String title,
    required int year,
    required String type,
    String content = '',
    List<String> imagePaths = const [],
  }) {
    return _db.into(_db.minutesReports).insert(MinutesReportsCompanion.insert(
          id: _id(),
          title: title,
          year: Value(year),
          type: Value(type),
          content: Value(content),
          imagePaths: Value(jsonEncode(imagePaths)),
        ));
  }

  Future<void> update(
    String id, {
    required String title,
    required int year,
    required String type,
    required String content,
    required List<String> imagePaths,
  }) {
    return (_db.update(_db.minutesReports)..where((r) => r.id.equals(id))).write(
      MinutesReportsCompanion(
        title: Value(title),
        year: Value(year),
        type: Value(type),
        content: Value(content),
        imagePaths: Value(jsonEncode(imagePaths)),
      ),
    );
  }

  /// Deletes a report and cleans up its stored image files.
  Future<void> delete(String id) async {
    final report = await (_db.select(_db.minutesReports)
          ..where((r) => r.id.equals(id)))
        .getSingleOrNull();
    await (_db.delete(_db.minutesReports)..where((r) => r.id.equals(id))).go();
    if (report != null) {
      for (final path in imagesOf(report)) {
        await _photos.deleteStored(path);
      }
    }
  }
}
