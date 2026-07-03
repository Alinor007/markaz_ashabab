import 'package:drift/drift.dart';

import '../data/app_database.dart';
import '../data/models.dart';
import '../util/photo_service.dart';

/// CRUD for leadership records.
class LeaderRepository {
  LeaderRepository(this._db, [this._photos = const PhotoService()]);
  final AppDatabase _db;
  final PhotoService _photos;

  Stream<List<Leader>> watchByCategory(LeadershipCategory category) =>
      watchByCategoryCode(category.code);

  /// Watches the positions in a category by its raw code. The Consultative
  /// Assembly is split into sub-codes (`assembly_general`, `committee_hayah`,
  /// `committee_audit`). Ordered by sort order then creation, so a seeded
  /// position (sort order 0) leads and admin-added ones follow in the order
  /// they were created — the first is shown prominently.
  Stream<List<Leader>> watchByCategoryCode(String code) {
    return (_db.select(_db.leaders)
          ..where((l) => l.category.equals(code))
          ..orderBy([
            (l) => OrderingTerm(expression: l.sortOrder),
            (l) => OrderingTerm(expression: l.createdAt),
          ]))
        .watch();
  }

  Future<List<Leader>> getAll() => _db.select(_db.leaders).get();

  Future<Leader?> getById(String id) =>
      (_db.select(_db.leaders)..where((l) => l.id.equals(id)))
          .getSingleOrNull();

  Future<Leader> create({
    required String name,
    required String nameAr,
    required String position,
    required String positionAr,
    required LeadershipCategory category,
    String serviceYears = '',
    String bio = '',
    String bioAr = '',
    String achievements = '',
    String achievementsAr = '',
    String responsibilities = '',
    String responsibilitiesAr = '',
    String email = '',
    String phone = '',
    String photoPath = '',
    int accent = 0xFF0B5D3B,
  }) async {
    final id = newId('leader');
    await _db.into(_db.leaders).insert(
          LeadersCompanion.insert(
            id: id,
            name: name,
            nameAr: nameAr.isEmpty ? name : nameAr,
            position: position,
            positionAr: positionAr.isEmpty ? position : positionAr,
            category: category.code,
            serviceYears: Value(serviceYears),
            bio: Value(bio),
            bioAr: Value(bioAr),
            achievements: Value(achievements),
            achievementsAr: Value(achievementsAr),
            responsibilities: Value(responsibilities),
            responsibilitiesAr: Value(responsibilitiesAr),
            email: Value(email),
            phone: Value(phone),
            photoPath: Value(photoPath),
            accent: Value(accent),
          ),
        );
    return (await getById(id))!;
  }

  Future<void> updateLeader(
    String id, {
    required String name,
    required String nameAr,
    required String position,
    required String positionAr,
    required LeadershipCategory category,
    required String serviceYears,
    required String bio,
    required String bioAr,
    required String achievements,
    required String achievementsAr,
    required String responsibilities,
    required String responsibilitiesAr,
    required String email,
    required String phone,
    String? photoPath,
  }) {
    return (_db.update(_db.leaders)..where((l) => l.id.equals(id))).write(
      LeadersCompanion(
        name: Value(name),
        nameAr: Value(nameAr.isEmpty ? name : nameAr),
        position: Value(position),
        positionAr: Value(positionAr.isEmpty ? position : positionAr),
        category: Value(category.code),
        serviceYears: Value(serviceYears),
        bio: Value(bio),
        bioAr: Value(bioAr),
        achievements: Value(achievements),
        achievementsAr: Value(achievementsAr),
        responsibilities: Value(responsibilities),
        responsibilitiesAr: Value(responsibilitiesAr),
        email: Value(email),
        phone: Value(phone),
        // Only overwrite the photo when a new value is supplied.
        photoPath: photoPath == null ? const Value.absent() : Value(photoPath),
      ),
    );
  }

  Future<void> delete(String id) async {
    final leader = await getById(id);
    await (_db.delete(_db.leaders)..where((l) => l.id.equals(id))).go();
    await _photos.deleteStored(leader?.photoPath);
  }

  /// Adds a new (unassigned) position to a category [code]. Custom positions
  /// use sort order 100 so they land after any seeded ones (ordered among
  /// themselves by creation time).
  Future<void> addPosition({
    required String code,
    required String title,
    required String titleAr,
  }) {
    return _db.into(_db.leaders).insert(
          LeadersCompanion.insert(
            id: newId('position'),
            name: title,
            nameAr: titleAr.isEmpty ? title : titleAr,
            position: title,
            positionAr: titleAr.isEmpty ? title : titleAr,
            category: code,
            sortOrder: const Value(100),
          ),
        );
  }

  /// Renames a position (title in both languages).
  Future<void> editPosition(String id, String title, String titleAr) {
    return (_db.update(_db.leaders)..where((l) => l.id.equals(id))).write(
      LeadersCompanion(
        name: Value(title),
        nameAr: Value(titleAr.isEmpty ? title : titleAr),
        position: Value(title),
        positionAr: Value(titleAr.isEmpty ? title : titleAr),
      ),
    );
  }

  /// Assigns (or clears, with null) the member who holds a position.
  Future<void> assignMember(String positionId, String? memberId) {
    return (_db.update(_db.leaders)..where((l) => l.id.equals(positionId)))
        .write(LeadersCompanion(memberId: Value(memberId)));
  }

