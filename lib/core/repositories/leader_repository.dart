import 'package:drift/drift.dart';

import '../data/app_database.dart';
import '../data/models.dart';
import '../util/photo_service.dart';

/// CRUD for leadership records.
class LeaderRepository {
  LeaderRepository(this._db, [this._photos = const PhotoService()]);
  final AppDatabase _db;
  final PhotoService _photos;

  Stream<List<Leader>> watchByCategory(LeadershipCategory category) {
    return (_db.select(_db.leaders)
          ..where((l) => l.category.equals(category.code))
          ..orderBy([(l) => OrderingTerm(expression: l.sortOrder)]))
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
}
