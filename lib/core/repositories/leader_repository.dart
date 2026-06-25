import 'package:drift/drift.dart';

import '../data/app_database.dart';
import '../data/models.dart';

/// CRUD for leadership records.
class LeaderRepository {
  LeaderRepository(this._db);
  final AppDatabase _db;

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
      ),
    );
  }

  Future<void> delete(String id) {
    return (_db.delete(_db.leaders)..where((l) => l.id.equals(id))).go();
  }
}
