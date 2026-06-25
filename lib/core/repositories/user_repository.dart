import 'package:drift/drift.dart';

import '../auth/password_hasher.dart';
import '../auth/roles.dart';
import '../data/app_database.dart';
import '../data/models.dart';

/// CRUD and authentication for user accounts.
class UserRepository {
  UserRepository(this._db);
  final AppDatabase _db;

  Stream<List<User>> watchAll() {
    return (_db.select(_db.users)
          ..orderBy([(u) => OrderingTerm(expression: u.fullName)]))
        .watch();
  }

  Future<User?> getById(String id) =>
      (_db.select(_db.users)..where((u) => u.id.equals(id)))
          .getSingleOrNull();

  Future<User?> getByUsername(String username) =>
      (_db.select(_db.users)..where((u) => u.username.equals(username)))
          .getSingleOrNull();

  Future<bool> usernameExists(String username, {String? excludeId}) async {
    final query = _db.select(_db.users)
      ..where((u) => u.username.equals(username.trim()));
    final rows = await query.get();
    return rows.any((u) => u.id != excludeId);
  }

  /// Verifies credentials against an active account. Returns the user on
  /// success, otherwise null. Updates last-active on success.
  Future<User?> authenticate(String username, String password) async {
    final user = await getByUsername(username.trim());
    if (user == null || !user.active) return null;
    if (!PasswordHasher.verify(password, user.passwordHash)) return null;
    await _touchLastActive(user.id);
    return getById(user.id);
  }

  Future<void> _touchLastActive(String id) {
    return (_db.update(_db.users)..where((u) => u.id.equals(id)))
        .write(UsersCompanion(lastActive: Value(DateTime.now())));
  }

  Future<User> create({
    required String fullName,
    required String fullNameAr,
    required String username,
    required String email,
    required String password,
    required UserRole role,
    String? departmentId,
  }) async {
    final id = newId('user');
    await _db.into(_db.users).insert(
          UsersCompanion.insert(
            id: id,
            fullName: fullName,
            fullNameAr: fullNameAr.isEmpty ? fullName : fullNameAr,
            username: username.trim(),
            email: Value(email),
            passwordHash: PasswordHasher.hash(password),
            roleCode: role.code,
            departmentId: Value(departmentId),
          ),
        );
    return (await getById(id))!;
  }

  Future<void> updateProfile({
    required String id,
    required String fullName,
    required String fullNameAr,
    required String username,
    required String email,
    required UserRole role,
    String? departmentId,
  }) {
    return (_db.update(_db.users)..where((u) => u.id.equals(id))).write(
      UsersCompanion(
        fullName: Value(fullName),
        fullNameAr: Value(fullNameAr.isEmpty ? fullName : fullNameAr),
        username: Value(username.trim()),
        email: Value(email),
        roleCode: Value(role.code),
        departmentId: Value(departmentId),
      ),
    );
  }

  Future<void> setActive(String id, bool active) {
    return (_db.update(_db.users)..where((u) => u.id.equals(id)))
        .write(UsersCompanion(active: Value(active)));
  }

  Future<void> resetPassword(String id, String newPassword) {
    return (_db.update(_db.users)..where((u) => u.id.equals(id)))
        .write(UsersCompanion(passwordHash: Value(PasswordHasher.hash(newPassword))));
  }

  Future<void> delete(String id) {
    return (_db.delete(_db.users)..where((u) => u.id.equals(id))).go();
  }
}
