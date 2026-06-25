import 'package:flutter/material.dart';

import '../auth/roles.dart';
import '../util/icon_catalog.dart';
import 'app_database.dart';

/// Generates a reasonably-unique id with a type prefix (no uuid dependency).
String newId(String prefix) =>
    '${prefix}_${DateTime.now().microsecondsSinceEpoch}';

/// Leadership groupings (the three Leadership sub-pages).
enum LeadershipCategory {
  officePresident('office_president', 'Office of the President', 'مكتب الرئيس'),
  board('board', 'Board of Trustees', 'مجلس الأمناء'),
  assembly('assembly', 'Consultative Assembly', 'مجلس الشورى');

  const LeadershipCategory(this.code, this.en, this.ar);
  final String code;
  final String en;
  final String ar;

  static LeadershipCategory fromCode(String code) =>
      LeadershipCategory.values.firstWhere((c) => c.code == code,
          orElse: () => LeadershipCategory.officePresident);
}

/// Domain conveniences over the generated [User] row.
extension UserX on User {
  UserRole get role => UserRole.fromCode(roleCode);

  String displayName(bool isArabic) => isArabic ? fullNameAr : fullName;

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
  single('single', 'Single', 'أعزب'),
  married('married', 'Married', 'متزوج'),
  widowed('widowed', 'Widowed', 'أرمل'),
  divorced('divorced', 'Divorced', 'مطلّق');

  const CivilStatus(this.code, this.en, this.ar);
  final String code;
  final String en;
  final String ar;

  String label(bool isArabic) => isArabic ? ar : en;

  static CivilStatus fromCode(String code) => CivilStatus.values
      .firstWhere((c) => c.code == code, orElse: () => CivilStatus.single);
}

/// Educational background stages.
enum EducationStage {
  elementary('elementary', 'Elementary', 'الابتدائية'),
  highschool('highschool', 'High School', 'الثانوية'),
  college('college', 'College', 'الجامعة'),
  postgraduate('postgraduate', 'Post Graduate', 'الدراسات العليا');

  const EducationStage(this.code, this.en, this.ar);
  final String code;
  final String en;
  final String ar;

  String label(bool isArabic) => isArabic ? ar : en;

  static EducationStage fromCode(String code) => EducationStage.values
      .firstWhere((s) => s.code == code, orElse: () => EducationStage.college);
}

/// The five tarbiya levels.
const List<int> kTarbiyaLevels = [1, 2, 3, 4, 5];

/// Report document types.
enum ReportType {
  minutes('minutes', 'Minutes of Meeting', 'محضر اجتماع'),
  resolution('resolution', 'Resolution', 'قرار');

  const ReportType(this.code, this.en, this.ar);
  final String code;
  final String en;
  final String ar;

  String label(bool isArabic) => isArabic ? ar : en;

  static ReportType fromCode(String code) => ReportType.values
      .firstWhere((t) => t.code == code, orElse: () => ReportType.minutes);
}

/// Status of a department activity.
enum ActivityStatus {
  planned('planned', 'Planned', 'مخطط', Color(0xFFA8862F)),
  ongoing('ongoing', 'Ongoing', 'جارٍ', Color(0xFF16243D)),
  completed('completed', 'Completed', 'مكتمل', Color(0xFF0B5D3B));

  const ActivityStatus(this.code, this.en, this.ar, this.color);
  final String code;
  final String en;
  final String ar;
  final Color color;

  String label(bool isArabic) => isArabic ? ar : en;

  static ActivityStatus fromCode(String code) => ActivityStatus.values
      .firstWhere((s) => s.code == code, orElse: () => ActivityStatus.planned);
}

/// Domain conveniences over the generated [Department] row.
extension DepartmentX on Department {
  IconData get icon => iconForKey(iconKey);
  Color get accentColor => Color(accent);
  String displayName(bool isArabic) =>
      isArabic && nameAr.trim().isNotEmpty ? nameAr : name;
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

  String displayName(bool isArabic) =>
      isArabic && nameAr.trim().isNotEmpty ? nameAr : fullName;

  bool get isActive => status == 'active';

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
