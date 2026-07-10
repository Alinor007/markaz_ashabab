import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../auth/password_hasher.dart';
import '../auth/roles.dart';
import '../content/history_content.dart';

part 'app_database.g.dart';

/// User accounts and credentials.
@TableIndex(name: 'idx_users_department', columns: {#departmentId})
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
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
  TextColumn get position => text()();
  TextColumn get category => text()();
  TextColumn get serviceYears => text().withDefault(const Constant(''))();
  TextColumn get bio => text().withDefault(const Constant(''))();

  /// Newline-separated lists.
  TextColumn get achievements => text().withDefault(const Constant(''))();
  TextColumn get responsibilities => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();

  /// Absolute path to the leader's stored profile photo ('' when none).
  TextColumn get photoPath => text().withDefault(const Constant(''))();

  /// For an assignable position (Office of the President): the member who holds
  /// it, or null when Unassigned. SET NULL so deleting the member just vacates
  /// the position rather than removing it.
  TextColumn get memberId =>
      text().nullable().references(Members, #id, onDelete: KeyAction.setNull)();
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
  TextColumn get module => text()();
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
  TextColumn get region => text().withDefault(const Constant(''))();
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
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// The Shu'ba's Mas'ul (Person-in-Charge): an existing member, or null when
  /// unassigned. SET NULL so deleting the member just vacates the role.
  TextColumn get masulMemberId =>
      text().nullable().references(Members, #id, onDelete: KeyAction.setNull)();

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
  // TextColumn get profession => text()();
  // TextColumn get occupation => text()();



  @override
  Set<Column> get primaryKey => {id};
}

/// A member's wives (up to four, enforced in the form). Free-text name plus an
/// optional marriage date — wives are not necessarily members themselves.
@DataClassName('MemberWife')
@TableIndex(name: 'idx_member_wives_member', columns: {#memberId})
class MemberWives extends Table {
  TextColumn get id => text()();
  TextColumn get memberId =>
      text().references(Members, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get marriageDate => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Explicit Usra membership: links a member to another member in their Usra.
/// Both sides cascade-delete so removing either member drops the link.
@DataClassName('MemberUsraLink')
@TableIndex(name: 'idx_member_usra_links_member', columns: {#memberId})
class MemberUsraLinks extends Table {
  TextColumn get id => text()();
  TextColumn get memberId =>
      text().references(Members, #id, onDelete: KeyAction.cascade)();
  TextColumn get usraMemberId =>
      text().references(Members, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {id};
}

/// stage: elementary | junior_high | senior_high | vocational | college
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
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get iconKey => text().withDefault(const Constant('group'))();
  IntColumn get accent => integer().withDefault(const Constant(0xFF0B5D3B))();
  TextColumn get headName => text().withDefault(const Constant(''))();
  TextColumn get contactEmail => text().withDefault(const Constant(''))();
  TextColumn get contactPhone => text().withDefault(const Constant(''))();

  /// The assigned Head of Department (an existing member), or null when none.
  /// SET NULL so deleting the member just vacates the headship.
  TextColumn get headMemberId =>
      text().nullable().references(Members, #id, onDelete: KeyAction.setNull)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Members assigned as staff of a department (many-to-many). Rows are removed
/// when either the department or the member is deleted.
@TableIndex(name: 'idx_dept_staff_dept', columns: {#departmentId})
class DepartmentStaff extends Table {
  TextColumn get id => text()();
  TextColumn get departmentId =>
      text().references(Departments, #id, onDelete: KeyAction.cascade)();
  TextColumn get memberId =>
      text().references(Members, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {id};

  /// A member appears at most once per department.
  @override
  List<Set<Column>> get uniqueKeys => [
        {departmentId, memberId},
      ];
}

/// Activities belonging to a department.
@TableIndex(name: 'idx_dept_activities_dept', columns: {#departmentId})
class DeptActivities extends Table {
  TextColumn get id => text()();
  TextColumn get departmentId =>
      text().references(Departments, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get date => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('planned'))();
  IntColumn get attendance => integer().withDefault(const Constant(0))();

  /// Structured form payload (JSON) for the Program Proposal (Form P-1). Empty
  /// for legacy free-form activities.
  TextColumn get formData => text().withDefault(const Constant(''))();
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
  TextColumn get summary => text().withDefault(const Constant(''))();
  TextColumn get date => text().withDefault(const Constant(''))();
  IntColumn get year => integer().withDefault(const Constant(0))();
  TextColumn get type => text().withDefault(const Constant('minutes'))();
  IntColumn get pages => integer().withDefault(const Constant(1))();

  /// Structured form payload (JSON) for the Program Completion Report (Form
  /// P-2). Empty for legacy minutes/resolution reports.
  TextColumn get formData => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Gallery archive photos (metadata; optional image file path).
class GalleryPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get year => integer().withDefault(const Constant(0))();
  TextColumn get event => text().withDefault(const Constant(''))();
  TextColumn get iconKey => text().withDefault(const Constant('photo'))();
  IntColumn get accent => integer().withDefault(const Constant(0xFF0B5D3B))();
  /// Cover image (first of the album), kept for the masonry thumbnail.
  TextColumn get imagePath => text().withDefault(const Constant(''))();

  /// JSON array of all stored image paths in this entry's album.
  TextColumn get imagePaths => text().withDefault(const Constant(''))();
  IntColumn get heightHint => integer().withDefault(const Constant(220))();

  /// Optional owning Program Completion Report (Form P-2). When set, this album
  /// holds the report's uploaded photos and is removed with the report.
  TextColumn get reportId =>
      text().nullable().references(Reports, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Editable description of a leadership group's functions (Office of the
/// President, Board of Trustees, and the Consultative Assembly sub-sections),
/// keyed by the group's category code.
class LeadershipGroupInfo extends Table {
  TextColumn get code => text()();
  TextColumn get description => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {code};
}

/// Executive Minutes-of-Meeting / Resolution reports (the sidebar Reports
/// archive). Each groups multiple attached images into an album; not
/// department-scoped, and visible only to executives.
class MinutesReports extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get year => integer().withDefault(const Constant(0))();

  /// `minutes` | `resolution`.
  TextColumn get type => text().withDefault(const Constant('minutes'))();
  TextColumn get content => text().withDefault(const Constant(''))();

  /// JSON array of stored image file paths (the album).
  TextColumn get imagePaths => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Singleton editable content for the History page (founding statement,
/// mission, vision, the "Our Story" narrative, and the stat cards). Exactly one
/// row, keyed `history`. Narrative and facts are stored as JSON arrays.
class HistoryContents extends Table {
  TextColumn get id => text().withDefault(const Constant('history'))();
  TextColumn get foundingEn => text().withDefault(const Constant(''))();
  TextColumn get missionEn => text().withDefault(const Constant(''))();
  TextColumn get visionEn => text().withDefault(const Constant(''))();

  /// JSON array of `{"en":..}` story paragraphs.
  TextColumn get narrative => text().withDefault(const Constant('[]'))();

  /// JSON array of `{"value":..,"en":..,"iconKey":..,"accent":int}`.
  TextColumn get facts => text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Editable history milestones (the timeline). Add / edit / delete.
@DataClassName('HistoryMilestone')
@TableIndex(name: 'idx_history_milestones_sort', columns: {#sortOrder})
class HistoryMilestones extends Table {
  TextColumn get id => text()();
  TextColumn get year => text().withDefault(const Constant(''))();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get iconKey => text().withDefault(const Constant('flag'))();
  IntColumn get accent => integer().withDefault(const Constant(0xFF0B5D3B))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Former leadership office-holders, each linked to an existing member.
@DataClassName('PreviousLeader')
@TableIndex(name: 'idx_previous_leaders_sort', columns: {#sortOrder})
class PreviousLeaders extends Table {
  TextColumn get id => text()();
  TextColumn get memberId =>
      text().references(Members, #id, onDelete: KeyAction.cascade)();
  TextColumn get position => text().withDefault(const Constant(''))();
  TextColumn get termYears => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
  IntColumn get accent => integer().withDefault(const Constant(0xFF16243D))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Repeatable biography sections (e.g. "Early Life", "Achievements") attached
/// to a former leadership office-holder.
@DataClassName('PreviousLeaderSection')
@TableIndex(name: 'idx_previous_leader_sections_leader', columns: {#previousLeaderId})
class PreviousLeaderSections extends Table {
  TextColumn get id => text()();
  TextColumn get previousLeaderId =>
      text().references(PreviousLeaders, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get body => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

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
  MemberWives,
  MemberUsraLinks,
  MemberEducation,
  MemberActivities,
  MemberContributions,
  MemberTased,
  MemberDonations,
  MemberRoles,
  Departments,
  DepartmentStaff,
  DeptActivities,
  Reports,
  GalleryPhotos,
  MinutesReports,
  LeadershipGroupInfo,
  HistoryContents,
  HistoryMilestones,
  PreviousLeaders,
  PreviousLeaderSections,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openOnDevice());

  /// In-memory database for tests.
  AppDatabase.memory() : super(NativeDatabase.memory());

  /// Schema history (v2–v24: Tarbiya hierarchy, referential integrity,
  /// department overviews, leader photos, member wives/Usra links,
  /// assignable leadership positions, department heads/staff, structured
  /// P-1/P-2 form payloads, Shu'ba Mas'ul, minutes reports, gallery albums,
  /// leadership group descriptions, the editable History page, Previous
  /// Leadership + biography sections, and finally the removal of every
  /// `*_ar` column) is now baked directly into the table definitions above,
  /// so there is nothing left to migrate incrementally — every install
  /// starts fresh at v1 with the current shape.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedAdministrator();
          await _seedDepartments();
          await _seedTarbiyaAreas();
          await _seedDefaultAccounts();
          await _seedLeadershipPositions();
          await _seedLeadershipGroupInfo();
          await _seedHistory();
        },
        beforeOpen: (details) async {
          // Foreign keys are off by default in SQLite and must be enabled per
          // connection — without this the declared FKs are not enforced.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Creates the default Administrator account on first launch so the system
  /// can be accessed before any data exists. Username `admin`, password
  /// `Admin@markazosshabab` (change immediately in production).
  Future<void> _seedAdministrator() async {
    await into(users).insert(
      UsersCompanion.insert(
        id: 'admin',
        fullName: 'System Administrator',
        username: 'admin',
        email: const Value('admin@markaz.org'),
        passwordHash: PasswordHasher.hash('Admin@markazosshabab'),
        roleCode: UserRole.administrator.code,
      ),
    );
  }

  /// Seeds the organization's nine standing departments on first launch,
  /// including each department's overview. Existing rows are left untouched
  /// (insertOrIgnore); [_backfillDepartmentContent] fills overviews for installs
  /// created before the overview text existed.
  Future<void> _seedDepartments() async {
    for (var i = 0; i < _departmentSeed.length; i++) {
      final d = _departmentSeed[i];
      await into(departments).insert(
        DepartmentsCompanion.insert(
          id: d.id,
          name: d.name,
          description: Value(d.description),
          iconKey: Value(d.icon),
          accent: Value(d.accent),
          sortOrder: Value(i),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  /// Backfills the department overviews and display order onto installs that
  /// already had the departments before this content existed (insertOrIgnore
  /// in [_seedDepartments] won't touch existing rows). Each overview is only
  /// written where the admin hasn't entered one, so manual edits are
  /// preserved; the sort order is always set since it isn't user-editable.
  // Future<void> _backfillDepartmentContent() async {
  //   for (var i = 0; i < _departmentSeed.length; i++) {
  //     final d = _departmentSeed[i];
  //     await (update(departments)..where((t) => t.id.equals(d.id)))
  //         .write(DepartmentsCompanion(sortOrder: Value(i)));
  //     await (update(departments)
  //           ..where((t) => t.id.equals(d.id) & t.description.equals('')))
  //         .write(DepartmentsCompanion(description: Value(d.description)));
  //   }
  // }

  /// Seeds one default account for every non-admin role so the system is
  /// immediately usable without manual account creation. All accounts use the
  /// temporary password `changeme123` and should be updated before production.
  /// Uses insertOrIgnore so re-running (e.g. on upgrade) is safe.
  Future<void> _seedDefaultAccounts() async {
    final tempHash = PasswordHasher.hash('changeme123');

    // Executive accounts (no department link).
    const executives = [
      ('president', 'president', 'President', 'president'),
      ('vice_president', 'vicepresident', 'Vice President', 'vice_president'),
      ('secretary_general', 'secretary', 'Secretary General',
          'secretary_general'),
      ('treasurer', 'treasurer', 'Treasurer', 'treasurer'),
    ];
    for (final (id, username, name, role) in executives) {
      await into(users).insert(
        UsersCompanion.insert(
          id: id,
          fullName: name,
          username: username,
          passwordHash: tempHash,
          roleCode: role,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }

    // One department-head account per department (must run after _seedDepartments).
    const heads = [
      ('head_dawah', 'head.dawah', "Head of Da'wah", 'dawah'),
      ('head_tarbiyah', 'head.tarbiyah', 'Head of Tarbiyah', 'tarbiyah'),
      ('head_education', 'head.education', 'Head of Education', 'education'),
      ('head_youth', 'head.youth', 'Head of Youth and Students', 'youth'),
      ('head_economy', 'head.economy', 'Head of Economy', 'economy'),
      ('head_charity', 'head.charity', 'Head of Charitable Programs',
          'charity'),
      ('head_media', 'head.media', 'Head of Public Relations', 'media'),
      ('head_politics', 'head.politics', 'Head of Politics', 'politics'),
      ('head_women', 'head.women', 'Head of Women Affairs', 'women'),
      ('head_human_capital', 'head.human_capital',
          'Head of Human Capital (Tarbiya)', 'human_capital'),
    ];
    for (final (id, username, name, deptId) in heads) {
      await into(users).insert(
        UsersCompanion.insert(
          id: id,
          fullName: name,
          username: username,
          passwordHash: tempHash,
          roleCode: UserRole.departmentHead.code,
          departmentId: Value(deptId),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  /// Seeds the standing leadership positions. Each is an assignable position
  /// (filled later by assigning an existing member), so the title fields hold
  /// the position label and the assigned member starts null. Sort order 0 shows
  /// first/prominently. Board of Trustees and the committees are not seeded —
  /// the admin defines their positions.
  ///
  /// Category codes: `office_president`, `assembly_general` (Consultative
  /// Assembly → General Membership). Board uses `board`; the committees use
  /// `committee_hayah` and `committee_audit`.
  Future<void> _seedLeadershipPositions() async {
    // Only the President (Office) and Chairman (Assembly General Membership)
    // are pre-seeded; admins add any other positions via "Add Position".
    const seed = [
      // (id, title, categoryCode, sortOrder)
      ('pos_president', 'President', 'office_president', 0),
      ('pos_chairman', 'Chairman', 'assembly_general', 0),
    ];
    for (final (id, title, category, order) in seed) {
      await into(leaders).insert(
        LeadersCompanion.insert(
          id: id,
          name: title,
          position: title,
          category: category,
          sortOrder: Value(order),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  /// Seeds the default, editable descriptions of each leadership group's
  /// functions. Executives can edit these later from each group's screen.
  Future<void> _seedLeadershipGroupInfo() async {
    const seed = [
      (
        'office_president',
        'The executive leadership of Markazosshabab. It sets the '
            'organization’s direction, oversees all departments and '
            'committees, represents the organization externally, and ensures '
            'its programs serve the mission.',
      ),
      (
        'board',
        'Provides governance and strategic oversight — safeguarding the '
            'organization’s mission, assets, and long-term direction, and '
            'holding the leadership accountable.',
      ),
      (
        'assembly_general',
        'The consultative body of the Assembly. It deliberates on policies, '
            'advises the leadership, and represents the general membership.',
      ),
      (
        'committee_hayah',
        'The Shari’ah committee. It ensures the organization’s '
            'activities conform to Islamic principles and provides religious '
            'guidance.',
      ),
      (
        'committee_audit',
        'The audit committee. It reviews finances and operations to ensure '
            'accountability, transparency, and the proper use of resources.',
      ),
    ];
    for (final (code, description) in seed) {
      await into(leadershipGroupInfo).insert(
        LeadershipGroupInfoCompanion.insert(
          code: code,
          description: Value(description),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  /// Seeds the editable History page from the bundled defaults: the singleton
  /// content row plus the milestones timeline. insertOrIgnore keeps any admin
  /// edits on re-run, and milestones are only seeded when the table is empty.
  Future<void> _seedHistory() async {
    await into(historyContents).insert(
      HistoryContentsCompanion.insert(
        id: const Value('history'),
        foundingEn: const Value(kFoundingEn),
        missionEn: Value(kMission.en),
        visionEn: Value(kVision.en),
        narrative: Value(jsonEncode([
          for (final p in kHistoryNarrative) {'en': p.en}
        ])),
        facts: Value(jsonEncode([
          for (final f in kDefaultFacts)
            {
              'value': f.value,
              'en': f.en,
              'iconKey': f.iconKey,
              'accent': f.accent,
            }
        ])),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    final existing = await select(historyMilestones).get();
    if (existing.isEmpty) {
      for (var i = 0; i < kDefaultMilestones.length; i++) {
        final m = kDefaultMilestones[i];
        await into(historyMilestones).insert(
          HistoryMilestonesCompanion.insert(
            id: 'milestone_$i',
            year: Value(m.year),
            title: Value(m.title),
            description: Value(m.description),
            iconKey: Value(m.iconKey),
            accent: Value(m.accent),
            sortOrder: Value(i),
          ),
        );
      }
    }
  }

  /// Seeds the standing Tarbiya Al-Kawadeer areas (Area 1–6 and the Special
  /// Area) on first launch so the hierarchy starts populated.
  Future<void> _seedTarbiyaAreas() async {
    const accents = [0xFF0B5D3B, 0xFF16243D, 0xFFA8862F];
    const seed = [
      ('area-1', 'Area 1'),
      ('area-2', 'Area 2'),
      ('area-3', 'Area 3'),
      ('area-4', 'Area 4'),
      ('area-5', 'Area 5'),
      ('area-6', 'Area 6'),
      ('area-special', 'Special Area'),
    ];
    var order = 0;
    for (final (id, name) in seed) {
      await into(tarbiyaAreas).insert(
        TarbiyaAreasCompanion.insert(
          id: id,
          name: name,
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

/// The organization's standing departments: stable id, name, icon, accent
/// colour, and the overview shown on each department page. The list order is
/// the display order. Used by both [AppDatabase._seedDepartments] (insert)
/// and [AppDatabase._backfillDepartmentContent] (update existing installs).
const _departmentSeed = <({
  String id,
  String name,
  String icon,
  int accent,
  String description,
})>[
  (
    id: 'dawah',
    name: 'Da‘wah',
    icon: 'dawah',
    accent: 0xFF0B5D3B,
    description:
        "The Department of Da‘wah serves as the absolute core and essence of "
        "the organization's mission, commanding the majority of its time, "
        "effort, and resources. For over four decades, its preachers have "
        "mobilized across the country, utilizing mosque pulpits, conferences, "
        "and public gatherings to call people to complete devotion and the "
        "adoption of Islam as a comprehensive way of life.",
  ),
  (
    id: 'tarbiyah',
    name: 'Tarbiyah',
    icon: 'tarbiyah',
    accent: 0xFF16243D,
    description:
        "Regarded as the backbone of the organization's internal development "
        "and societal reform, the Department of Tarbiyyah focuses deeply on "
        "raising individuals with sound faith, correct worship, and a strong "
        "dedication to their religion and community. Its methodologies are "
        "firmly rooted in following the path of early righteous predecessors "
        "and reformist thinkers to ensure robust character formation.",
  ),
  (
    id: 'education',
    name: 'Education',
    icon: 'education',
    accent: 0xFFA8862F,
    description:
        "Operating on the belief that education is the foundation for "
        "generation-building and societal cohesion, this department oversees a "
        "widespread network of schools across the Philippines. Its flagship "
        "institution, the Ibn Sina Integrated School in Marawi City, opened in "
        "1995 and has been recognized as a model school by both the national "
        "government and the ARMM Ministry of Education for its integrated "
        "academic curriculum and outstanding competition record.",
  ),
  (
    id: 'youth',
    name: 'Jihazu Thalaba (Youth and Students)',
    icon: 'group',
    accent: 0xFF16243D,
    description:
        "Recognizing youth and students as the future hope and essential human "
        "potential of the nation, this department is dedicated to their "
        "holistic development. It established the Muslim Students' Union in the "
        "Philippines shortly after the center's founding and continues to "
        "oversee various youth associations designed to prepare young people to "
        "eventually take up the reins of leadership.",
  ),
  (
    id: 'economy',
    name: 'Economy and Investments',
    icon: 'economy',
    accent: 0xFF0B5D3B,
    description:
        "The Department of Economy aims to achieve organizational "
        "self-sufficiency while assisting the public by making basic "
        "commodities affordable. While historically known for service-oriented "
        "projects like the Ranao Pharmacy and the Sahaba rice mill, its modern "
        "initiatives include regional market integration through the World "
        "Halal Chamber of Commerce and Industry in the Philippines and the "
        "recently launched Tabatuj Cooperative Association.",
  ),
  (
    id: 'charity',
    name: 'Charitable Programs',
    icon: 'charity',
    accent: 0xFF16243D,
    description:
        "Functioning as a vital humanitarian bridge between benefactors and "
        "those in need, this department operates strictly on principles of "
        "equality, justice, and fairness without tribal or geographic bias. "
        "Its comprehensive relief efforts include sponsoring orphans and "
        "students, digging drinking-water wells, and constructing mosques, "
        "schools, and hospitals in cooperation with various local and "
        "international relief organizations.",
  ),
  (
    id: 'media',
    name: 'Public Relations and Information',
    icon: 'media',
    accent: 0xFFA8862F,
    description:
        "In a firm rejection of insularity and intellectual bigotry, this "
        "department actively fosters dialogue and constructive cooperation with "
        "all societal segments, regardless of political, sectarian, or ethnic "
        "affiliations. It mobilizes organizational strength to support national "
        "cohesion and government policies, raising its voice against "
        "corruption, drugs, and extremism while advocating for human rights and "
        "virtuous societal values.",
  ),
  (
    id: 'politics',
    name: 'Politics',
    icon: 'politics',
    accent: 0xFF0B5D3B,
    description:
        "The Department of Politics pursues comprehensive societal reform by "
        "engaging in the political arena, recognizing it as a challenging but "
        "necessary path. Operating under the slogan \"Let us reform society and "
        "save the people,\" it established the Ummah Party in 1998, fielding "
        "honest candidates and forming strategic alliances, even as it "
        "continues to navigate and challenge the systemic deterioration of the "
        "political climate and the spread of corruption.",
  ),
  (
    id: 'women',
    name: 'Women Affairs',
    icon: 'women',
    accent: 0xFF16243D,
    description:
        "Believing that the Filipino Muslim woman is the indispensable "
        "cornerstone of society, this department strives to empower women as "
        "essential partners to men in all fields of work, including "
        "decision-making, planning, and implementation. Through this structural "
        "support and empowerment, affiliated women have successfully taken on "
        "vital roles as preachers, educators, volunteers, and frontline "
        "community workers.",
  ),
  (
    id: 'human_capital',
    name: 'Human Capital (Tarbiya)',
    icon: 'group',
    accent: 0xFF16243D,
    description:
        "The Human Capital (Tarbiya) Department develops the organization's "
        "people — its members and volunteers — through structured nurturing, "
        "mentoring, and capacity-building so that every individual grows in "
        "faith, character, and competence to serve the mission.",
  ),
];