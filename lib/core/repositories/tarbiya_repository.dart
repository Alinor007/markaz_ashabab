import 'package:drift/drift.dart';

import '../data/app_database.dart';

/// Member counts for a tarbiya level (or shu'ba).
class LevelCounts {
  const LevelCounts({this.total = 0, this.active = 0});
  final int total;
  final int active;
  int get inactive => total - active;
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

  Future<void> updateArea(String id,
      {required String name}) {
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
  /// All members across every shu'ba (used by unified search).
  Future<List<Member>> getAllMembers() => _db.select(_db.members).get();

  Stream<List<Member>> watchMembers(String shubaId, int level) {
    return (_db.select(_db.members)
          ..where((m) => m.shubaId.equals(shubaId) & m.level.equals(level))
          ..orderBy([(m) => OrderingTerm(expression: m.lastName)]))
        .watch();
  }

  /// Counts per level (1-5) for a shu'ba, keyed by level number.
  Stream<Map<int, LevelCounts>> watchLevelCounts(String shubaId) {
    return (_db.select(_db.members)..where((m) => m.shubaId.equals(shubaId)))
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

  String _id(String prefix) =>
      '${prefix}_${DateTime.now().microsecondsSinceEpoch}';
}
