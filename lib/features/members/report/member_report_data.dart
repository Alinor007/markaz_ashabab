import '../../../core/data/app_database.dart';
import '../../../core/data/models.dart';

/// One member row inside a level's table.
class MemberReportRow {
  const MemberReportRow({
    required this.index,
    required this.fullName,
    required this.gender,
    required this.civilStatus,
    required this.contactNumber,
    required this.status,
  });

  /// 1-based position within its level table.
  final int index;
  final String fullName;
  final String gender;
  final String civilStatus;
  final String contactNumber;
  final String status;
}

/// All members of one tarbiya level within a Shu'ba.
class LevelGroup {
  const LevelGroup({required this.label, required this.rows});

  final String label;
  final List<MemberReportRow> rows;

  int get total => rows.length;
}

/// One Shu'ba's levels, plus its Mas'ul.
class ShubaGroup {
  const ShubaGroup({
    required this.name,
    required this.masulName,
    required this.levels,
  });

  final String name;
  final String masulName;
  final List<LevelGroup> levels;

  int get total => levels.fold(0, (sum, l) => sum + l.total);
}

/// One Area's Shu'bas.
class AreaGroup {
  const AreaGroup({required this.name, required this.shubas});

  final String name;
  final List<ShubaGroup> shubas;

  int get total => shubas.fold(0, (sum, s) => sum + s.total);
}

/// Everything the PDF builder needs — plain data, safe to hand to an isolate.
class MemberReportData {
  const MemberReportData({
    required this.areas,
    required this.reportingPeriod,
    required this.dateGenerated,
    required this.filterSummary,
  });

  final List<AreaGroup> areas;

  /// e.g. "July 2026".
  final String reportingPeriod;

  /// e.g. "July 22, 2026".
  final String dateGenerated;

  /// Human-readable summary of the filters that were active when the report
  /// was generated (e.g. "Area: Area 1 · Level 2"), or "All members" when none
  /// were applied.
  final String filterSummary;

  int get grandTotal => areas.fold(0, (sum, a) => sum + a.total);
}

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

String _genderLabel(String gender) => gender == 'F' ? 'Female' : 'Male';

/// Groups the screen's already-filtered member list into
/// Area → Shu'ba (+ Mas'ul) → Level, matching the on-screen ordering
/// (areas by `sortOrder`, shu'bas by `name`, levels ascending).
///
/// [allMembersById] should be keyed from the *unfiltered* approved member
/// list so a Shu'ba's Mas'ul is resolved correctly even when the current
/// gender/status/etc. filters would otherwise exclude them from the roster.
MemberReportData buildMemberReportData({
  required List<Member> filteredMembers,
  required List<TarbiyaArea> areas,
  required List<Shuba> shubas,
  required Map<String, Member> allMembersById,
  required String filterSummary,
  DateTime? now,
}) {
  final shubaById = {for (final s in shubas) s.id: s};

  final byShuba = <String, List<Member>>{};
  for (final m in filteredMembers) {
    (byShuba[m.shubaId] ??= []).add(m);
  }

  final byArea = <String, List<ShubaGroup>>{};
  for (final entry in byShuba.entries) {
    final shuba = shubaById[entry.key];
    final shubaName = shuba?.name ?? 'Unassigned Shu\'ba';
    final areaId = shuba?.areaId ?? '';

    final byLevel = <int, List<Member>>{};
    for (final m in entry.value) {
      (byLevel[m.level] ??= []).add(m);
    }
    final levels = byLevel.keys.toList()..sort();
    final levelGroups = [
      for (final level in levels)
        LevelGroup(
          // Plain hyphen, not an em-dash: the PDF's built-in Helvetica font
          // (see member_report_pdf.dart) has no glyph for U+2014.
          label: level <= 0 ? 'No Level' : 'Level $level',
          rows: () {
            // Alphabetical A–Z by first name, tie-broken on last name so
            // members sharing a first name still land in a stable order.
            final members = byLevel[level]!
              ..sort((a, b) {
                final byFirst = a.firstName
                    .toLowerCase()
                    .compareTo(b.firstName.toLowerCase());
                return byFirst != 0
                    ? byFirst
                    : a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
              });
            return [
              for (var i = 0; i < members.length; i++)
                MemberReportRow(
                  index: i + 1,
                  fullName: members[i].fullName,
                  gender: _genderLabel(members[i].gender),
                  civilStatus: members[i].civilStatusEnum.label(),
                  contactNumber: members[i].contactNumber,
                  status: members[i].isActive ? 'Active' : 'Inactive',
                ),
            ];
          }(),
        ),
    ];

    final masulId = shuba?.masulMemberId;
    final masulName =
        masulId == null ? 'Unassigned' : allMembersById[masulId]?.fullName ?? 'Unassigned';

    (byArea[areaId] ??= []).add(
      ShubaGroup(name: shubaName, masulName: masulName, levels: levelGroups),
    );
  }

  final areaGroups = <AreaGroup>[];
  final orderedAreas = [...areas]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  final handledAreaIds = <String>{};
  for (final area in orderedAreas) {
    final shubaGroups = byArea[area.id];
    if (shubaGroups == null || shubaGroups.isEmpty) continue;
    handledAreaIds.add(area.id);
    shubaGroups.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    areaGroups.add(AreaGroup(name: area.name, shubas: shubaGroups));
  }
  // Members whose Shu'ba is missing, or whose Shu'ba points at an area id that
  // no longer resolves (data integrity edge case) — surface them under a
  // catch-all group rather than silently dropping them from the report.
  final orphanShubas = [
    for (final entry in byArea.entries)
      if (!handledAreaIds.contains(entry.key)) ...entry.value,
  ];
  if (orphanShubas.isNotEmpty) {
    orphanShubas.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    areaGroups.add(AreaGroup(name: 'Unassigned Area', shubas: orphanShubas));
  }

  final effectiveNow = now ?? DateTime.now();
  final month = _monthNames[effectiveNow.month - 1];
  return MemberReportData(
    areas: areaGroups,
    reportingPeriod: '$month ${effectiveNow.year}',
    dateGenerated: '$month ${effectiveNow.day}, ${effectiveNow.year}',
    filterSummary: filterSummary,
  );
}