  /// The member currently assigned to [positionId], or null when unassigned.
  Stream<Member?> watchAssignedMember(String positionId) {
    final query = _db.select(_db.members).join([
      innerJoin(_db.leaders, _db.leaders.memberId.equalsExp(_db.members.id)),
    ])
      ..where(_db.leaders.id.equals(positionId));
    return query.watchSingleOrNull().map((row) => row?.readTable(_db.members));
  }

  // ── Group descriptions (Office of the President, Board, Assembly groups) ──
  Stream<LeadershipGroupInfoData?> watchGroupInfo(String code) =>
      (_db.select(_db.leadershipGroupInfo)..where((g) => g.code.equals(code)))
          .watchSingleOrNull();

  /// Sets a leadership group's editable function description (creates the row
  /// if missing).
  Future<void> setGroupDescription(
      String code, String description, String descriptionAr) {
    return _db.into(_db.leadershipGroupInfo).insertOnConflictUpdate(
          LeadershipGroupInfoCompanion(
            code: Value(code),
            description: Value(description),
            descriptionAr: Value(descriptionAr),
          ),
        );
  }

  // ── Previous Leadership (former office-holders, linked to members) ─────────
  /// Former office-holders joined with the member they reference, in display
  /// order.
  Stream<List<PreviousLeaderView>> watchPreviousLeaders() {
    final query = _db.select(_db.previousLeaders).join([
      innerJoin(_db.members,
          _db.members.id.equalsExp(_db.previousLeaders.memberId)),
    ])
      ..orderBy([
        OrderingTerm(expression: _db.previousLeaders.sortOrder),
        OrderingTerm(expression: _db.previousLeaders.createdAt),
      ]);
    return query.watch().map((rows) => [
          for (final row in rows)
            (
              entry: row.readTable(_db.previousLeaders),
              member: row.readTable(_db.members),
            ),
        ]);
  }

  Future<String> addPreviousLeader({
    required String memberId,
    required String position,
    required String positionAr,
    required String termYears,
    String note = '',
    String noteAr = '',
    int accent = 0xFF16243D,
  }) async {
    final all = await _db.select(_db.previousLeaders).get();
    final nextSort =
        all.fold<int>(0, (m, e) => e.sortOrder >= m ? e.sortOrder + 1 : m);
    final id = newId('prevleader');
    await _db.into(_db.previousLeaders).insert(
          PreviousLeadersCompanion.insert(
            id: id,
            memberId: memberId,
            position: Value(position),
            positionAr: Value(positionAr.isEmpty ? position : positionAr),
            termYears: Value(termYears),
            note: Value(note),
            noteAr: Value(noteAr),
            accent: Value(accent),
            sortOrder: Value(nextSort),
          ),
        );
    return id;
  }

  Future<void> updatePreviousLeader(
    String id, {
    required String memberId,
    required String position,
    required String positionAr,
    required String termYears,
    required String note,
    required String noteAr,
    required int accent,
  }) =>
      (_db.update(_db.previousLeaders)..where((p) => p.id.equals(id))).write(
        PreviousLeadersCompanion(
          memberId: Value(memberId),
          position: Value(position),
          positionAr: Value(positionAr.isEmpty ? position : positionAr),
          termYears: Value(termYears),
          note: Value(note),
          noteAr: Value(noteAr),
          accent: Value(accent),
        ),
      );

  Future<void> deletePreviousLeader(String id) =>
      (_db.delete(_db.previousLeaders)..where((p) => p.id.equals(id))).go();

  /// A member's former-leadership history (their own entries only, not joined
  /// with the member row since callers already have it) — e.g. for showing
  /// "Former Leadership" on that member's profile. Most recently added first.
  Stream<List<PreviousLeader>> watchPreviousLeadershipForMember(
      String memberId) {
    return (_db.select(_db.previousLeaders)
          ..where((p) => p.memberId.equals(memberId))
          ..orderBy([
            (p) => OrderingTerm(expression: p.sortOrder),
            (p) => OrderingTerm(expression: p.createdAt),
          ]))
        .watch();
  }

  // ── Biography sections (repeatable, attached to a Previous Leader) ────────
  Stream<List<PreviousLeaderSection>> watchSections(String previousLeaderId) =>
      (_db.select(_db.previousLeaderSections)
            ..where((s) => s.previousLeaderId.equals(previousLeaderId))
            ..orderBy([(s) => OrderingTerm(expression: s.sortOrder)]))
          .watch();

  Future<void> addSection({
    required String previousLeaderId,
    required String title,
    required String titleAr,
    required String body,
    required String bodyAr,
    required int sortOrder,
  }) =>
      _db.into(_db.previousLeaderSections).insert(
            PreviousLeaderSectionsCompanion.insert(
              id: newId('prevsection'),
              previousLeaderId: previousLeaderId,
              title: Value(title),
              titleAr: Value(titleAr),
              body: Value(body),
              bodyAr: Value(bodyAr),
              sortOrder: Value(sortOrder),
            ),
          );

  Future<void> deleteSection(String id) =>
      (_db.delete(_db.previousLeaderSections)..where((s) => s.id.equals(id)))
          .go();
}

/// A former office-holder joined with the member they reference.
typedef PreviousLeaderView = ({PreviousLeader entry, Member member});
