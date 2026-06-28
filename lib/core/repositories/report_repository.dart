import 'package:drift/drift.dart';

import '../data/app_database.dart';

/// Department reports with filtering by department, year, and type.
class ReportRepository {
  ReportRepository(this._db);
  final AppDatabase _db;

  String _id() => 'report_${DateTime.now().microsecondsSinceEpoch}';

  Stream<List<Report>> watchAll() => (_db.select(_db.reports)
        ..orderBy([(r) => OrderingTerm.desc(r.date)]))
      .watch();

  Stream<List<Report>> watchByDepartment(String departmentId) =>
      (_db.select(_db.reports)
            ..where((r) => r.departmentId.equals(departmentId))
            ..orderBy([(r) => OrderingTerm.desc(r.date)]))
          .watch();

  Future<List<Report>> getAll() => _db.select(_db.reports).get();

  Future<int> count() async => (await getAll()).length;

  Future<Report?> getById(String id) =>
      (_db.select(_db.reports)..where((r) => r.id.equals(id)))
          .getSingleOrNull();

  Future<void> create({
    required String departmentId,
    required String title,
    String titleAr = '',
    String summary = '',
    String summaryAr = '',
    String date = '',
    required int year,
    required String type,
    int pages = 1,
    String formData = '',
  }) {
    return _db.into(_db.reports).insert(ReportsCompanion.insert(
          id: _id(),
          departmentId: departmentId,
          title: title,
          titleAr: Value(titleAr),
          summary: Value(summary),
          summaryAr: Value(summaryAr),
          date: Value(date),
          year: Value(year),
          type: Value(type),
          pages: Value(pages),
          formData: Value(formData),
        ));
  }

  Future<void> update(String id, ReportsCompanion data) =>
      (_db.update(_db.reports)..where((r) => r.id.equals(id))).write(data);

  Future<void> delete(String id) =>
      (_db.delete(_db.reports)..where((r) => r.id.equals(id))).go();
}
