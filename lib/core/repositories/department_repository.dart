import 'package:drift/drift.dart';

import '../data/app_database.dart';
import '../data/models.dart';

/// Departments and their activities.
class DepartmentRepository {
  DepartmentRepository(this._db);
  final AppDatabase _db;

  String _id(String p) => newId(p);

  // ── Departments ──────────────────────────────────────────────────────────
  Stream<List<Department>> watchAll() => (_db.select(_db.departments)
        ..orderBy([(d) => OrderingTerm(expression: d.sortOrder)]))
      .watch();

  Future<List<Department>> getAll() => _db.select(_db.departments).get();

  Future<Department?> getById(String id) =>
      (_db.select(_db.departments)..where((d) => d.id.equals(id)))
          .getSingleOrNull();

  /// Watches a single department so the detail screen reflects edits live.
  Stream<Department?> watchById(String id) =>
      (_db.select(_db.departments)..where((d) => d.id.equals(id)))
          .watchSingleOrNull();

  Future<int> count() async => (await getAll()).length;

  Future<void> create({
    required String name,
    String description = '',
    String iconKey = 'group',
    int accent = 0xFF0B5D3B,
    String headName = '',
    String contactEmail = '',
    String contactPhone = '',
  }) {
    return _db.into(_db.departments).insert(DepartmentsCompanion.insert(
          id: _id('dept'),
          name: name,
          description: Value(description),
          iconKey: Value(iconKey),
          accent: Value(accent),
          headName: Value(headName),
          contactEmail: Value(contactEmail),
          contactPhone: Value(contactPhone),
          sortOrder: const Value(99),
        ));
  }

  Future<void> update(String id, DepartmentsCompanion data) =>
      (_db.update(_db.departments)..where((d) => d.id.equals(id))).write(data);

  // Heads and staff are manually entered position holders stored in the
  // Leaders table under `dept_head_<id>` / `dept_staff_<id>` category codes —
  // see LeaderRepository. The legacy headMemberId column and DepartmentStaff
  // table remain in the schema but are no longer written.

  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.deptActivities)
            ..where((a) => a.departmentId.equals(id)))
          .go();
      await (_db.delete(_db.departments)..where((d) => d.id.equals(id))).go();
    });
  }

  // ── Activities ───────────────────────────────────────────────────────────
  Stream<List<DeptActivity>> watchActivities(String departmentId) =>
      (_db.select(_db.deptActivities)
            ..where((a) => a.departmentId.equals(departmentId))
            ..orderBy([(a) => OrderingTerm.desc(a.date)]))
          .watch();

  /// Watches a single activity so the read-only view screen reflects edits live.
  Stream<DeptActivity?> watchActivity(String id) =>
      (_db.select(_db.deptActivities)..where((a) => a.id.equals(id)))
          .watchSingleOrNull();

  Future<int> activityCount(String departmentId) async =>
      (await (_db.select(_db.deptActivities)
                ..where((a) => a.departmentId.equals(departmentId)))
              .get())
          .length;

  /// Total activities across all departments (dashboard stat).
  Future<int> totalActivities() async =>
      (await _db.select(_db.deptActivities).get()).length;

  Future<void> addActivity({
    required String departmentId,
    required String title,
    String description = '',
    String date = '',
    String status = 'planned',
    int attendance = 0,
    String formData = '',
  }) =>
      _db.into(_db.deptActivities).insert(DeptActivitiesCompanion.insert(
            id: _id('act'),
            departmentId: departmentId,
            title: title,
            description: Value(description),
            date: Value(date),
            status: Value(status),
            attendance: Value(attendance),
            formData: Value(formData),
          ));

  Future<void> updateActivity(String id,
          {required String title,
          required String description,
          required String date,
          required String status,
          required int attendance,
          String formData = ''}) =>
      (_db.update(_db.deptActivities)..where((a) => a.id.equals(id)))
          .write(DeptActivitiesCompanion(
        title: Value(title),
        description: Value(description),
        date: Value(date),
        status: Value(status),
        attendance: Value(attendance),
        formData: Value(formData),
      ));

  Future<void> deleteActivity(String id) =>
      (_db.delete(_db.deptActivities)..where((a) => a.id.equals(id))).go();
}
