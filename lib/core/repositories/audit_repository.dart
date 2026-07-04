import 'package:drift/drift.dart';

import '../data/app_database.dart';
import '../data/models.dart';

/// Records and reads the audit trail of important actions.
class AuditRepository {
  AuditRepository(this._db);
  final AppDatabase _db;

  Stream<List<AuditLog>> watchAll() {
    return (_db.select(_db.auditLogs)
          ..orderBy([
            (a) => OrderingTerm(expression: a.timestamp, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Deletes every audit log entry. Returns the number of rows removed.
  Future<int> clearAll() => _db.delete(_db.auditLogs).go();

  /// Append an audit entry.
  Future<void> log({
    required String username,
    required String action,
    required String module,
  }) {
    return _db.into(_db.auditLogs).insert(
          AuditLogsCompanion.insert(
            id: newId('audit'),
            username: username,
            action: action,
            module: module,
          ),
        );
  }
}
