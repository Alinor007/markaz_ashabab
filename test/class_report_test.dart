import 'dart:convert';
import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:markazosshabab/core/data/app_database.dart';
import 'package:markazosshabab/core/data/models.dart';
import 'package:markazosshabab/features/members/report/class_report_data.dart';
import 'package:markazosshabab/features/members/report/class_report_pdf.dart';

/// A well-known minimal valid 1x1 PNG, used as a stand-in logo so
/// `pw.MemoryImage` has real image bytes to decode.
final _tinyPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk'
  '+A8AAQUBAScY42YAAAAASUVORK5CYII=',
);

Member _member({
  required String id,
  required String shubaId,
  int level = 1,
  String firstName = 'First',
  String lastName = 'Last',
  String gender = 'M',
  String status = 'active',
  String contactNumber = '09171234567',
  String? naqibMemberId,
  String usraName = '',
  String usraEstablishedYear = '',
  String usraMeetingSchedule = '',
}) {
  return Member(
    id: id,
    shubaId: shubaId,
    level: level,
    firstName: firstName,
    middleName: '',
    lastName: lastName,
    suffix: '',
    gender: gender,
    dob: '',
    placeOfBirth: '',
    contactNumber: contactNumber,
    email: '',
    address: '',
    ethnicity: '',
    occupation: '',
    photoPath: '',
    civilStatus: 'single',
    spouseName: '',
    spouseDate: '',
    status: status,
    dateJoined: '',
    approval: 'approved',
    usraName: usraName,
    usraEstablishedYear: usraEstablishedYear,
    usraMeetingSchedule: usraMeetingSchedule,
    naqibMemberId: naqibMemberId,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('buildClassReportData', () {
    final areas = [
      const TarbiyaArea(id: 'a1', name: 'Area One', region: '', accent: 0, sortOrder: 0),
    ];
    final shubas = [
      const Shuba(id: 's1', areaId: 'a1', name: 'Shuba One', sortOrder: 0, masulMemberId: 'teacher1'),
    ];

    test(
        'groups students into sections by (naqib, usraName), sorts students '
        'A-Z by first name, and a self-taught Naqib counts as with-class '
        'without appearing in any table', () {
      final teacher = _member(
        id: 'teacher1',
        shubaId: 's1',
        firstName: 'Ahmad',
        lastName: 'Naqib',
        // No naqib of their own.
      );
      final studentB = _member(
        id: 's_b',
        shubaId: 's1',
        firstName: 'Bilal',
        lastName: 'X',
        naqibMemberId: 'teacher1',
        usraName: 'Section A',
        usraEstablishedYear: '2025',
        usraMeetingSchedule: 'Mon/Wed 4pm',
      );
      final studentA = _member(
        id: 's_a',
        shubaId: 's1',
        firstName: 'Amir',
        lastName: 'Y',
        naqibMemberId: 'teacher1',
        usraName: 'Section A',
        usraEstablishedYear: '2025',
        usraMeetingSchedule: 'Mon/Wed 4pm',
      );
      final unclassed = _member(id: 'no_class', shubaId: 's1', firstName: 'Zara', lastName: 'Z');

      final members = [teacher, studentB, studentA, unclassed];
      final data = buildClassReportData(
        filteredMembers: members,
        areas: areas,
        shubas: shubas,
        allMembersById: {for (final m in members) m.id: m},
        filterSummary: 'All members',
        now: DateTime(2026, 7, 22),
      );

      expect(data.reportingPeriod, 'July 2026');
      expect(data.dateGenerated, 'July 22, 2026');

      final level = data.areas.single.shubas.single.levels.single;
      expect(level.label, 'Level 1');
      // 4 members total: 2 students + 1 self-taught teacher (with-class,
      // invisible) + 1 truly unclassed member.
      expect(level.total, 4);
      expect(level.withClass, 3);
      expect(level.withoutClass, 1);

      expect(level.sections, hasLength(1));
      final section = level.sections.single;
      expect(section.sectionName, 'Section A');
      expect(section.teacherName, teacher.fullName);
      expect(section.schoolYear, '2025');
      expect(section.schedule, 'Mon/Wed 4pm');
      // A-Z by first name: Amir before Bilal, regardless of insertion order.
      expect(section.students.map((r) => r.fullName), [studentA.fullName, studentB.fullName]);
      expect(section.total, 2);

      // The self-taught Naqib is with-class but appears in neither the
      // section's roster nor the "No Class / No Teacher" bucket.
      expect(section.students.any((r) => r.fullName == teacher.fullName), isFalse);
      expect(level.noClass.any((r) => r.fullName == teacher.fullName), isFalse);

      // Only the truly unclassed member lands in "No Class / No Teacher".
      expect(level.noClass, hasLength(1));
      expect(level.noClass.single.fullName, unclassed.fullName);

      // Roll-ups match.
      final shuba = data.areas.single.shubas.single;
      expect(shuba.masulName, teacher.fullName);
      expect(shuba.total, 4);
      expect(shuba.withClass, 3);
      expect(shuba.withoutClass, 1);
      expect(data.areas.single.total, 4);
      expect(data.grandTotal, 4);
      expect(data.grandWithClass, 3);
      expect(data.grandWithoutClass, 1);
    });

    test('level 0 (no Tas\'ed record) becomes its own "No Level" group', () {
      final m = _member(id: 'm1', shubaId: 's1', level: 0, firstName: 'Noor');

      final data = buildClassReportData(
        filteredMembers: [m],
        areas: areas,
        shubas: shubas,
        allMembersById: {m.id: m},
        filterSummary: 'All members',
      );

      final level = data.areas.single.shubas.single.levels.single;
      expect(level.label, 'No Level');
      expect(level.total, 1);
      expect(level.withoutClass, 1);
      expect(level.noClass.single.fullName, m.fullName);
    });

    test('members whose Shu\'ba is missing land under a catch-all group '
        'instead of being dropped', () {
      final orphan = _member(id: 'm1', shubaId: 'ghost-shuba', firstName: 'Orphan');

      final data = buildClassReportData(
        filteredMembers: [orphan],
        areas: areas,
        shubas: shubas,
        allMembersById: {orphan.id: orphan},
        filterSummary: 'All members',
      );

      expect(data.grandTotal, 1);
      final unassigned = data.areas.singleWhere((a) => a.name == 'Unassigned Area');
      expect(unassigned.shubas.single.name, "Unassigned Shu'ba");
      expect(unassigned.total, 1);
      expect(unassigned.withoutClass, 1);
    });
  });

  group('buildClassReportPdf', () {
    test('produces non-empty bytes starting with the %PDF magic header, '
        'and survives an Isolate.run hop', () async {
      final areas = [
        const TarbiyaArea(id: 'a1', name: 'Area One', region: '', accent: 0, sortOrder: 0),
      ];
      final shubas = [
        const Shuba(id: 's1', areaId: 'a1', name: 'Shuba One', sortOrder: 0),
      ];
      final teacher = _member(id: 't1', shubaId: 's1', firstName: 'Ahmad');
      final student = _member(
        id: 'st1',
        shubaId: 's1',
        firstName: 'Bilal',
        naqibMemberId: 't1',
        usraName: 'Section A',
      );
      final unclassed = _member(id: 'nc1', shubaId: 's1', firstName: 'Zara');
      final members = [teacher, student, unclassed];

      final data = buildClassReportData(
        filteredMembers: members,
        areas: areas,
        shubas: shubas,
        allMembersById: {for (final m in members) m.id: m},
        filterSummary: "Area: Area One · Shu'ba: Shuba One",
        now: DateTime(2026, 7, 22),
      );

      final bytes = await Isolate.run(() => buildClassReportPdf(data, _tinyPng));

      expect(bytes, isNotEmpty);
      expect(bytes.sublist(0, 4), [0x25, 0x50, 0x44, 0x46]); // '%PDF'
    });
  });
}
