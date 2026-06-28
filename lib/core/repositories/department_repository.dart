import 'package:drift/drift.dart';

import '../data/app_database.dart';

/// Departments and their activities.
class DepartmentRepository {
  DepartmentRepository(this._db);
  final AppDatabase _db;

  String _id(String p) => '${p}_${DateTime.now().microsecondsSinceEpoch}';

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
    required String nameAr,
    String description = '',
    String descriptionAr = '',
    String iconKey = 'group',
    int accent = 0xFF0B5D3B,
    String headName = '',
    String contactEmail = '',
    String contactPhone = '',
  }) {
    return _db.into(_db.departments).insert(DepartmentsCompanion.insert(
          id: _id('dept'),
          name: name,
          nameAr: Value(nameAr.isEmpty ? name : nameAr),
          description: Value(description),
          descriptionAr: Value(descriptionAr),
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

  // ── Head of Department (an assigned existing member) ──────────────────────
  /// Assigns (or clears, with null) the member who heads a department.
  Future<void> assignHead(String departmentId, String? memberId) =>
      (_db.update(_db.departments)..where((d) => d.id.equals(departmentId)))
          .write(DepartmentsCompanion(headMemberId: Value(memberId)));

  /// The member currently heading [departmentId], or null when unassigned.
  Stream<Member?> watchHead(String departmentId) {
    final query = _db.select(_db.members).join([
      innerJoin(_db.departments,
          _db.departments.headMemberId.equalsExp(_db.members.id)),
    ])
      ..where(_db.departments.id.equals(departmentId));
    return query.watchSingleOrNull().map((row) => row?.readTable(_db.members));
  }

  // ── Department staff (existing members) ───────────────────────────────────
  /// Members assigned as staff of [departmentId], by name.
  Stream<List<Member>> watchStaff(String departmentId) {
    final query = _db.select(_db.departmentStaff).join([
      innerJoin(_db.members,
          _db.members.id.equalsExp(_db.departmentStaff.memberId)),
    ])
      ..where(_db.departmentStaff.departmentId.equals(departmentId))
      ..orderBy([OrderingTerm(expression: _db.members.firstName)]);
    return query
        .watch()
        .map((rows) => rows.map((r) => r.readTable(_db.members)).toList());
  }

  Future<void> addStaff(String departmentId, String memberId) =>
      _db.into(_db.departmentStaff).insert(
            DepartmentStaffCompanion.insert(
              id: _id('staff'),
              departmentId: departmentId,
              memberId: memberId,
            ),
            mode: InsertMode.insertOrIgnore,
          );

  Future<void> removeStaff(String departmentId, String memberId) =>
      (_db.delete(_db.departmentStaff)
            ..where((s) =>
                s.departmentId.equals(departmentId) &
                s.memberId.equals(memberId)))
          .go();

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
    String titleAr = '',
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
            titleAr: Value(titleAr),
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
