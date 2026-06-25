import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../auth/password_hasher.dart';
import '../auth/roles.dart';

part 'app_database.g.dart';

/// User accounts and credentials.
@TableIndex(name: 'idx_users_department', columns: {#departmentId})
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get fullNameAr => text()();
  TextColumn get username => text().unique()();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get passwordHash => text()();
  TextColumn get roleCode => text()();

  /// For department-head accounts: the department they manage.
  TextColumn get departmentId => text()
      .nullable()
      .references(Departments, #id, onDelete: KeyAction.setNull)();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastActive => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Leadership records, grouped by [category]
/// (office_president | board | assembly).
@TableIndex(name: 'idx_leaders_category', columns: {#category, #sortOrder})
class Leaders extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameAr => text()();
  TextColumn get position => text()();
  TextColumn get positionAr => text()();
  TextColumn get category => text()();
  TextColumn get serviceYears => text().withDefault(const Constant(''))();
  TextColumn get bio => text().withDefault(const Constant(''))();
  TextColumn get bioAr => text().withDefault(const Constant(''))();

  /// Newline-separated lists.
  TextColumn get achievements => text().withDefault(const Constant(''))();
  TextColumn get achievementsAr => text().withDefault(const Constant(''))();
  TextColumn get responsibilities => text().withDefault(const Constant(''))();
  TextColumn get responsibilitiesAr =>
      text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  IntColumn get accent => integer().withDefault(const Constant(0xFF0B5D3B))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Immutable audit trail of important actions.
@TableIndex(name: 'idx_audit_timestamp', columns: {#timestamp})
class AuditLogs extends Table {
  TextColumn get id => text()();
  TextColumn get username => text()();

  /// Optional link to the acting user. The [username] snapshot is always kept
  /// so the trail survives a user being renamed or deleted (SET NULL).
  TextColumn get userId =>
      text().nullable().references(Users, #id, onDelete: KeyAction.setNull)();
  TextColumn get action => text()();
  TextColumn get actionAr => text().withDefault(const Constant(''))();
  TextColumn get module => text()();
  TextColumn get moduleAr => text().withDefault(const Constant(''))();
  DateTimeColumn get timestamp =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ─────────────────────────── Tarbiya Al-Kawadeer ───────────────────────────

/// Level 1 — a Tarbiya area.
class TarbiyaAreas extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameAr => text().withDefault(const Constant(''))();
  TextColumn get region => text().withDefault(const Constant(''))();
  TextColumn get regionAr => text().withDefault(const Constant(''))();
  IntColumn get accent => integer().withDefault(const Constant(0xFF0B5D3B))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Level 2 — a Shu'ba (formerly Municipality) within an area.
@TableIndex(name: 'idx_shubas_area', columns: {#areaId})
class Shubas extends Table {
  TextColumn get id => text()();
  TextColumn get areaId =>
      text().references(TarbiyaAreas, #id, onDelete: KeyAction.restrict)();
  TextColumn get name => text()();
  TextColumn get nameAr => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Level 4 — a member assigned to a Shu'ba at a tarbiya level (1-5).
@TableIndex(name: 'idx_members_shuba_level', columns: {#shubaId, #level})
@TableIndex(name: 'idx_members_naqib', columns: {#naqibMemberId})
class Members extends Table {
  TextColumn get id => text()();
  TextColumn get shubaId =>
      text().references(Shubas, #id, onDelete: KeyAction.restrict)();
  IntColumn get level => integer().withDefault(const Constant(1))();

  // Personal information (demographics merged in).
  TextColumn get firstName => text()();
  TextColumn get middleName => text().withDefault(const Constant(''))();
  TextColumn get lastName => text()();
  TextColumn get suffix => text().withDefault(const Constant(''))();
  TextColumn get nameAr => text().withDefault(const Constant(''))();
  TextColumn get gender => text().withDefault(const Constant('M'))();
  TextColumn get dob => text().withDefault(const Constant(''))();
  TextColumn get placeOfBirth => text().withDefault(const Constant(''))();
  TextColumn get contactNumber => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get ethnicity => text().withDefault(const Constant(''))();
  TextColumn get occupation => text().withDefault(const Constant(''))();
  TextColumn get photoPath => text().withDefault(const Constant(''))();

  // Civil status + family.
  TextColumn get civilStatus => text().withDefault(const Constant('single'))();
  TextColumn get spouseName => text().withDefault(const Constant(''))();
  TextColumn get spouseDate => text().withDefault(const Constant(''))();

  // Membership.
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get dateJoined => text().withDefault(const Constant(''))();

  // Naqib-Usra information.
  TextColumn get usraName => text().withDefault(const Constant(''))();
  TextColumn get usraEstablishedYear =>
      text().withDefault(const Constant(''))();
  TextColumn get usraMeetingSchedule =>
      text().withDefault(const Constant(''))();

  /// Self-reference to this member's naqib (another member). SET NULL so a
  /// deleted naqib doesn't strand their mentees.
  TextColumn get naqibMemberId =>
      text().nullable().references(Members, #id, onDelete: KeyAction.setNull)();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'idx_member_children_member', columns: {#memberId})
class MemberChildren extends Table {
  TextColumn get id => text()();
  TextColumn get memberId =>
      text().references(Members, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get dob => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

/// stage: elementary | highschool | college | postgraduate
@TableIndex(name: 'idx_member_education_member', columns: {#memberId})
class MemberEducation extends Table {
  TextColumn get id => text()();
  TextColumn get memberId =>
      text().references(Members, #id, onDelete: KeyAction.cascade)();
  TextColumn get stage => text()();
  TextColumn get schoolName => text()();
  TextColumn get degree => text().withDefault(const Constant(''))();
  TextColumn get program => text().withDefault(const Constant(''))();
  TextColumn get yearGraduated => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'idx_member_activities_member', columns: {#memberId})
class MemberActivities extends Table {
  TextColumn get id => text()();
  TextColumn get memberId =>
      text().references(Members, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get type => text().withDefault(const Constant(''))();
  TextColumn get date => text().withDefault(const Constant(''))();
  TextColumn get attendanceStatus =>
      text().withDefault(const Constant('present'))();
  TextColumn get remarks => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'idx_member_contributions_member', columns: {#memberId})
class MemberContributions extends Table {
  TextColumn get id => text()();
  TextColumn get memberId =>
      text().references(Members, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get date => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('active'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// One Tas'ed (advancement) record per level (1-5).
@TableIndex(name: 'idx_member_tased_member', columns: {#memberId})
class MemberTased extends Table {
  TextColumn get id => text()();
  TextColumn get memberId =>
      text().references(Members, #id, onDelete: KeyAction.cascade)();
  IntColumn get level => integer()();
  TextColumn get year => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('inactive'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Monthly donation monitoring (one row per member/year/month).
@TableIndex(name: 'idx_member_donations_member_year', columns: {#memberId, #year})
class MemberDonations extends Table {
  TextColumn get id => text()();
  TextColumn get memberId =>
      text().references(Members, #id, onDelete: KeyAction.cascade)();
  IntColumn get year => integer()();
  IntColumn get month => integer()(); // 1-12
  BoolColumn get donated => boolean().withDefault(const Constant(false))();
  TextColumn get date => text().withDefault(const Constant(''))();
  RealColumn get amount => real().withDefault(const Constant(0))();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};

  /// One donation row per member per calendar month — backs the upsert in
  /// MemberRepository.setDonation.
  @override
  List<Set<Column>> get uniqueKeys => [
        {memberId, year, month},
      ];
}

@TableIndex(name: 'idx_member_roles_member', columns: {#memberId})
class MemberRoles extends Table {
  TextColumn get id => text()();
  TextColumn get memberId =>
      text().references(Members, #id, onDelete: KeyAction.cascade)();
  TextColumn get positionTitle => text()();

  /// Legacy free-text department label (retained for back-compat).
  TextColumn get department => text().withDefault(const Constant(''))();

  /// Structured link to a department (preferred over [department]).
  TextColumn get departmentId =>
      text().nullable().references(Departments, #id, onDelete: KeyAction.setNull)();
  TextColumn get startDate => text().withDefault(const Constant(''))();
  TextColumn get endDate => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('active'))();

  @override
  Set<Column> get primaryKey => {id};
}

// ─────────────────────────── Departments & Reports ───────────────────────────

/// Organizational departments.
class Departments extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameAr => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get descriptionAr => text().withDefault(const Constant(''))();
  TextColumn get iconKey => text().withDefault(const Constant('group'))();
  IntColumn get accent => integer().withDefault(const Constant(0xFF0B5D3B))();
  TextColumn get headName => text().withDefault(const Constant(''))();
  TextColumn get headNameAr => text().withDefault(const Constant(''))();
  TextColumn get contactEmail => text().withDefault(const Constant(''))();
  TextColumn get contactPhone => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Activities belonging to a department.
@TableIndex(name: 'idx_dept_activities_dept', columns: {#departmentId})
class DeptActivities extends Table {
  TextColumn get id => text()();
  TextColumn get departmentId =>
      text().references(Departments, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get titleAr => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get date => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('planned'))();
  IntColumn get attendance => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Department reports. type: minutes | resolution.
@TableIndex(name: 'idx_reports_dept_year', columns: {#departmentId, #year})
class Reports extends Table {
  TextColumn get id => text()();
  TextColumn get departmentId =>
      text().references(Departments, #id, onDelete: KeyAction.restrict)();
  TextColumn get title => text()();
  TextColumn get titleAr => text().withDefault(const Constant(''))();
  TextColumn get summary => text().withDefault(const Constant(''))();
  TextColumn get summaryAr => text().withDefault(const Constant(''))();
  TextColumn get date => text().withDefault(const Constant(''))();
  IntColumn get year => integer().withDefault(const Constant(0))();
  TextColumn get type => text().withDefault(const Constant('minutes'))();
  IntColumn get pages => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Gallery archive photos (metadata; optional image file path).
class GalleryPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get titleAr => text().withDefault(const Constant(''))();
  IntColumn get year => integer().withDefault(const Constant(0))();
  TextColumn get event => text().withDefault(const Constant(''))();
  TextColumn get eventAr => text().withDefault(const Constant(''))();
  TextColumn get iconKey => text().withDefault(const Constant('photo'))();
  IntColumn get accent => integer().withDefault(const Constant(0xFF0B5D3B))();
  TextColumn get imagePath => text().withDefault(const Constant(''))();
  IntColumn get heightHint => integer().withDefault(const Constant(220))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Users,
  Leaders,
  AuditLogs,
  TarbiyaAreas,
  Shubas,
  Members,
  MemberChildren,
  MemberEducation,
  MemberActivities,
  MemberContributions,
  MemberTased,
  MemberDonations,
  MemberRoles,
  Departments,
  DeptActivities,
  Reports,
  GalleryPhotos,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openOnDevice());

  /// In-memory database for tests.
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedAdministrator();
          await _seedDepartments();
          await _seedTarbiyaAreas();
        },
        beforeOpen: (details) async {
          // Foreign keys are off by default in SQLite and must be enabled per
          // connection — without this the declared FKs are not enforced.
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Tarbiya tables added in schema v2.
            await m.createTable(tarbiyaAreas);
            await m.createTable(shubas);
            await m.createTable(members);
            await m.createTable(memberChildren);
            await m.createTable(memberEducation);
            await m.createTable(memberActivities);
            await m.createTable(memberContributions);
            await m.createTable(memberTased);
            await m.createTable(memberDonations);
            await m.createTable(memberRoles);
          }
          if (from < 3) {
            // Departments, activities, reports, gallery added in schema v3.
            await m.createTable(departments);
            await m.createTable(deptActivities);
            await m.createTable(reports);
            await m.createTable(galleryPhotos);
            await _seedDepartments();
          }
          if (from < 4) {
            // Default Tarbiya areas seeded in schema v4.
            await _seedTarbiyaAreas();
          }
          if (from < 5) {
            // Referential integrity added in schema v5: FKs, indexes, the
            // donation UNIQUE key, member_roles.departmentId and audit.userId.
            await _migrateToV5(m);
          }
        },
      );

  /// Rebuilds the tables that gained constraints so existing installs get the
  /// same integrity as a fresh v5 database, repairing data first so the new
  /// constraints don't reject it. Runs with foreign keys off (the default
  /// during migrations); [alterTable] manages the rebuild safely.
  Future<void> _migrateToV5(Migrator m) async {
    // 1. Repair existing data BEFORE the constraints are applied.
    //    a) Drop rows that point at a non-existent parent (orphans).
    await customStatement(
        'DELETE FROM shubas WHERE area_id NOT IN (SELECT id FROM tarbiya_areas)');
    await customStatement(
        'DELETE FROM members WHERE shuba_id NOT IN (SELECT id FROM shubas)');
    for (final child in const [
      'member_children',
      'member_education',
      'member_activities',
      'member_contributions',
      'member_tased',
      'member_donations',
      'member_roles',
    ]) {
      await customStatement(
          'DELETE FROM $child WHERE member_id NOT IN (SELECT id FROM members)');
    }
    await customStatement(
        'DELETE FROM reports WHERE department_id NOT IN (SELECT id FROM departments)');
    await customStatement(
        'DELETE FROM dept_activities WHERE department_id NOT IN (SELECT id FROM departments)');
    //    b) Null out dangling soft references (don't delete the owning row).
    await customStatement('UPDATE members SET naqib_member_id = NULL '
        'WHERE naqib_member_id IS NOT NULL '
        'AND naqib_member_id NOT IN (SELECT id FROM members)');
    await customStatement('UPDATE users SET department_id = NULL '
        'WHERE department_id IS NOT NULL '
        'AND department_id NOT IN (SELECT id FROM departments)');
    //    c) De-duplicate donations so UNIQUE(member_id, year, month) holds
    //       (keep the most recently inserted row per month).
    await customStatement('DELETE FROM member_donations WHERE rowid NOT IN '
        '(SELECT MAX(rowid) FROM member_donations GROUP BY member_id, year, month)');

    // 2. Rebuild each changed table from its current definition (adds FKs /
    //    UNIQUE / new columns). New nullable columns need no transformer.
    await m.alterTable(TableMigration(shubas));
    await m.alterTable(TableMigration(members));
    await m.alterTable(TableMigration(memberChildren));
    await m.alterTable(TableMigration(memberEducation));
    await m.alterTable(TableMigration(memberActivities));
    await m.alterTable(TableMigration(memberContributions));
    await m.alterTable(TableMigration(memberTased));
    await m.alterTable(TableMigration(memberDonations));
    await m.alterTable(
        TableMigration(memberRoles, newColumns: [memberRoles.departmentId]));
    await m.alterTable(TableMigration(reports));
    await m.alterTable(TableMigration(deptActivities));
    await m.alterTable(TableMigration(users));
    await m.alterTable(
        TableMigration(auditLogs, newColumns: [auditLogs.userId]));

    // 3. Create every declared index (v4 had none, so all are new).
    for (final index in allSchemaEntities.whereType<Index>()) {
      await m.createIndex(index);
    }
  }

  /// Creates the default Administrator account on first launch so the system
  /// can be accessed before any data exists. Username `admin`, password
  /// `admin123` (change immediately in production).
  Future<void> _seedAdministrator() async {
    await into(users).insert(
      UsersCompanion.insert(
        id: 'admin',
        fullName: 'System Administrator',
        fullNameAr: 'مدير النظام',
        username: 'admin',
        email: const Value('admin@markaz.org'),
        passwordHash: PasswordHasher.hash('admin123'),
        roleCode: UserRole.administrator.code,
      ),
    );
  }

  /// Seeds the organization's eight standing departments on first launch.
  Future<void> _seedDepartments() async {
    const seed = [
      ('dawah', 'Da‘wah', 'الدعوة', 'dawah', 0xFF0B5D3B),
      ('tarbiyah', 'Tarbiyah', 'التربية', 'tarbiyah', 0xFF16243D),
      ('education', 'Education', 'التعليم', 'education', 0xFFA8862F),
      ('economy', 'Economy and Investments', 'الاقتصاد والاستثمار', 'economy',
          0xFF0B5D3B),
      ('charity', 'Charitable Programs', 'البرامج الخيرية', 'charity',
          0xFF16243D),
      ('media', 'Public Relations and Information',
          'العلاقات العامة والإعلام', 'media', 0xFFA8862F),
      ('politics', 'Politics', 'السياسة', 'politics', 0xFF0B5D3B),
      ('women', 'Women Affairs', 'شؤون المرأة', 'women', 0xFF16243D),
    ];
    var order = 0;
    for (final (id, name, nameAr, iconKey, accent) in seed) {
      await into(departments).insert(
        DepartmentsCompanion.insert(
          id: id,
          name: name,
          nameAr: Value(nameAr),
          iconKey: Value(iconKey),
          accent: Value(accent),
          sortOrder: Value(order++),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  /// Seeds the standing Tarbiya Al-Kawadeer areas (Area 1–6 and the Special
  /// Area) on first launch so the hierarchy starts populated.
  Future<void> _seedTarbiyaAreas() async {
    const accents = [0xFF0B5D3B, 0xFF16243D, 0xFFA8862F];
    const seed = [
      ('area-1', 'Area 1', 'المنطقة ١'),
      ('area-2', 'Area 2', 'المنطقة ٢'),
      ('area-3', 'Area 3', 'المنطقة ٣'),
      ('area-4', 'Area 4', 'المنطقة ٤'),
      ('area-5', 'Area 5', 'المنطقة ٥'),
      ('area-6', 'Area 6', 'المنطقة ٦'),
      ('area-special', 'Special Area', 'المنطقة الخاصة'),
    ];
    var order = 0;
    for (final (id, name, nameAr) in seed) {
      await into(tarbiyaAreas).insert(
        TarbiyaAreasCompanion.insert(
          id: id,
          name: name,
          nameAr: Value(nameAr),
          accent: Value(accents[order % accents.length]),
          sortOrder: Value(order),
        ),
        mode: InsertMode.insertOrIgnore,
      );
      order++;
    }
  }
}

LazyDatabase _openOnDevice() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'markaz_archive.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
