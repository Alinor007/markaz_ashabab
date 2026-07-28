import '../../../core/data/app_database.dart';
import '../../../core/data/models.dart';

/// One student row inside a class section's (or a level's "No Class / No
/// Teacher" bucket's) table.
class ClassStudentRow {
  const ClassStudentRow({
    required this.index,
    required this.fullName,
    required this.gender,
    required this.contactNumber,
    required this.status,
  });

  /// 1-based position within its table.
  final int index;
  final String fullName;
  final String gender;
  final String contactNumber;
  final String status;
}

/// One tutorial class: a Naqib (teacher) + section, and its students.
/// Mirrors `TarbiyaRepository.watchClasses`'s grouping key — same
/// (naqibMemberId, trimmed usraName) pair.
class ClassSection {
  const ClassSection({
    required this.sectionName,
    required this.teacherName,
    required this.schoolYear,
    required this.schedule,
    required this.students,
  });

  final String sectionName;
  final String teacherName;
  final String schoolYear;
  final String schedule;
  final List<ClassStudentRow> students;

  int get total => students.length;
}

/// All classes (and the unclassed remainder) of one tarbiya level within a
/// Shu'ba. [total]/[withClass]/[withoutClass] are stored explicitly rather
/// than derived from [sections]/[noClass] alone: a member who teaches a
/// class but has no Naqib of their own counts as "with class" even though
/// they don't appear as a student row anywhere (they're the teacher, not a
/// student) — so summing visible rows would under-count them.
class ClassLevelGroup {
  const ClassLevelGroup({
    required this.label,
    required this.sections,
    required this.noClass,
    required this.total,
    required this.withClass,
    required this.withoutClass,
  });

  final String label;
  final List<ClassSection> sections;

  /// Members with neither an assigned Naqib nor a class of their own to
  /// teach — the "No Class / No Teacher" bucket.
  final List<ClassStudentRow> noClass;

  final int total;
  final int withClass;
  final int withoutClass;
}

/// One Shu'ba's levels, plus its Mas'ul.
class ClassShubaGroup {
  const ClassShubaGroup({
    required this.name,
    required this.masulName,
    required this.levels,
  });

  final String name;
  final String masulName;
  final List<ClassLevelGroup> levels;

  int get total => levels.fold(0, (sum, l) => sum + l.total);
  int get withClass => levels.fold(0, (sum, l) => sum + l.withClass);
  int get withoutClass => levels.fold(0, (sum, l) => sum + l.withoutClass);
}

/// One Area's Shu'bas.
class ClassAreaGroup {
  const ClassAreaGroup({required this.name, required this.shubas});

  final String name;
  final List<ClassShubaGroup> shubas;

  int get total => shubas.fold(0, (sum, s) => sum + s.total);
  int get withClass => shubas.fold(0, (sum, s) => sum + s.withClass);
  int get withoutClass => shubas.fold(0, (sum, s) => sum + s.withoutClass);
}

/// Everything the Class Tutorial Report PDF builder needs — plain data, safe
/// to hand to an isolate.
class ClassReportData {
  const ClassReportData({
    required this.areas,
    required this.reportingPeriod,
    required this.dateGenerated,
    required this.filterSummary,
  });

  final List<ClassAreaGroup> areas;
  final String reportingPeriod;
  final String dateGenerated;
  final String filterSummary;

  int get grandTotal => areas.fold(0, (sum, a) => sum + a.total);
  int get grandWithClass => areas.fold(0, (sum, a) => sum + a.withClass);
  int get grandWithoutClass => areas.fold(0, (sum, a) => sum + a.withoutClass);
}

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

String _genderLabel(String gender) => gender == 'F' ? 'Female' : 'Male';

int _compareNames(Member a, Member b) {
  final byFirst = a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
  return byFirst != 0
      ? byFirst
      : a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
}

List<ClassStudentRow> _rowsFor(List<Member> members) {
  final sorted = [...members]..sort(_compareNames);
  return [
    for (var i = 0; i < sorted.length; i++)
      ClassStudentRow(
        index: i + 1,
        fullName: sorted[i].fullName,
        gender: _genderLabel(sorted[i].gender),
        contactNumber: sorted[i].contactNumber,
        status: sorted[i].isActive ? 'Active' : 'Inactive',
      ),
  ];
}

