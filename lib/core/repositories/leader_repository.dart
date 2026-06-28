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
}
