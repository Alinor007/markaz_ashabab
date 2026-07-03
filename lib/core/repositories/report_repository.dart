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

  /// Reports from the two departments that track individual participants in
  /// their Program Completion Report (Form P-2) Participation Data — Da'wah
  /// and Human Capital (Tarbiya). Used to find which reports a given member
  /// participated in (see `ProgramReport.participantIds` in `formData`), for
  /// the member profile's auto-populated Activity History.
  Stream<List<Report>> watchParticipantTrackedReports() =>
      (_db.select(_db.reports)
            ..where((r) => r.departmentId.isIn(const ['dawah', 'human_capital']))
            ..orderBy([(r) => OrderingTerm.desc(r.date)]))
          .watch();

  Future<List<Report>> getAll() => _db.select(_db.reports).get();

  Future<int> count() async => (await getAll()).length;

  Future<Report?> getById(String id) =>
      (_db.select(_db.reports)..where((r) => r.id.equals(id)))
          .getSingleOrNull();

  /// Inserts a report and returns its generated id (used to link an uploaded
  /// photo album to the new report).
  Future<String> create({
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
  }) async {
    final id = _id();
    await _db.into(_db.reports).insert(ReportsCompanion.insert(
          id: id,
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
    return id;
  }

  Future<void> update(String id, ReportsCompanion data) =>
      (_db.update(_db.reports)..where((r) => r.id.equals(id))).write(data);

  Future<void> delete(String id) =>
      (_db.delete(_db.reports)..where((r) => r.id.equals(id))).go();
}