/// Groups the screen's already-filtered member list into
/// Area → Shu'ba (+ Mas'ul) → Level → Class Section (+ "No Class / No
/// Teacher"), matching the on-screen ordering (areas by `sortOrder`, shu'bas
/// by `name`, levels ascending, sections by teacher then section name,
/// students A–Z by first name).
///
/// A member counts as **with class** if they have an assigned Naqib (they're
/// a student) or if their id appears as *someone else's* Naqib within the
/// filtered roster (they teach a class) — a teacher is with-class even when
/// they have no Naqib of their own, so they never land in "No Class / No
/// Teacher". Everyone else is **without class**.
///
/// [allMembersById] should be keyed from the *unfiltered* approved member
/// list so a Shu'ba's Mas'ul and a class's teacher name resolve correctly
/// even when the current filters would otherwise exclude them from the
/// roster.
ClassReportData buildClassReportData({
  required List<Member> filteredMembers,
  required List<TarbiyaArea> areas,
  required List<Shuba> shubas,
  required Map<String, Member> allMembersById,
  required String filterSummary,
  DateTime? now,
}) {
  final shubaById = {for (final s in shubas) s.id: s};

  final teacherIds = {
    for (final m in filteredMembers)
      if (m.naqibMemberId != null) m.naqibMemberId!,
  };

  final byShuba = <String, List<Member>>{};
  for (final m in filteredMembers) {
    (byShuba[m.shubaId] ??= []).add(m);
  }

  final byArea = <String, List<ClassShubaGroup>>{};
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
        _buildLevelGroup(
          label: level <= 0 ? 'No Level' : 'Level $level',
          members: byLevel[level]!,
          teacherIds: teacherIds,
          allMembersById: allMembersById,
        ),
    ];

    final masulId = shuba?.masulMemberId;
    final masulName =
        masulId == null ? 'Unassigned' : allMembersById[masulId]?.fullName ?? 'Unassigned';

    (byArea[areaId] ??= []).add(
      ClassShubaGroup(name: shubaName, masulName: masulName, levels: levelGroups),
    );
  }

  final areaGroups = <ClassAreaGroup>[];
  final orderedAreas = [...areas]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  final handledAreaIds = <String>{};
  for (final area in orderedAreas) {
    final shubaGroups = byArea[area.id];
    if (shubaGroups == null || shubaGroups.isEmpty) continue;
    handledAreaIds.add(area.id);
    shubaGroups.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    areaGroups.add(ClassAreaGroup(name: area.name, shubas: shubaGroups));
  }
  // Members whose Shu'ba is missing, or whose Shu'ba points at an area id
  // that no longer resolves — surface them under a catch-all group rather
  // than silently dropping them (same rule as the Members Report).
  final orphanShubas = [
    for (final entry in byArea.entries)
      if (!handledAreaIds.contains(entry.key)) ...entry.value,
  ];
  if (orphanShubas.isNotEmpty) {
    orphanShubas.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    areaGroups.add(ClassAreaGroup(name: 'Unassigned Area', shubas: orphanShubas));
  }

  final effectiveNow = now ?? DateTime.now();
  final month = _monthNames[effectiveNow.month - 1];
  return ClassReportData(
    areas: areaGroups,
    reportingPeriod: '$month ${effectiveNow.year}',
    dateGenerated: '$month ${effectiveNow.day}, ${effectiveNow.year}',
    filterSummary: filterSummary,
  );
}

ClassLevelGroup _buildLevelGroup({
  required String label,
  required List<Member> members,
  required Set<String> teacherIds,
  required Map<String, Member> allMembersById,
}) {
  final withNaqib = <Member>[];
  // With-class (they teach a visible class) but invisible in every table —
  // they're a teacher, not a student, and not "no class" either.
  var teacherOnlyCount = 0;
  final noClass = <Member>[];
  for (final m in members) {
    if (m.naqibMemberId != null) {
      withNaqib.add(m);
    } else if (teacherIds.contains(m.id)) {
      teacherOnlyCount++;
    } else {
      noClass.add(m);
    }
  }

  final bySection = <String, List<Member>>{};
  for (final m in withNaqib) {
    final key = '${m.naqibMemberId}|${m.usraName.trim()}';
    (bySection[key] ??= []).add(m);
  }

  final sections = <ClassSection>[];
  for (final studentsForSection in bySection.values) {
    final first = studentsForSection.first;
    final teacherName = allMembersById[first.naqibMemberId]?.fullName ?? 'Unknown';
    final sectionName = first.usraName.trim();
    sections.add(ClassSection(
      sectionName: sectionName.isEmpty ? '(No Section Name)' : sectionName,
      teacherName: teacherName,
      schoolYear: first.usraEstablishedYear,
      schedule: first.usraMeetingSchedule,
      students: _rowsFor(studentsForSection),
    ));
  }
  sections.sort((a, b) {
    final byTeacher = a.teacherName.toLowerCase().compareTo(b.teacherName.toLowerCase());
    return byTeacher != 0
        ? byTeacher
        : a.sectionName.toLowerCase().compareTo(b.sectionName.toLowerCase());
  });

  return ClassLevelGroup(
    label: label,
    sections: sections,
    noClass: _rowsFor(noClass),
    total: members.length,
    withClass: withNaqib.length + teacherOnlyCount,
    withoutClass: noClass.length,
  );
}
