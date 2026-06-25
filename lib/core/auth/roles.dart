import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Roles recognized by the archive system.
///
/// [code] is the stable identifier persisted in the database (do not rename).
/// Labels are bilingual so they render under either language.
enum UserRole {
  administrator('administrator', 'Administrator', 'مدير النظام', AppColors.emerald),
  president('president', 'President', 'الرئيس', AppColors.navy),
  secretaryGeneral(
      'secretary_general', 'Secretary General', 'الأمين العام', AppColors.goldDeep),
  treasurer('treasurer', 'Treasurer', 'أمين الصندوق', AppColors.emeraldDark),
  departmentHead(
      'department_head', 'Department Head', 'رئيس قسم', AppColors.info);

  const UserRole(this.code, this.labelEn, this.labelAr, this.color);

  final String code;
  final String labelEn;
  final String labelAr;
  final Color color;

  String label(bool isArabic) => isArabic ? labelAr : labelEn;

  bool get isAdmin => this == UserRole.administrator;

  /// Executive leadership (full CRUD across modules, but not account mgmt).
  bool get isExecutive =>
      this == administrator ||
      this == president ||
      this == secretaryGeneral ||
      this == treasurer;

  /// Capabilities for this role.
  Permissions get can => Permissions(this);

  static UserRole fromCode(String code) {
    return UserRole.values.firstWhere(
      (r) => r.code == code,
      orElse: () => UserRole.departmentHead,
    );
  }
}

/// Role-based access control policy — the single source of truth for the
/// permission matrix. UI gating and route guards both read from here.
class Permissions {
  const Permissions(this.role);
  final UserRole role;

  // Account & system administration — Administrator only.
  bool get manageAccounts => role == UserRole.administrator;
  bool get systemSettings => role == UserRole.administrator;
  bool get viewAuditLogs => role == UserRole.administrator;

  // Leadership — executives manage, department heads view only.
  bool get viewLeadership => true;
  bool get manageLeadership => role.isExecutive;

  // Tarbiya — executives only; department heads have no access at all.
  bool get accessTarbiya => role != UserRole.departmentHead;
  bool get manageTarbiya => role.isExecutive;

  // Members directory management (view + full CRUD) — executives only
  // (Administrator, President, Secretary General, Treasurer).
  bool get manageMembers => role.isExecutive;

  // Reports — everyone can view all reports; executives manage all,
  // department heads manage only their own department's reports.
  bool get viewAllReports => true;
  bool get manageAllReports => role.isExecutive;

  /// Whether [role] (belonging to a user in [userDepartmentId]) may create or
  /// edit a report owned by [reportDepartmentId].
  bool manageReportForDepartment(
      String? userDepartmentId, String? reportDepartmentId) {
    if (role.isExecutive) return true;
    if (role == UserRole.departmentHead) {
      return userDepartmentId != null &&
          userDepartmentId == reportDepartmentId;
    }
    return false;
  }

  // Other content modules (departments, gallery, history) — executives manage,
  // department heads read-only.
  bool get manageContent => role.isExecutive;

  // Gallery uploads are open to every signed-in role (deleting a photo still
  // requires [manageContent]).
  bool get uploadGallery => true;
}
