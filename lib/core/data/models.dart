import 'package:flutter/material.dart';

import '../auth/roles.dart';
import '../util/icon_catalog.dart';
import 'app_database.dart';

/// Generates a reasonably-unique id with a type prefix (no uuid dependency).
String newId(String prefix) =>
    '${prefix}_${DateTime.now().microsecondsSinceEpoch}';

/// Leadership groupings (the three Leadership sub-pages).
enum LeadershipCategory {
  officePresident('office_president', 'Office of the President'),
  board('board', 'Board of Trustees'),
  assembly('assembly', 'Consultative Assembly');

  const LeadershipCategory(this.code, this.en);
  final String code;
  final String en;

  static LeadershipCategory fromCode(String code) =>
      LeadershipCategory.values.firstWhere((c) => c.code == code,
          orElse: () => LeadershipCategory.officePresident);
}

/// Domain conveniences over the generated [User] row.
extension UserX on User {
  UserRole get role => UserRole.fromCode(roleCode);

  String displayName(bool isArabic) => fullName;

  String get avatarInitials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return username.substring(0, username.length >= 2 ? 2 : 1).toUpperCase();
    }
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

/// Civil status options for a member.
enum CivilStatus {
  single('single', 'Single'),
  married('married', 'Married'),
  widowed('widowed', 'Widowed'),
  divorced('divorced', 'Divorced');

  const CivilStatus(this.code, this.en);
  final String code;
  final String en;

  String label(bool isArabic) => en;

  static CivilStatus fromCode(String code) => CivilStatus.values
      .firstWhere((c) => c.code == code, orElse: () => CivilStatus.single);
}

/// Educational background stages. Which fields apply (Degree, and the
/// Program-like field's meaning) varies by stage — see [hasDegree],
/// [hasProgram], and [programLabel].
enum EducationStage {
  elementary('elementary', 'Elementary'),
  juniorHigh('junior_high', 'Junior High School'),
  seniorHigh('senior_high', 'Senior High School'),
  vocational('vocational', 'Vocational / TESDA'),
  college('college', 'College / Graduate School');

  const EducationStage(this.code, this.en);
  final String code;
  final String en;

  String label(bool isArabic) => en;

  /// Only College / Graduate School records a Degree (e.g. Bachelor of
  /// Science).
  bool get hasDegree => this == EducationStage.college;

  /// Senior High, Vocational, and College all record a second field, though
  /// its meaning differs — see [programLabel].
  bool get hasProgram =>
      this == EducationStage.seniorHigh ||
      this == EducationStage.vocational ||
      this == EducationStage.college;

  /// The label for the Program field, which changes meaning by stage
  /// (Strand/Track, Course/Certificate, or Program/Major).
  String programLabel(bool isArabic) {
    switch (this) {
      case EducationStage.seniorHigh:
        return 'Strand / Track';
      case EducationStage.vocational:
        return 'Course / Certificate';
      case EducationStage.college:
        return 'Program / Major';
      case EducationStage.elementary:
      case EducationStage.juniorHigh:
        return 'Program';
    }
  }

  static EducationStage fromCode(String code) => EducationStage.values
      .firstWhere((s) => s.code == code, orElse: () => EducationStage.college);
}

/// The five tarbiya levels.
const List<int> kTarbiyaLevels = [1, 2, 3, 4, 5];

/// Report document types.
enum ReportType {
  minutes('minutes', 'Minutes of Meeting'),
  resolution('resolution', 'Resolution'),
  other('other', 'Other Report'),
  programCompletion('program_completion', 'Program Completion (P-2)');

  const ReportType(this.code, this.en);
  final String code;
  final String en;

  String label(bool isArabic) => en;

  static ReportType fromCode(String code) => ReportType.values
      .firstWhere((t) => t.code == code, orElse: () => ReportType.minutes);
}

/// Status of a department activity.
enum ActivityStatus {
  planned('planned', 'Planned', Color(0xFFA8862F)),
  ongoing('ongoing', 'Ongoing', Color(0xFF16243D)),
  completed('completed', 'Completed', Color(0xFF0B5D3B));

  const ActivityStatus(this.code, this.en, this.color);
  final String code;
  final String en;
  final Color color;

  String label(bool isArabic) => en;

  static ActivityStatus fromCode(String code) => ActivityStatus.values
      .firstWhere((s) => s.code == code, orElse: () => ActivityStatus.planned);
}

/// Domain conveniences over the generated [Department] row.
extension DepartmentX on Department {
  IconData get icon => iconForKey(iconKey);
  Color get accentColor => Color(accent);
  String displayName(bool isArabic) => name;
}

/// Domain conveniences over the generated [Report] row.
extension ReportX on Report {
  ReportType get typeEnum => ReportType.fromCode(type);
}

/// Domain conveniences over the generated [DeptActivity] row.
extension DeptActivityX on DeptActivity {
  ActivityStatus get statusEnum => ActivityStatus.fromCode(status);
}

/// Domain conveniences over the generated [GalleryPhoto] row.
extension GalleryPhotoX on GalleryPhoto {
  IconData get icon => iconForKey(iconKey);
  Color get accentColor => Color(accent);
}

/// Domain conveniences over the generated [Member] row.
extension MemberX on Member {
  String get fullName => [firstName, middleName, lastName, suffix]
      .where((s) => s.trim().isNotEmpty)
      .join(' ');

  String displayName(bool isArabic) => fullName;

  bool get isActive => status == 'active';

  /// The member's tarbiya level for display; "—" when 0 (no Tas'ed record).
  /// Level is driven by the member's Tas'ed records, not set manually.
  String levelLabel(bool isArabic) => level <= 0 ? '—' : 'Level $level';

  CivilStatus get civilStatusEnum => CivilStatus.fromCode(civilStatus);

  String get initials {
    final f = firstName.trim();
    final l = lastName.trim();
    if (f.isEmpty && l.isEmpty) return '?';
    if (l.isEmpty) return f.substring(0, f.length >= 2 ? 2 : 1).toUpperCase();
    return '${f.isNotEmpty ? f[0] : ''}${l[0]}'.toUpperCase();
  }
}

/// Domain conveniences over the generated [Leader] row.
extension LeaderX on Leader {
  LeadershipCategory get categoryEnum => LeadershipCategory.fromCode(category);

  Color get accentColor => Color(accent);

  List<String> _lines(String raw) => raw
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();

  List<String> get achievementsList => _lines(achievements);
  List<String> get achievementsArList => _lines(achievementsAr);
  List<String> get responsibilitiesList => _lines(responsibilities);
  List<String> get responsibilitiesArList => _lines(responsibilitiesAr);

  String get initials {
    final parts = name.replaceAll('.', '').trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
