import 'package:flutter/foundation.dart';

import '../data/app_database.dart';
import '../data/models.dart';
import '../repositories/audit_repository.dart';
import '../repositories/user_repository.dart';
import 'roles.dart';

/// Authentication / session state backed by the local database.
///
/// There is no registration or password recovery by design; accounts are
/// provisioned by an Administrator through User Management.
class SessionController extends ChangeNotifier {
  SessionController(this._users, this._audit);

  final UserRepository _users;
  final AuditRepository _audit;

  User? _user;
  bool _rememberMe = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get rememberMe => _rememberMe;
  UserRole? get role => _user?.role;
  bool get isAdmin => _user?.role.isAdmin ?? false;

  /// Capability checks for the signed-in user (null when signed out).
  Permissions? get can => _user?.role.can;

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  /// Attempts sign-in. Returns null on success, or an error message key.
  Future<String?> signIn({
    required String username,
    required String password,
  }) async {
    if (username.trim().isEmpty || password.isEmpty) {
      return 'empty';
    }
    final user = await _users.authenticate(username, password);
    if (user == null) {
      return 'invalid';
    }
    _user = user;
    await _audit.log(
      username: user.username,
      action: 'Signed in',
      module: 'Authentication',
    );
    notifyListeners();
    return null;
  }

  void signOut() {
    _user = null;
    notifyListeners();
  }

  /// Re-reads the current user from the database (e.g. after a self profile
  /// change) so the UI reflects the latest values.
  Future<void> refreshUser() async {
    if (_user == null) return;
    _user = await _users.getById(_user!.id);
    notifyListeners();
  }
}
