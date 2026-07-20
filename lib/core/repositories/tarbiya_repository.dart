import 'package:drift/drift.dart';

import '../data/app_database.dart';
import '../data/models.dart';

/// Member counts for a tarbiya level (or shu'ba).
class LevelCounts {
  const LevelCounts({this.total = 0, this.active = 0});
  final int total;
  final int active;
  int get inactive => total - active;
}

/// A derived tutorial class: the members of one shu'ba level who share the
/// same Naqib (teacher) AND the same section (usraName). There is no Classes
/// table — classes exist only as this grouping over member rows.
class TutorialClass {
  const TutorialClass({
    required this.teacher,
    required this.section,
    required this.students,
  });

  final Member teacher;
  final String section;
  final List<Member> students;

  /// Year/schedule are per-student columns; a class shows the first student's
  /// values (individually edited students could diverge — derived-view limit).
  String get year => students.isEmpty ? '' : students.first.usraEstablishedYear;
  String get schedule =>
      students.isEmpty ? '' : students.first.usraMeetingSchedule;
}

/// Per-area rollup (shu'ba count, member count, gender split) for the Areas
/// directory cards.
class AreaStats {
  const AreaStats(
      {this.shubaCount = 0, this.memberCount = 0, this.female = 0, this.male = 0});
  final int shubaCount;
  final int memberCount;
  final int female;
  final int male;
}

/// Per-shu'ba member count and gender split for the Shu'bas directory cards.
class ShubaStats {
  const ShubaStats({this.memberCount = 0, this.female = 0, this.male = 0});
  final int memberCount;
  final int female;
  final int male;
}

/// Areas → Shu'bas → Members (by level) for the Tarbiya Al-Kawadeer module.
class TarbiyaRepository {
  TarbiyaRepository(this._db);
  final AppDatabase _db;

  // ── Areas ──────────────────────────────────────────────────────────────
  Stream<List<TarbiyaArea>> watchAreas() => (_db.select(_db.tarbiyaAreas)
        ..orderBy([(a) => OrderingTerm(expression: a.sortOrder)]))
      .watch();

  Future<List<TarbiyaArea>> getAreas() => _db.select(_db.tarbiyaAreas).get();

  Future<TarbiyaArea?> getArea(String id) =>
      (_db.select(_db.tarbiyaAreas)..where((a) => a.id.equals(id)))
          .getSingleOrNull();

  /// Per-area rollup (shu'ba count, member count, gender split) for the
  /// Areas directory cards. A left-outer join so areas/shu'bas with zero
  /// members still get an entry.
  Stream<Map<String, AreaStats>> watchAreaStats() {
    final query = _db.select(_db.shubas).join([
      leftOuterJoin(
          _db.members,
          _db.members.shubaId.equalsExp(_db.shubas.id) &
              _db.members.approval.equals('approved')),
    ]);
    return query.watch().map((rows) {
      final shubaIds = <String, Set<String>>{};
      final member = <String, int>{};
      final female = <String, int>{};
      final male = <String, int>{};
      for (final row in rows) {
        final shuba = row.readTable(_db.shubas);
        (shubaIds[shuba.areaId] ??= {}).add(shuba.id);
        final m = row.readTableOrNull(_db.members);
        if (m != null) {
          member[shuba.areaId] = (member[shuba.areaId] ?? 0) + 1;
          if (m.gender == 'F') {
            female[shuba.areaId] = (female[shuba.areaId] ?? 0) + 1;
          } else {
            male[shuba.areaId] = (male[shuba.areaId] ?? 0) + 1;
          }
        }
      }
      return {
        for (final areaId in shubaIds.keys)
          areaId: AreaStats(
            shubaCount: shubaIds[areaId]!.length,
            memberCount: member[areaId] ?? 0,
            female: female[areaId] ?? 0,
            male: male[areaId] ?? 0,
          ),
      };
    });
  }

  Future<void> createArea({
    required String name,
    String region = '',
    int accent = 0xFF0B5D3B,
  }) {
    return _db.into(_db.tarbiyaAreas).insert(
          TarbiyaAreasCompanion.insert(
            id: _id('area'),
            name: name,
            region: Value(region),
            accent: Value(accent),
          ),
        );
  }

  Future<void> updateArea(String id, {required String name}) {
    return (_db.update(_db.tarbiyaAreas)..where((a) => a.id.equals(id))).write(
      TarbiyaAreasCompanion(
        name: Value(name),
      ),
    );
  }

  /// Deletes an area and everything beneath it. The shuba→area and
  /// member→shuba foreign keys are RESTRICT, so the descendants are cleared
  /// explicitly (member sub-records then cascade off the member rows).
  Future<void> deleteArea(String id) async {
    await _db.transaction(() async {
      final shubaIds = (await (_db.select(_db.shubas)
                ..where((s) => s.areaId.equals(id)))
              .get())
          .map((s) => s.id)
          .toList();
      if (shubaIds.isNotEmpty) {
        await (_db.delete(_db.members)..where((m) => m.shubaId.isIn(shubaIds)))
            .go();
        await (_db.delete(_db.shubas)..where((s) => s.areaId.equals(id))).go();
      }
      await (_db.delete(_db.tarbiyaAreas)..where((a) => a.id.equals(id))).go();
    });
  }

  // ── Shu'bas ────────────────────────────────────────────────────────────
  Stream<List<Shuba>> watchShubas(String areaId) => (_db.select(_db.shubas)
        ..where((s) => s.areaId.equals(areaId))
        ..orderBy([(s) => OrderingTerm(expression: s.name)]))
      .watch();

  Future<Shuba?> getShuba(String id) =>
      (_db.select(_db.shubas)..where((s) => s.id.equals(id)))
          .getSingleOrNull();

