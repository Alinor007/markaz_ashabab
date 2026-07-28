import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:markazosshabab/core/data/app_database.dart';
import 'package:markazosshabab/core/data/models.dart';
import 'package:markazosshabab/features/members/report/member_report_data.dart';
import 'package:markazosshabab/features/members/report/member_report_pdf.dart';

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
  String civilStatus = 'single',
  String contactNumber = '09171234567',
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
    civilStatus: civilStatus,
    spouseName: '',
    spouseDate: '',
    status: status,
    dateJoined: '',
    approval: 'approved',
    usraName: '',
    usraEstablishedYear: '',
    usraMeetingSchedule: '',
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('buildMemberReportData', () {
    final areas = [
      const TarbiyaArea(id: 'a1', name: 'Area One', region: '', accent: 0, sortOrder: 0),
      const TarbiyaArea(id: 'a2', name: 'Area Two', region: '', accent: 0, sortOrder: 1),
    ];
    final shubas = [
      const Shuba(id: 's1', areaId: 'a1', name: 'Shuba One', sortOrder: 0, masulMemberId: 'masul1'),
      const Shuba(id: 's2', areaId: 'a2', name: 'Shuba Two', sortOrder: 0),
    ];

    test('groups by area → shuba → level, sorts, and totals correctly',
        () {
      // First names deliberately rank opposite to last names, so this pins
      // the ordering to firstName rather than lastName.
      final m1 = _member(id: 'm1', shubaId: 's1', level: 2, firstName: 'Aisha', lastName: 'Bravo', gender: 'F', status: 'active');
      final m2 = _member(id: 'm2', shubaId: 's1', level: 2, firstName: 'Zaid', lastName: 'Alpha', gender: 'M', status: 'inactive');
      final m3 = _member(id: 'm3', shubaId: 's1', level: 0, lastName: 'Zulu', gender: 'M', status: 'active');
      final m4 = _member(id: 'm4', shubaId: 's2', level: 1, lastName: 'Delta', gender: 'F', status: 'active');
      // The Mas'ul of s1 is filtered out of the current roster (e.g. by a
      // gender filter) but must still be resolved by name in the report.
      final masul = _member(id: 'masul1', shubaId: 's2', lastName: 'Masul');

      final data = buildMemberReportData(
        filteredMembers: [m1, m2, m3, m4],
        areas: areas,
        shubas: shubas,
        allMembersById: {
          for (final m in [m1, m2, m3, m4, masul]) m.id: m,
        },
        filterSummary: 'Gender: Female',
        now: DateTime(2026, 7, 22),
      );

      expect(data.reportingPeriod, 'July 2026');
      expect(data.dateGenerated, 'July 22, 2026');
      expect(data.filterSummary, 'Gender: Female');
      expect(data.grandTotal, 4);

      expect(data.areas, hasLength(2));
      final areaOne = data.areas[0];
      expect(areaOne.name, 'Area One'); // sortOrder 0 first
      expect(areaOne.total, 3);
      expect(areaOne.shubas, hasLength(1));

      final shubaOne = areaOne.shubas.single;
      expect(shubaOne.name, 'Shuba One');
      expect(shubaOne.masulName, masul.fullName); // resolved despite being filtered out
      expect(shubaOne.total, 3);

      // Level 0 ("no level") is its own group rather than dropping the
      // member, ordered ascending alongside real levels.
      expect(shubaOne.levels, hasLength(2));
      expect(shubaOne.levels[0].label, 'No Level');
      expect(shubaOne.levels[0].rows.single.fullName, m3.fullName);
      expect(shubaOne.levels[1].label, 'Level 2');
      // Sorted A–Z by FIRST name within a level: Aisha before Zaid, even
      // though their last names (Bravo, Alpha) rank the other way.
      expect(shubaOne.levels[1].rows.map((r) => r.fullName),
          [m1.fullName, m2.fullName]);
      expect(shubaOne.levels[1].rows[0].index, 1);
      expect(shubaOne.levels[1].rows[1].index, 2);
      expect(shubaOne.levels[1].rows[0].gender, 'Female');
      expect(shubaOne.levels[1].rows[0].status, 'Active');
      expect(shubaOne.levels[1].rows[1].gender, 'Male');
      expect(shubaOne.levels[1].rows[1].status, 'Inactive');

      final areaTwo = data.areas[1];
      expect(areaTwo.name, 'Area Two');
      expect(areaTwo.shubas.single.masulName, 'Unassigned');
      expect(areaTwo.total, 1);
    });

    test('members sharing a first name are tie-broken on last name, '
        'case-insensitively', () {
      final a = _member(id: 'a', shubaId: 's1', firstName: 'omar', lastName: 'Zamora');
      final b = _member(id: 'b', shubaId: 's1', firstName: 'Omar', lastName: 'Ali');
      final c = _member(id: 'c', shubaId: 's1', firstName: 'Bilal', lastName: 'Yusuf');

      final data = buildMemberReportData(
        filteredMembers: [a, b, c],
        areas: areas,
        shubas: shubas,
        allMembersById: {for (final m in [a, b, c]) m.id: m},
        filterSummary: 'All members',
      );

      final rows = data.areas.single.shubas.single.levels.single.rows;
      // Bilal first; then the two Omars ordered by last name (Ali, Zamora)
      // regardless of the lowercase 'omar'.
      expect(rows.map((r) => r.fullName), [c.fullName, b.fullName, a.fullName]);
    });

    test('members whose Shu\'ba is missing land under a catch-all group '
        'instead of being dropped', () {
      final orphan = _member(id: 'm5', shubaId: 'ghost-shuba', lastName: 'Orphan');

      final data = buildMemberReportData(
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
    });

    test('filterSummary defaults are passed through as-is', () {
      final data = buildMemberReportData(
        filteredMembers: const [],
        areas: areas,
        shubas: shubas,
        allMembersById: const {},
        filterSummary: 'All members',
      );
      expect(data.areas, isEmpty);
      expect(data.grandTotal, 0);
      expect(data.filterSummary, 'All members');
    });
  });

  group('buildMemberReportPdf', () {
    test('produces non-empty bytes starting with the %PDF magic header',
        () async {
      final areas = [
        const TarbiyaArea(id: 'a1', name: 'Area One', region: '', accent: 0, sortOrder: 0),
      ];
      final shubas = [
        const Shuba(id: 's1', areaId: 'a1', name: 'Shuba One', sortOrder: 0),
      ];
      final m1 = _member(id: 'm1', shubaId: 's1', level: 1);

      final data = buildMemberReportData(
        filteredMembers: [m1],
        areas: areas,
        shubas: shubas,
        allMembersById: {m1.id: m1},
        // Exercises the real "·"-joined multi-filter summary text, not just
        // the "All members" default.
        filterSummary: "Area: Area One · Shu'ba: Shuba One · Level: 1",
        now: DateTime(2026, 7, 22),
      );

      final bytes = await buildMemberReportPdf(data, _tinyPng);

      expect(bytes, isNotEmpty);
      expect(bytes.sublist(0, 4), [0x25, 0x50, 0x44, 0x46]); // '%PDF'
    });
  });
}
