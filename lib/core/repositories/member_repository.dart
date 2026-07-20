import 'package:drift/drift.dart';

import '../data/app_database.dart';
import '../data/models.dart';
import '../util/photo_service.dart';

/// Full CRUD for a member and all profile sub-records (children, education,
/// activities, contributions, tas'ed, donations, organizational roles).
class MemberRepository {
  MemberRepository(this._db, [this._photos = const PhotoService()]);
  final AppDatabase _db;
  final PhotoService _photos;

  String _id(String prefix) => newId(prefix);

  // ── Member ───────────────────────────────────────────────────────────────

  /// Every member across all shu'bas, newest first — for the Members
  /// Management directory.
  Stream<List<Member>> watchAllMembers() => (_db.select(_db.members)
        ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
      .watch();

  Stream<Member?> watchMember(String id) =>
      (_db.select(_db.members)..where((m) => m.id.equals(id)))
          .watchSingleOrNull();

  Future<Member?> getMember(String id) =>
      (_db.select(_db.members)..where((m) => m.id.equals(id)))
          .getSingleOrNull();

  /// Whether another member already has this full name (case-insensitive,
  /// whitespace-collapsed; first + middle + last + suffix, matching
  /// [MemberX.fullName]). Pass [excludeId] to ignore the member being edited.
  Future<bool> fullNameExists(
    String firstName,
    String middleName,
    String lastName,
    String suffix, {
    String? excludeId,
  }) async {
    String norm(String f, String m, String l, String s) => [f, m, l, s]
        .map((x) => x.trim())
        .where((x) => x.isNotEmpty)
        .join(' ')
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');
    final target = norm(firstName, middleName, lastName, suffix);
    if (target.isEmpty) return false;
    final rows = await _db.select(_db.members).get();
    return rows.any((m) =>
        m.id != excludeId &&
        norm(m.firstName, m.middleName, m.lastName, m.suffix) == target);
  }

  /// Inserts a new member. Pass a companion with the desired fields; an id is
  /// generated if absent. Returns the new id.
  Future<String> insertMember(MembersCompanion data) async {
    final id = data.id.present ? data.id.value : _id('member');
    await _db.into(_db.members).insert(data.copyWith(id: Value(id)));
    return id;
  }

  Future<void> updateMember(String id, MembersCompanion data) =>
      (_db.update(_db.members)..where((m) => m.id.equals(id))).write(data);

  Future<void> deleteMember(String id) async {
    // Capture the photo path before the row is gone so its file can be cleaned
    // up. All member sub-records have an ON DELETE CASCADE foreign key, so
    // deleting the member row removes them automatically (foreign keys are
    // enabled in AppDatabase.beforeOpen).
    final member = await getMember(id);
    await (_db.delete(_db.members)..where((m) => m.id.equals(id))).go();
    await _photos.deleteStored(member?.photoPath);
  }

  // ── Children ─────────────────────────────────────────────────────────────
  Stream<List<MemberChildrenData>> watchChildren(String memberId) =>
      (_db.select(_db.memberChildren)
            ..where((c) => c.memberId.equals(memberId)))
          .watch();

  Future<void> addChild(String memberId, String name, String dob,
          {String occupation = '', String profession = ''}) =>
      _db.into(_db.memberChildren).insert(MemberChildrenCompanion.insert(
            id: _id('child'),
            memberId: memberId,
            name: name,
            dob: Value(dob),
            occupation: Value(occupation),
            profession: Value(profession),
          ));

  Future<void> updateChild(String id, String name, String dob,
          {String occupation = '', String profession = ''}) =>
      (_db.update(_db.memberChildren)..where((c) => c.id.equals(id)))
          .write(MemberChildrenCompanion(
        name: Value(name),
        dob: Value(dob),
        occupation: Value(occupation),
        profession: Value(profession),
      ));

  Future<void> deleteChild(String id) =>
      (_db.delete(_db.memberChildren)..where((c) => c.id.equals(id))).go();

  // ── Education ────────────────────────────────────────────────────────────
  Stream<List<MemberEducationData>> watchEducation(String memberId) =>
      (_db.select(_db.memberEducation)
            ..where((e) => e.memberId.equals(memberId)))
          .watch();

  Future<void> addEducation({
    required String memberId,
    required String stage,
    required String schoolName,
    String degree = '',
    String program = '',
    String yearGraduated = '',
  }) =>
      _db.into(_db.memberEducation).insert(MemberEducationCompanion.insert(
            id: _id('edu'),
            memberId: memberId,
            stage: stage,
            schoolName: schoolName,
            degree: Value(degree),
            program: Value(program),
            yearGraduated: Value(yearGraduated),
          ));

  Future<void> deleteEducation(String id) =>
      (_db.delete(_db.memberEducation)..where((e) => e.id.equals(id))).go();

  // ── Activities ───────────────────────────────────────────────────────────
  Stream<List<MemberActivity>> watchActivities(String memberId) =>
      (_db.select(_db.memberActivities)
            ..where((a) => a.memberId.equals(memberId))
            ..orderBy([(a) => OrderingTerm.desc(a.date)]))
          .watch();

  Future<void> addActivity({
    required String memberId,
    required String name,
    required String type,
    required String date,
    required String attendanceStatus,
    String remarks = '',
  }) =>
      _db.into(_db.memberActivities).insert(MemberActivitiesCompanion.insert(
            id: _id('act'),
            memberId: memberId,
            name: name,
            type: Value(type),
            date: Value(date),
            attendanceStatus: Value(attendanceStatus),
            remarks: Value(remarks),
          ));

  Future<void> deleteActivity(String id) =>
      (_db.delete(_db.memberActivities)..where((a) => a.id.equals(id))).go();

  // ── Contributions ────────────────────────────────────────────────────────
  Stream<List<MemberContribution>> watchContributions(String memberId) =>
      (_db.select(_db.memberContributions)
            ..where((c) => c.memberId.equals(memberId))
            ..orderBy([(c) => OrderingTerm.desc(c.date)]))
          .watch();

  Future<void> addContribution({
    required String memberId,
    required String title,
    String description = '',
    String date = '',
    String status = 'active',
  }) =>
      _db
          .into(_db.memberContributions)
          .insert(MemberContributionsCompanion.insert(
            id: _id('contrib'),
            memberId: memberId,
            title: title,
            description: Value(description),
            date: Value(date),
            status: Value(status),
          ));

  Future<void> updateContribution(String id,
          {required String title,
          required String description,
          required String date,
          required String status}) =>
      (_db.update(_db.memberContributions)..where((c) => c.id.equals(id)))
          .write(MemberContributionsCompanion(
        title: Value(title),
        description: Value(description),
        date: Value(date),
        status: Value(status),
      ));

  Future<void> deleteContribution(String id) =>
      (_db.delete(_db.memberContributions)..where((c) => c.id.equals(id)))
          .go();

  // ── Tas'ed ───────────────────────────────────────────────────────────────
  Stream<List<MemberTasedData>> watchTased(String memberId) =>
      (_db.select(_db.memberTased)
            ..where((t) => t.memberId.equals(memberId))
            ..orderBy([(t) => OrderingTerm(expression: t.level)]))
          .watch();

  Future<void> addTased({
    required String memberId,
    required int level,
    required String year,
    required String status,
  }) async {
    await _db.into(_db.memberTased).insert(MemberTasedCompanion.insert(
          id: _id('tased'),
          memberId: memberId,
          level: level,
          year: Value(year),
          status: Value(status),
        ));
    await _syncLevelFromTased(memberId);
  }

  Future<void> updateTased(String id,
      {required int level, required String year, required String status}) async {
    await (_db.update(_db.memberTased)..where((t) => t.id.equals(id))).write(
        MemberTasedCompanion(
            level: Value(level), year: Value(year), status: Value(status)));
    final row = await (_db.select(_db.memberTased)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row != null) await _syncLevelFromTased(row.memberId);
  }

  Future<void> deleteTased(String id) async {
    final row = await (_db.select(_db.memberTased)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await (_db.delete(_db.memberTased)..where((t) => t.id.equals(id))).go();
    if (row != null) await _syncLevelFromTased(row.memberId);
  }

  /// Keeps a member's tarbiya level driven by their Tas'ed records: the level
  /// becomes the level of their *most recent* Tas'ed entry — the highest year,
  /// or the latest-inserted row when years tie. With no Tas'ed records the level
  /// is 0 ("no level"). Called after every Tas'ed insert/update/delete.
  Future<void> _syncLevelFromTased(String memberId) async {
    final records = await (_db.select(_db.memberTased)
          ..where((t) => t.memberId.equals(memberId)))
        .get();
    var level = 0;
    if (records.isNotEmpty) {
      records.sort((a, b) {
        final yearA = int.tryParse(a.year) ?? 0;
        final yearB = int.tryParse(b.year) ?? 0;
        if (yearA != yearB) return yearB.compareTo(yearA); // newest year first
        // Tie: latest inserted first. The id embeds an insertion timestamp,
        // so descending id order is a reliable "most recent" tiebreak.
        return b.id.compareTo(a.id);
      });
      level = records.first.level;
    }
    await (_db.update(_db.members)..where((m) => m.id.equals(memberId)))
        .write(MembersCompanion(level: Value(level)));
  }

  // ── Donations ────────────────────────────────────────────────────────────
  Stream<List<MemberDonation>> watchDonations(String memberId, int year) =>
      (_db.select(_db.memberDonations)
            ..where((d) => d.memberId.equals(memberId) & d.year.equals(year))
            ..orderBy([(d) => OrderingTerm(expression: d.month)]))
          .watch();

  /// Inserts or updates the donation record for a given month.
  Future<void> setDonation({
    required String memberId,
    required int year,
    required int month,
    required bool donated,
    String date = '',
    double amount = 0,
    String notes = '',
  }) async {
    final existing = await (_db.select(_db.memberDonations)
          ..where((d) =>
              d.memberId.equals(memberId) &
              d.year.equals(year) &
              d.month.equals(month)))
        .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.memberDonations).insert(MemberDonationsCompanion.insert(
            id: _id('don'),
            memberId: memberId,
            year: year,
            month: month,
            donated: Value(donated),
            date: Value(date),
            amount: Value(amount),
            notes: Value(notes),
          ));
    } else {
      await (_db.update(_db.memberDonations)
            ..where((d) => d.id.equals(existing.id)))
          .write(MemberDonationsCompanion(
        donated: Value(donated),
        date: Value(date),
        amount: Value(amount),
        notes: Value(notes),
      ));
    }
  }

