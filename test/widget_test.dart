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
      expect(users, hasLength(1));
      expect(users.single.username, 'admin');
      expect(users.single.role, UserRole.administrator);
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
      expect(users, hasLength(2));
    });

    test('leadership CRUD by category', () async {
      final repo = LeaderRepository(db);
      await repo.create(
        name: 'Dr. Abdullah Macarambon',
        nameAr: 'عبد الله',
        position: 'President',
        positionAr: 'الرئيس',
        category: LeadershipCategory.officePresident,
      );
      final office =
          await repo.watchByCategory(LeadershipCategory.officePresident).first;
      final board =
          await repo.watchByCategory(LeadershipCategory.board).first;
      expect(office, hasLength(1));
      expect(board, isEmpty);
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
  });

  group('departments & reports data layer', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase.memory());
    tearDown(() => db.close());

    test('seeds the eight standing departments', () async {
      final depts = await DepartmentRepository(db).getAll();
      expect(depts, hasLength(8));
      expect(depts.map((d) => d.name), contains('Tarbiyah'));
      expect(depts.map((d) => d.name), contains('Economy and Investments'));
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

    test('gallery add/delete', () async {
      final repo = GalleryRepository(db);
      await repo.add(title: 'Eid Gathering', year: 2026, event: 'Community');
      final photos = await repo.getAll();
      expect(photos, hasLength(1));
      await repo.delete(photos.single.id);
      expect(await repo.count(), 0);
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

      await gallery.add(title: 'Eid', year: 2026, imagePath: tmp.path);
      final photo = (await gallery.getAll()).single;
      expect(tmp.existsSync(), isTrue);

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

      // Home.
      expect(find.textContaining('Welcome back'), findsOneWidget);

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
  });
}
