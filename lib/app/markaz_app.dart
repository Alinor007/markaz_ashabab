import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/auth/session_controller.dart';
import '../core/data/app_database.dart';
import '../core/i18n/locale_controller.dart';
import '../core/repositories/audit_repository.dart';
import '../core/repositories/department_repository.dart';
import '../core/repositories/gallery_repository.dart';
import '../core/repositories/history_repository.dart';
import '../core/repositories/leader_repository.dart';
import '../core/repositories/member_repository.dart';
import '../core/repositories/minutes_report_repository.dart';
import '../core/repositories/report_repository.dart';
import '../core/repositories/tarbiya_repository.dart';
import '../core/repositories/user_repository.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

/// Root application widget. Owns the database, repositories, and the long-lived
/// controllers (session + locale), applies the theme, and switches text
/// direction (LTR/RTL) with the active language.
class MarkazApp extends StatefulWidget {
  const MarkazApp({
    super.key,
    this.database,
    this.initialLocale,
    this.onLocaleChanged,
  });

  /// Injectable database (tests pass an in-memory instance). When null, the
  /// on-device SQLite database is opened.
  final AppDatabase? database;

  /// Locale restored from persisted preferences (null → default English).
  final Locale? initialLocale;

  /// Invoked when the user changes language, so the choice can be persisted.
  final void Function(Locale)? onLocaleChanged;

  @override
  State<MarkazApp> createState() => _MarkazAppState();
}

class _MarkazAppState extends State<MarkazApp> {
  late final AppDatabase _db = widget.database ?? AppDatabase();
  late final UserRepository _users = UserRepository(_db);
  late final LeaderRepository _leaders = LeaderRepository(_db);
  late final TarbiyaRepository _tarbiya = TarbiyaRepository(_db);
  late final MemberRepository _members = MemberRepository(_db);
  late final DepartmentRepository _departments = DepartmentRepository(_db);
  late final ReportRepository _reports = ReportRepository(_db);
  late final MinutesReportRepository _minutesReports =
      MinutesReportRepository(_db);
  late final GalleryRepository _gallery = GalleryRepository(_db);
  late final HistoryRepository _history = HistoryRepository(_db);
  late final AuditRepository _audit = AuditRepository(_db);
  late final SessionController _session = SessionController(_users, _audit);
  late final LocaleController _locale = LocaleController(
    initial: widget.initialLocale ?? const Locale('en'),
    onChanged: widget.onLocaleChanged,
  );
  late final _router = createRouter(_session);

  @override
  void dispose() {
    _session.dispose();
    _locale.dispose();
    // Only close a database we created ourselves.
    if (widget.database == null) {
      _db.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: _db),
        Provider<UserRepository>.value(value: _users),
        Provider<LeaderRepository>.value(value: _leaders),
        Provider<TarbiyaRepository>.value(value: _tarbiya),
        Provider<MemberRepository>.value(value: _members),
        Provider<DepartmentRepository>.value(value: _departments),
        Provider<ReportRepository>.value(value: _reports),
        Provider<MinutesReportRepository>.value(value: _minutesReports),
        Provider<GalleryRepository>.value(value: _gallery),
        Provider<HistoryRepository>.value(value: _history),
        Provider<AuditRepository>.value(value: _audit),
        ChangeNotifierProvider.value(value: _session),
        ChangeNotifierProvider.value(value: _locale),
      ],
      child: Consumer<LocaleController>(
        builder: (context, locale, _) {
          return MaterialApp.router(
            title: 'Markazosshabab Archive',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: _router,
            locale: locale.locale,
            builder: (context, child) {
              return Directionality(
                textDirection: locale.textDirection,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