  // ── Organizational roles ─────────────────────────────────────────────────
  Stream<List<MemberRole>> watchRoles(String memberId) =>
      (_db.select(_db.memberRoles)
            ..where((r) => r.memberId.equals(memberId)))
          .watch();

  Future<void> addRole({
    required String memberId,
    required String positionTitle,
    String department = '',
    String startDate = '',
    String endDate = '',
    String status = 'active',
  }) =>
      _db.into(_db.memberRoles).insert(MemberRolesCompanion.insert(
            id: _id('role'),
            memberId: memberId,
            positionTitle: positionTitle,
            department: Value(department),
            startDate: Value(startDate),
            endDate: Value(endDate),
            status: Value(status),
          ));

  Future<void> updateRole(String id,
          {required String positionTitle,
          required String department,
          required String startDate,
          required String endDate,
          required String status}) =>
      (_db.update(_db.memberRoles)..where((r) => r.id.equals(id))).write(
          MemberRolesCompanion(
              positionTitle: Value(positionTitle),
              department: Value(department),
              startDate: Value(startDate),
              endDate: Value(endDate),
              status: Value(status)));

  Future<void> deleteRole(String id) =>
      (_db.delete(_db.memberRoles)..where((r) => r.id.equals(id))).go();

  // ── Wives (up to 4 — the cap is enforced in the form) ─────────────────────
  Stream<List<MemberWife>> watchWives(String memberId) =>
      (_db.select(_db.memberWives)..where((w) => w.memberId.equals(memberId)))
          .watch();

