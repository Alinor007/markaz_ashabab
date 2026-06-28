// Smoke + data-layer tests for the database-backed, role-based app.

import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:markaz_ashabab/app/markaz_app.dart';
import 'package:markaz_ashabab/core/auth/roles.dart';
import 'package:markaz_ashabab/core/data/app_database.dart';
import 'package:markaz_ashabab/core/data/models.dart';
import 'package:markaz_ashabab/core/repositories/department_repository.dart';
import 'package:markaz_ashabab/core/repositories/gallery_repository.dart';
import 'package:markaz_ashabab/core/repositories/leader_repository.dart';
import 'package:markaz_ashabab/core/repositories/member_repository.dart';
import 'package:markaz_ashabab/core/repositories/minutes_report_repository.dart';
import 'package:markaz_ashabab/core/repositories/report_repository.dart';
import 'package:markaz_ashabab/core/repositories/tarbiya_repository.dart';
import 'package:markaz_ashabab/core/repositories/user_repository.dart';

void main() {
  group('data layer', () {
    late AppDatabase db;

    setUp(() => db = AppDatabase.memory());
    tearDown(() => db.close());

    test('seeds an administrator account on first launch', () async {
      final users = await UserRepository(db).watchAll().first;
      // 1 admin + 3 executives + 9 department heads seeded by default.
      expect(users, hasLength(13));
      final admin = users.firstWhere((u) => u.username == 'admin');
      expect(admin.role, UserRole.administrator);
    });

    test('authenticates the seeded admin and rejects bad credentials',
        () async {
      final repo = UserRepository(db);
      expect(await repo.authenticate('admin', 'admin123'), isNotNull);
      expect(await repo.authenticate('admin', 'wrong'), isNull);
      expect(await repo.authenticate('ghost', 'admin123'), isNull);
    });

    test('creates users and enforces unique usernames', () async {
      final repo = UserRepository(db);
      await repo.create(
        fullName: 'Aisha Lomondot',
        fullNameAr: 'عائشة لوموندوت',
        username: 'a.lomondot',
        email: 'a@markaz.org',
        password: 'secret12',
        role: UserRole.departmentHead,
      );
      expect(await repo.usernameExists('a.lomondot'), isTrue);
      expect(await repo.usernameExists('unique.name'), isFalse);
      final users = await repo.watchAll().first;
      expect(users, hasLength(14)); // 13 seeded + 1 created
    });

    test('leadership CRUD by category', () async {
      final repo = LeaderRepository(db);
      // Board is not seeded, so it cleanly verifies category filtering.
      await repo.create(
        name: 'Dr. Abdullah Macarambon',
        nameAr: 'عبد الله',
        position: 'Chairman',
        positionAr: 'الرئيس',
        category: LeadershipCategory.board,
      );
      final board =
          await repo.watchByCategory(LeadershipCategory.board).first;
      final assembly =
          await repo.watchByCategory(LeadershipCategory.assembly).first;
      expect(board, hasLength(1));
      expect(assembly, isEmpty);
    });

    test('seeds leadership positions (Office of the President + Chairman)',
        () async {
      final repo = LeaderRepository(db);
      final office =
          await repo.watchByCategory(LeadershipCategory.officePresident).first;
      // Only the President is pre-seeded now (VP/Sec-Gen/Treasurer removed).
      expect(office, hasLength(1));
      expect(office.first.id, 'pos_president');
      expect(office.single.memberId, isNull);

      // Assembly → General Membership seeds a Chairman; Board has no seeds.
      final general = await repo.watchByCategoryCode('assembly_general').first;
      expect(general.map((p) => p.position), contains('Chairman'));
      expect(await repo.watchByCategoryCode('board').first, isEmpty);

      // Each leadership group has a seeded, editable description.
      expect((await repo.watchGroupInfo('office_president').first)?.description,
          isNotEmpty);
      await repo.setGroupDescription('board', 'Custom', 'مخصص');
      expect(
          (await repo.watchGroupInfo('board').first)?.description, 'Custom');
    });

    test('assigning a member fills a position; clearing vacates it', () async {
      final tarbiya = TarbiyaRepository(db);
      final members = MemberRepository(db);
      final leaders = LeaderRepository(db);
      await tarbiya.createArea(name: 'Lead Area', nameAr: 'أ');
      // Tarbiya seeds default areas, so find ours by name rather than .single.
      final area =
          (await tarbiya.getAreas()).firstWhere((a) => a.name == 'Lead Area');
      await tarbiya.createShuba(areaId: area.id, name: 'S', nameAr: 'ش');
      final shuba = (await tarbiya.watchShubas(area.id).first).single;
      final memberId = await members.insertMember(MembersCompanion(
        shubaId: Value(shuba.id),
        firstName: const Value('Yusuf'),
        lastName: const Value('Datu'),
      ));

      await leaders.assignMember('pos_president', memberId);
      expect((await leaders.watchAssignedMember('pos_president').first)?.id,
          memberId);

      await leaders.assignMember('pos_president', null);
      expect(await leaders.watchAssignedMember('pos_president').first, isNull);
    });
  });

  group('tarbiya data layer', () {
    late AppDatabase db;
    late TarbiyaRepository tarbiya;
    late MemberRepository members;

    setUp(() {
      db = AppDatabase.memory();
      tarbiya = TarbiyaRepository(db);
      members = MemberRepository(db);
    });
    tearDown(() => db.close());

    // A uniquely-named area so it can be selected even though the database
    // seeds the standing default areas (Area 1–6, Special Area) on creation.
    const testAreaName = 'Test Area';

    Future<TarbiyaArea> testArea() async =>
        (await tarbiya.getAreas()).firstWhere((a) => a.name == testAreaName);

    Future<String> seedMember({int level = 1, String status = 'active'}) async {
      await tarbiya.createArea(name: testAreaName, nameAr: 'منطقة الاختبار');
      final area = await testArea();
      await tarbiya.createShuba(areaId: area.id, name: 'Shu\'ba A', nameAr: 'شعبة');
      final shuba = (await tarbiya.watchShubas(area.id).first).single;
      return members.insertMember(MembersCompanion(
        shubaId: Value(shuba.id),
        level: Value(level),
        firstName: const Value('Yusuf'),
        lastName: const Value('Dimaporo'),
        status: Value(status),
      ));
    }

    test('area → shuba → member with level counts', () async {
      final id = await seedMember(level: 2);
      final area = await testArea();
      final shuba = (await tarbiya.watchShubas(area.id).first).single;

      final lvl2 = await tarbiya.watchMembers(shuba.id, 2).first;
      expect(lvl2.single.id, id);
      expect(lvl2.single.fullName, 'Yusuf Dimaporo');

      final counts = await tarbiya.watchLevelCounts(shuba.id).first;
      expect(counts[2]!.total, 1);
      expect(counts[2]!.active, 1);
      expect(counts[1]!.total, 0);
    });

    test('member sub-records CRUD', () async {
      final id = await seedMember();

      await members.addTased(memberId: id, level: 1, year: '2025', status: 'active');
      expect((await members.watchTased(id).first).single.year, '2025');

      await members.addRole(memberId: id, positionTitle: 'Naqib');
      expect((await members.watchRoles(id).first).single.positionTitle, 'Naqib');

      await members.setDonation(
          memberId: id, year: 2026, month: 3, donated: true, amount: 500);
      final donations = await members.watchDonations(id, 2026).first;
      expect(donations.single.donated, isTrue);
      // setDonation upserts the same month rather than duplicating.
      await members.setDonation(
          memberId: id, year: 2026, month: 3, donated: true, amount: 750);
      expect((await members.watchDonations(id, 2026).first), hasLength(1));

      await members.deleteMember(id);
      expect(await members.getMember(id), isNull);
      expect(await members.watchTased(id).first, isEmpty);
    });

    test("member level is driven by the most recent Tas'ed record", () async {
      final id = await seedMember();

      await members.addTased(
          memberId: id, level: 3, year: '2025', status: 'active');
      expect((await members.getMember(id))!.level, 3);

      // Newest year wins (regardless of active/inactive).
      await members.addTased(
          memberId: id, level: 4, year: '2026', status: 'inactive');
      expect((await members.getMember(id))!.level, 4);

      // An older year is ignored.
      await members.addTased(
          memberId: id, level: 2, year: '2024', status: 'active');
      expect((await members.getMember(id))!.level, 4);

      // Updating the most-recent (2026) record re-syncs.
      final y2026 =
          (await members.watchTased(id).first).firstWhere((t) => t.year == '2026');
      await members.updateTased(y2026.id, level: 5, year: '2026', status: 'active');
      expect((await members.getMember(id))!.level, 5);

      // Deleting the most-recent falls back to the next most recent (2025 → 3).
      await members.deleteTased(y2026.id);
      expect((await members.getMember(id))!.level, 3);

      // Removing every Tas'ed record clears the level to 0.
      for (final t in await members.watchTased(id).first) {
        await members.deleteTased(t.id);
      }
      expect((await members.getMember(id))!.level, 0);
    });

    test("Shu'ba Mas'ul can be assigned and cleared", () async {
      final id = await seedMember();
      final shubaId = (await members.getMember(id))!.shubaId;
      await tarbiya.assignMasul(shubaId, id);
      expect((await tarbiya.watchMasul(shubaId).first)?.id, id);
      await tarbiya.assignMasul(shubaId, null);
      expect(await tarbiya.watchMasul(shubaId).first, isNull);
    });

    test('wives, naqib & usra members', () async {
      final id1 = await seedMember();
      final area = await testArea();
      final shuba = (await tarbiya.watchShubas(area.id).first).single;
      final id2 = await members.insertMember(MembersCompanion(
        shubaId: Value(shuba.id),
        firstName: const Value('Ali'),
        lastName: const Value('Macarambon'),
      ));

      // Wives are stored as free-text rows (the 4-max cap is a UI rule).
      await members.addWife(id1, 'Aisha', '2018-06-01');
      await members.addWife(id1, 'Khadija', '');
      expect(await members.watchWives(id1).first, hasLength(2));

      // Member search matches by name and can exclude a given id.
      expect((await members.searchMembers('Ali')).map((m) => m.id),
          contains(id2));
      expect((await members.searchMembers('Ali', excludeId: id2)).map((m) => m.id),
          isNot(contains(id2)));
      // An empty query (the picker's initial load) returns all members.
      final all = await members.searchMembers('');
      expect(all.map((m) => m.id), containsAll([id1, id2]));

      // Usra members are explicit links to existing members.
      await members.addUsraMember(id1, id2);
      expect((await members.watchUsraMembers(id1).first).single.id, id2);

      // Naqib is a self-reference stored on the member.
      await members.updateMember(
          id1, MembersCompanion(naqibMemberId: Value(id2)));
      expect((await members.getMember(id1))!.naqibMemberId, id2);

      // Deleting the linked member cascades the usra link and nulls the naqib.
      await members.deleteMember(id2);
      expect(await members.watchUsraMembers(id1).first, isEmpty);
      expect((await members.getMember(id1))!.naqibMemberId, isNull);
    });
  });

  group('departments & reports data layer', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase.memory());
    tearDown(() => db.close());

    test('seeds the nine standing departments with overviews', () async {
      final depts = await DepartmentRepository(db).getAll();
      expect(depts, hasLength(9));
      expect(depts.map((d) => d.name), contains('Tarbiyah'));
      expect(depts.map((d) => d.name), contains('Economy and Investments'));
      // Youth & Students was added in schema v7.
      final youth = depts.firstWhere((d) => d.id == 'youth');
      expect(youth.description, isNotEmpty);
      // Bilingual overviews are seeded (Arabic added in schema v8).
      expect(youth.descriptionAr, isNotEmpty);
      expect(depts.firstWhere((d) => d.id == 'dawah').descriptionAr, isNotEmpty);
    });

    test('report CRUD + department filtering', () async {
      final deptRepo = DepartmentRepository(db);
      final reportRepo = ReportRepository(db);
      final depts = await deptRepo.getAll();
      final dawah = depts.firstWhere((d) => d.id == 'dawah');

      await reportRepo.create(
        departmentId: dawah.id,
        title: 'Da‘wah Q1 Minutes',
        year: 2026,
        type: 'minutes',
      );
      final inDawah = await reportRepo.watchByDepartment(dawah.id).first;
      expect(inDawah, hasLength(1));
      expect(inDawah.single.typeEnum.code, 'minutes');
      expect(await reportRepo.count(), 1);

      // Activities count.
      await deptRepo.addActivity(departmentId: dawah.id, title: 'Lecture');
      expect(await deptRepo.totalActivities(), 1);
    });

    test('report stores the Program Completion (P-2) form payload', () async {
      final deptRepo = DepartmentRepository(db);
      final reportRepo = ReportRepository(db);
      final dawah = (await deptRepo.getAll()).firstWhere((d) => d.id == 'dawah');
      await reportRepo.create(
        departmentId: dawah.id,
        title: 'Outreach Program',
        year: 2026,
        type: ReportType.programCompletion.code,
        formData: '{"programTitle":"Outreach Program","challenges":["rain"]}',
      );
      final r = (await reportRepo.watchByDepartment(dawah.id).first).single;
      expect(r.typeEnum, ReportType.programCompletion);
      expect(r.formData, contains('Outreach Program'));
    });

    test('activity stores the Program Proposal (P-1) form payload', () async {
      final depts = DepartmentRepository(db);
      await depts.addActivity(
        departmentId: 'dawah',
        title: 'Community Cleanup',
        formData: '{"programTitle":"Community Cleanup","objectives":["clean"]}',
      );
      final acts = await depts.watchActivities('dawah').first;
      expect(acts.single.formData, contains('Community Cleanup'));
    });

    test('executive minutes/resolution reports: create, list, delete',
        () async {
      final repo = MinutesReportRepository(db);
      await repo.create(
        title: 'Board Minutes Q1',
        year: 2026,
        type: 'minutes',
        content: 'Discussion notes',
        imagePaths: const ['/x/a.jpg', '/x/b.jpg'],
      );
      final list = await repo.watchAll().first;
      expect(list, hasLength(1));
      expect(list.single.type, 'minutes');
      expect(MinutesReportRepository.imagesOf(list.single),
          ['/x/a.jpg', '/x/b.jpg']);
      await repo.delete(list.single.id);
      expect(await repo.watchAll().first, isEmpty);
    });

    test('gallery add/delete', () async {
      final repo = GalleryRepository(db);
      await repo.add(title: 'Eid Gathering', year: 2026, event: 'Community');
      final photos = await repo.getAll();
      expect(photos, hasLength(1));
      await repo.delete(photos.single.id);
      expect(await repo.count(), 0);
    });

    test('department head member + staff assignment', () async {
      final tarbiya = TarbiyaRepository(db);
      final members = MemberRepository(db);
      final depts = DepartmentRepository(db);
      await tarbiya.createArea(name: 'Dept Area', nameAr: 'أ');
      final area =
          (await tarbiya.getAreas()).firstWhere((a) => a.name == 'Dept Area');
      await tarbiya.createShuba(areaId: area.id, name: 'S', nameAr: 'ش');
      final shuba = (await tarbiya.watchShubas(area.id).first).single;
      final m1 = await members.insertMember(MembersCompanion(
          shubaId: Value(shuba.id),
          firstName: const Value('Omar'),
          lastName: const Value('A')));
      final m2 = await members.insertMember(MembersCompanion(
          shubaId: Value(shuba.id),
          firstName: const Value('Bilal'),
          lastName: const Value('B')));

      // Head assignment fills then vacates (dawah is a seeded department).
      // Read back via getById (a Future) rather than a stream, so the
      // assertion is deterministic in the full suite.
      await depts.assignHead('dawah', m1);
      expect((await depts.getById('dawah'))!.headMemberId, m1);
      await depts.assignHead('dawah', null);
      expect((await depts.getById('dawah'))!.headMemberId, isNull);

      // Staff: add (dedup), then remove.
      Future<List<String>> staffIds() async => (await db
              .select(db.departmentStaff)
              .get())
          .where((s) => s.departmentId == 'dawah')
          .map((s) => s.memberId)
          .toList();
      await depts.addStaff('dawah', m1);
      await depts.addStaff('dawah', m2);
      await depts.addStaff('dawah', m1); // duplicate is ignored
      expect(await staffIds(), unorderedEquals([m1, m2]));
      await depts.removeStaff('dawah', m1);
      expect(await staffIds(), [m2]);
    });
  });

  group('schema integrity (v5)', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase.memory());
    tearDown(() => db.close());

    Future<String> seedRealMember() async {
      final tarbiya = TarbiyaRepository(db);
      final members = MemberRepository(db);
      await tarbiya.createArea(name: 'FK Area', nameAr: 'منطقة');
      final area = (await tarbiya.getAreas()).firstWhere((a) => a.name == 'FK Area');
      await tarbiya.createShuba(areaId: area.id, name: 'FK Shuba', nameAr: 'شعبة');
      final shuba = (await tarbiya.watchShubas(area.id).first).single;
      return members.insertMember(MembersCompanion(
        shubaId: Value(shuba.id),
        firstName: const Value('Test'),
        lastName: const Value('Member'),
      ));
    }

    test('foreign keys are enforced: orphan sub-row is rejected', () async {
      // member_activities.member_id REFERENCES members(id).
      await expectLater(
        db.into(db.memberActivities).insert(MemberActivitiesCompanion.insert(
          id: 'act_orphan',
          memberId: 'does-not-exist',
          name: 'Ghost activity',
        )),
        throwsA(isA<Exception>()),
      );
    });

    test('deleting a member cascades its sub-records', () async {
      final id = await seedRealMember();
      final members = MemberRepository(db);
      await members.addTased(
          memberId: id, level: 1, year: '2025', status: 'active');
      await members.setDonation(
          memberId: id, year: 2026, month: 1, donated: true);
      expect(await members.watchTased(id).first, hasLength(1));

      await members.deleteMember(id);

      expect(await members.watchTased(id).first, isEmpty);
      expect(await members.watchDonations(id, 2026).first, isEmpty);
    });

    test('duplicate donation for the same member/year/month is rejected',
        () async {
      final id = await seedRealMember();
      await db.into(db.memberDonations).insert(MemberDonationsCompanion.insert(
          id: 'don_1', memberId: id, year: 2026, month: 3));
      await expectLater(
        db.into(db.memberDonations).insert(MemberDonationsCompanion.insert(
            id: 'don_2', memberId: id, year: 2026, month: 3)),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('image file cleanup', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase.memory());
    tearDown(() => db.close());

    File tempImage(String prefix) {
      final f = File(
          '${Directory.systemTemp.path}/${prefix}_${DateTime.now().microsecondsSinceEpoch}.jpg');
      f.writeAsBytesSync(const [1, 2, 3]);
      return f;
    }

    test('deleting a gallery photo removes its image file', () async {
      final gallery = GalleryRepository(db);
      final tmp = tempImage('gal');
      addTearDown(() => tmp.existsSync() ? tmp.deleteSync() : null);

      await gallery.add(title: 'Eid', year: 2026, imagePaths: [tmp.path]);
      final photo = (await gallery.getAll()).single;
      expect(tmp.existsSync(), isTrue);
      expect(GalleryRepository.imagesOf(photo), [tmp.path]);

      await gallery.delete(photo.id);
      expect(await gallery.count(), 0);
      expect(tmp.existsSync(), isFalse, reason: 'file cleaned up on delete');
    });

    test('deleting a member removes its photo file', () async {
      final tarbiya = TarbiyaRepository(db);
      final members = MemberRepository(db);
      await tarbiya.createArea(name: 'Area', nameAr: 'منطقة');
      final area = (await tarbiya.getAreas()).firstWhere((a) => a.name == 'Area');
      await tarbiya.createShuba(areaId: area.id, name: 'Shuba', nameAr: 'شعبة');
      final shuba = (await tarbiya.watchShubas(area.id).first).single;

      final tmp = tempImage('mem');
      addTearDown(() => tmp.existsSync() ? tmp.deleteSync() : null);

      final id = await members.insertMember(MembersCompanion(
        shubaId: Value(shuba.id),
        firstName: const Value('Test'),
        lastName: const Value('Member'),
        photoPath: Value(tmp.path),
      ));
      expect(tmp.existsSync(), isTrue);

      await members.deleteMember(id);
      expect(await members.getMember(id), isNull);
      expect(tmp.existsSync(), isFalse, reason: 'photo cleaned up on delete');
    });

    test('deleting a leader removes its photo file', () async {
      final leaders = LeaderRepository(db);
      final tmp = tempImage('leader');
      addTearDown(() => tmp.existsSync() ? tmp.deleteSync() : null);

      final leader = await leaders.create(
        name: 'Test Leader',
        nameAr: 'قائد',
        position: 'President',
        positionAr: 'الرئيس',
        category: LeadershipCategory.officePresident,
        photoPath: tmp.path,
      );
      expect(tmp.existsSync(), isTrue);

      await leaders.delete(leader.id);
      expect(await leaders.getById(leader.id), isNull);
      expect(tmp.existsSync(), isFalse, reason: 'photo cleaned up on delete');
    });
  });

  group('permissions matrix', () {
    test('account management is administrator-only', () {
      expect(UserRole.administrator.can.manageAccounts, isTrue);
      for (final r in [
        UserRole.president,
        UserRole.secretaryGeneral,
        UserRole.treasurer,
        UserRole.departmentHead,
      ]) {
        expect(r.can.manageAccounts, isFalse, reason: r.code);
      }
    });

    test('executives manage leadership; department head is view-only', () {
      expect(UserRole.president.can.manageLeadership, isTrue);
      expect(UserRole.departmentHead.can.manageLeadership, isFalse);
      expect(UserRole.departmentHead.can.viewLeadership, isTrue);
    });

    test('tarbiya is blocked for department heads only', () {
      expect(UserRole.treasurer.can.accessTarbiya, isTrue);
      expect(UserRole.departmentHead.can.accessTarbiya, isFalse);
    });

    test('members management is executives only', () {
      for (final r in [
        UserRole.administrator,
        UserRole.president,
        UserRole.secretaryGeneral,
        UserRole.treasurer,
      ]) {
        expect(r.can.manageMembers, isTrue, reason: r.code);
      }
      expect(UserRole.departmentHead.can.manageMembers, isFalse);
    });

    test('gallery upload is open to all roles; delete stays executive-only', () {
      for (final r in UserRole.values) {
        expect(r.can.uploadGallery, isTrue, reason: r.code);
      }
      // Deleting a photo still requires manageContent (executives).
      expect(UserRole.departmentHead.can.manageContent, isFalse);
      expect(UserRole.president.can.manageContent, isTrue);
    });

    test('department head manages only their own department reports', () {
      final dh = UserRole.departmentHead.can;
      expect(dh.manageReportForDepartment('media', 'media'), isTrue);
      expect(dh.manageReportForDepartment('media', 'finance'), isFalse);
      expect(UserRole.president.can.manageReportForDepartment('media', 'finance'),
          isTrue);
    });

    test('department head manages only their own department activities', () {
      final dh = UserRole.departmentHead.can;
      expect(dh.manageActivityForDepartment('media', 'media'), isTrue);
      expect(dh.manageActivityForDepartment('media', 'finance'), isFalse);
      // A department head with no assigned department manages none.
      expect(dh.manageActivityForDepartment(null, 'media'), isFalse);
      expect(
          UserRole.president.can.manageActivityForDepartment('media', 'finance'),
          isTrue);
    });
  });

  group('app smoke', () {
    void useTabletSurface(WidgetTester tester) {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('boots to login, signs in, reaches home, toggles AR',
        (tester) async {
      useTabletSurface(tester);
      final db = AppDatabase.memory();
      addTearDown(db.close);

      await tester.pumpWidget(MarkazApp(database: db));
      await tester.pumpAndSettle();

      // Login screen (credentials are pre-filled with the seeded admin).
      expect(find.text('Sign In'), findsOneWidget);
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Reached the app shell (left the login screen).
      expect(find.text('Sign In'), findsNothing);

      // Language toggle → Arabic home label in the sidebar, RTL.
      await tester.tap(find.text('ع'));
      await tester.pumpAndSettle();
      expect(find.text('الرئيسية'), findsWidgets);
    });

    testWidgets('leadership sidebar dropdown reveals the three pages',
        (tester) async {
      useTabletSurface(tester);
      final db = AppDatabase.memory();
      addTearDown(db.close);

      await tester.pumpWidget(MarkazApp(database: db));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Expand the Leadership group in the sidebar; it reveals three pages.
      // The Home page also surfaces a "Leadership" quick-access tile, so target
      // the sidebar occurrence (first in the widget tree).
      await tester.tap(find.text('Leadership').first);
      await tester.pumpAndSettle();
      expect(find.text('Office of the President'), findsWidgets);
      expect(find.text('Board of Trustees'), findsOneWidget);
      expect(find.text('Consultative Assembly'), findsOneWidget);
    });

    testWidgets('Tarbiyah department opens Tarbiya; area → shu\'ba; add works',
        (tester) async {
      useTabletSurface(tester);
      final db = AppDatabase.memory();
      // Closed explicitly at the end (then pumped) so drift's stream-close
      // timer is flushed before the framework checks for pending timers.

      await tester.pumpWidget(MarkazApp(database: db));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Tarbiya has no sidebar entry — reach it via the Departments section.
      await tester.tap(find.text('Departments'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tarbiyah'));
      await tester.pumpAndSettle();
      // Landed on the Tarbiya areas page (seeded default areas).
      expect(find.text('Area 1'), findsOneWidget);

      // Tapping an area navigates to its Shu'ba page.
      await tester.tap(find.text('Area 1'));
      await tester.pumpAndSettle();
      expect(find.text("Add Shu'ba"), findsOneWidget);

      // The Add button opens the dialog (regression: it used to do nothing).
      // Use bounded pumps, not pumpAndSettle — the dialog's autofocus field has
      // a blinking-cursor animation that never settles.
      await tester.tap(find.text("Add Shu'ba"));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Save'), findsOneWidget);

      // Fill the name field inside the dialog and save.
      await tester.enterText(
        find
            .descendant(
                of: find.byType(AlertDialog), matching: find.byType(TextField))
            .first,
        'Unit Alpha',
      );
      await tester.pump();
      await tester.tap(find.text('Save'));
      // Dialog closes (cursor gone) → safe to settle while createShuba + the
      // shu'ba stream emit.
      await tester.pumpAndSettle();

      // The new shu'ba appears in the list.
      expect(find.text('Unit Alpha'), findsOneWidget);

      await db.close();
      await tester.pump();
    });

    testWidgets('row three-dots menu opens (User Management)', (tester) async {
      // Regression: popup itemBuilders used context.tr (a listening lookup)
      // which threw at tap time, so the menu never opened.
      useTabletSurface(tester);
      final db = AppDatabase.memory();

      await tester.pumpWidget(MarkazApp(database: db));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('User Management'));
      await tester.pumpAndSettle();

      // Tap the seeded admin row's three-dots and confirm the menu opens.
      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();
      expect(find.text('Edit User'), findsOneWidget);
      expect(find.text('Delete User'), findsOneWidget);

      await db.close();
      await tester.pump();
    });

    testWidgets('login does not overflow when the keyboard shows',
        (tester) async {
      // The login Scaffold must not resize for the keyboard (that shifted /
      // squeezed the split-screen). Simulate a keyboard inset and assert the
      // landscape layout neither overflows nor loses the credential controls.
      useTabletSurface(tester);
      tester.view.viewInsets = const FakeViewPadding(bottom: 360);
      addTearDown(tester.view.resetViewInsets);

      final db = AppDatabase.memory();
      await tester.pumpWidget(MarkazApp(database: db));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);

      await db.close();
      await tester.pump();
    });

    testWidgets('keyboard does not move the sidebar or overflow content',
        (tester) async {
      // Regression: with the AppShell resizing for the keyboard, the sidebar
      // profile card slid up and empty pages overflowed. The shell must keep
      // full height when the keyboard shows.
      useTabletSurface(tester);
      final db = AppDatabase.memory();
      await tester.pumpWidget(MarkazApp(database: db));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Open User Management (empty → shows the EmptyState that overflowed).
      await tester.tap(find.text('User Management'));
      await tester.pumpAndSettle();

      // Simulate the keyboard appearing.
      tester.view.viewInsets = const FakeViewPadding(bottom: 360);
      addTearDown(tester.view.resetViewInsets);
      await tester.pump();

      expect(tester.takeException(), isNull, reason: 'no overflow');
      // Sidebar chrome is still present (not clipped/moved off-screen).
      expect(find.text('System Administrator'), findsOneWidget);

      await db.close();
      await tester.pump();
    });
  });
}