  /// Every shu'ba across all areas (used by the Members Management directory).
  Future<List<Shuba>> getAllShubas() => _db.select(_db.shubas).get();

  /// Per-shu'ba member count and gender split, scoped to one area — for the
  /// Shu'bas directory cards.
  Stream<Map<String, ShubaStats>> watchShubaStats(String areaId) {
    final query = _db.select(_db.members).join([
      innerJoin(_db.shubas, _db.shubas.id.equalsExp(_db.members.shubaId)),
    ])
      ..where(_db.shubas.areaId.equals(areaId) &
          _db.members.approval.equals('approved'));
    return query.watch().map((rows) {
      final counts = <String, ShubaStats>{};
      for (final row in rows) {
        final m = row.readTable(_db.members);
        final existing = counts[m.shubaId] ?? const ShubaStats();
        counts[m.shubaId] = ShubaStats(
          memberCount: existing.memberCount + 1,
          female: existing.female + (m.gender == 'F' ? 1 : 0),
          male: existing.male + (m.gender == 'F' ? 0 : 1),
        );
      }
      return counts;
    });
  }

  /// Assigns (or clears, with null) the Shu'ba's Mas'ul (Person-in-Charge).
  Future<void> assignMasul(String shubaId, String? memberId) =>
      (_db.update(_db.shubas)..where((s) => s.id.equals(shubaId)))
          .write(ShubasCompanion(masulMemberId: Value(memberId)));

  /// The member currently assigned as Mas'ul of [shubaId], or null.
  Stream<Member?> watchMasul(String shubaId) {
    final query = _db.select(_db.members).join([
      innerJoin(
          _db.shubas, _db.shubas.masulMemberId.equalsExp(_db.members.id)),
    ])
      ..where(_db.shubas.id.equals(shubaId));
    return query.watchSingleOrNull().map((row) => row?.readTable(_db.members));
  }

  Future<void> createShuba({
    required String areaId,
    required String name,
  }) {
    return _db.into(_db.shubas).insert(
          ShubasCompanion.insert(
            id: _id('shuba'),
            areaId: areaId,
            name: name,
          ),
        );
  }

  Future<void> updateShuba(String id, {required String name}) {
    return (_db.update(_db.shubas)..where((s) => s.id.equals(id))).write(
      ShubasCompanion(
        name: Value(name),
      ),
    );
  }

  /// Deletes a shu'ba and its members (member sub-records cascade off the
  /// member rows). Members→shuba is RESTRICT, so members are cleared first.
  Future<void> deleteShuba(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.members)..where((m) => m.shubaId.equals(id))).go();
      await (_db.delete(_db.shubas)..where((s) => s.id.equals(id))).go();
    });
  }

  // ── Members by level ─────────────────────────────────────────────────────
  /// All approved members across every shu'ba (used by unified search).
  /// Pending/declined members are excluded.
  Future<List<Member>> getAllMembers() => (_db.select(_db.members)
        ..where((m) => m.approval.equals('approved')))
      .get();

  Stream<List<Member>> watchMembers(String shubaId, int level) {
    return (_db.select(_db.members)
          ..where((m) =>
              m.shubaId.equals(shubaId) &
              m.level.equals(level) &
              m.approval.equals('approved'))
          ..orderBy([(m) => OrderingTerm(expression: m.lastName)]))
        .watch();
  }

  /// Counts per level (1-5) for a shu'ba, keyed by level number. Only
  /// approved members are counted.
  Stream<Map<int, LevelCounts>> watchLevelCounts(String shubaId) {
    return (_db.select(_db.members)
          ..where((m) =>
              m.shubaId.equals(shubaId) & m.approval.equals('approved')))
        .watch()
        .map((rows) {
      final counts = <int, LevelCounts>{};
      for (final level in [1, 2, 3, 4, 5]) {
        final inLevel = rows.where((m) => m.level == level);
        counts[level] = LevelCounts(
          total: inLevel.length,
          active: inLevel.where((m) => m.status == 'active').length,
        );
      }
      return counts;
    });
  }

  // ── Tutorial classes (derived: same Naqib + same section) ────────────────
  /// The tutorial classes of one shu'ba level: members with a Naqib, grouped
  /// by (naqibMemberId, trimmed usraName). A join (rather than a second
  /// lookup) keeps the stream reactive to teacher-row edits too. Deleted
  /// teachers cannot dangle — naqibMemberId is SET NULL on delete, so their
  /// former students simply drop out of every class.
  Stream<List<TutorialClass>> watchClasses(String shubaId, int level) {
    final teacher = _db.alias(_db.members, 'teacher');
    final query = _db.select(_db.members).join([
      innerJoin(teacher, teacher.id.equalsExp(_db.members.naqibMemberId)),
    ])
      ..where(_db.members.shubaId.equals(shubaId) &
          _db.members.level.equals(level) &
          _db.members.naqibMemberId.isNotNull());
    return query.watch().map((rows) {
      final groups = <String, TutorialClass>{};
      for (final row in rows) {
        final student = row.readTable(_db.members);
        final naqib = row.readTable(teacher);
        final section = student.usraName.trim();
        final key = '${naqib.id}|$section';
        final existing = groups[key];
        if (existing == null) {
          groups[key] =
              TutorialClass(teacher: naqib, section: section, students: [student]);
        } else {
          existing.students.add(student);
        }
      }
      final classes = groups.values.toList();
      for (final c in classes) {
        c.students.sort((a, b) => a.firstName.compareTo(b.firstName));
      }
      classes.sort((a, b) {
        final byTeacher = a.teacher.firstName.compareTo(b.teacher.firstName);
        return byTeacher != 0 ? byTeacher : a.section.compareTo(b.section);
      });
      return classes;
    });
  }

  String _id(String prefix) => newId(prefix);
}