  Future<void> addWife(String memberId, String name, String marriageDate) =>
      _db.into(_db.memberWives).insert(MemberWivesCompanion.insert(
            id: _id('wife'),
            memberId: memberId,
            name: name,
            marriageDate: Value(marriageDate),
          ));

  Future<void> deleteWife(String id) =>
      (_db.delete(_db.memberWives)..where((w) => w.id.equals(id))).go();

  // ── Usra members (derived from a shared Naqib) ─────────────────────────────
  /// Members whose Naqib is [naqibId] — i.e. the students of that Naqib's
  /// tutorial class. Pass [excludeId] to leave out the member being viewed.
  /// Pass [section] to restrict to one class (same Naqib AND same usraName —
  /// the empty string is a valid section of its own); null spans all sections.
  /// Pass [level] to also require the same tarbiya level — a class is scoped
  /// to (Naqib, section, level), so two members in different levels never
  /// share a class even if their Naqib/section text happen to match.
  Stream<List<Member>> watchMembersOfNaqib(String naqibId,
      {String? excludeId, String? section, int? level}) {
    return (_db.select(_db.members)
          ..where((m) {
            final sameNaqib = m.naqibMemberId.equals(naqibId);
            final notSelf = excludeId == null
                ? const Constant(true)
                : m.id.equals(excludeId).not();
            final sameSection = section == null
                ? const Constant(true)
                : m.usraName.equals(section);
            final sameLevel =
                level == null ? const Constant(true) : m.level.equals(level);
            return sameNaqib & notSelf & sameSection & sameLevel;
          })
          ..orderBy([(m) => OrderingTerm(expression: m.firstName)]))
        .watch();
  }

  // ── Member search (for the Naqib / student pickers) ───────────────────────
  /// Members whose name matches [query] (first/middle/last), excluding
  /// [excludeId]. Pass [shubaId] and/or [level] to restrict the pool (e.g.
  /// the Add Class student picker only offers members of that shu'ba level).
  /// Returns up to [limit] results ordered by first name.
  Future<List<Member>> searchMembers(String query,
      {String? excludeId, int limit = 25, String? shubaId, int? level}) {
    final q = query.trim();
    final like = '%$q%';
    return (_db.select(_db.members)
          ..where((m) {
            final matches = q.isEmpty
                ? const Constant(true)
                : (m.firstName.like(like) |
                    m.middleName.like(like) |
                    m.lastName.like(like));
            final notSelf = excludeId == null
                ? const Constant(true)
                : m.id.equals(excludeId).not();
            final inShuba = shubaId == null
                ? const Constant(true)
                : m.shubaId.equals(shubaId);
            final inLevel =
                level == null ? const Constant(true) : m.level.equals(level);
            return matches & notSelf & inShuba & inLevel;
          })
          ..orderBy([(m) => OrderingTerm(expression: m.firstName)])
          ..limit(limit))
        .get();
  }
}
