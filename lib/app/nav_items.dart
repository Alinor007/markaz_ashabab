import 'package:flutter/material.dart';

import '../core/i18n/strings.dart';

/// A single sidebar navigation destination.
class NavItem {
  const NavItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.labelBuilder,
    this.adminOnly = false,
    this.requiresTarbiya = false,
    this.requiresExecutive = false,
  });

  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String Function(AppStrings) labelBuilder;
  final bool adminOnly;

  /// Hidden from roles without Tarbiya access (department heads).
  final bool requiresTarbiya;

  /// Visible only to executives (Administrator / President / Secretary General
  /// / Treasurer) — e.g. Members Management.
  final bool requiresExecutive;
}

/// Primary navigation (visible to every authorized role).
const List<NavItem> kPrimaryNav = [
  NavItem(
    route: '/home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    labelBuilder: _home,
  ),
  NavItem(
    route: '/history',
    icon: Icons.history_edu_outlined,
    activeIcon: Icons.history_edu,
    labelBuilder: _history,
  ),
  // Leadership is rendered as an expandable group in the sidebar
  // (see AppSidebar) rather than a flat item.
  NavItem(
    route: '/departments',
    icon: Icons.account_tree_outlined,
    activeIcon: Icons.account_tree,
    labelBuilder: _departments,
  ),
  // Tarbiya Al-Kawadeer is reached through the Departments section (the
  // "Tarbiyah" department), so it has no dedicated sidebar entry.
  NavItem(
    route: '/reports',
    icon: Icons.description_outlined,
    activeIcon: Icons.description,
    labelBuilder: _reports,
    // Minutes/Resolution archive — executives only (Admin, President,
    // Secretary General, Treasurer).
    requiresExecutive: true,
  ),
  NavItem(
    route: '/gallery',
    icon: Icons.photo_library_outlined,
    activeIcon: Icons.photo_library,
    labelBuilder: _gallery,
  ),
  NavItem(
    route: '/members',
    icon: Icons.groups_outlined,
    activeIcon: Icons.groups,
    labelBuilder: _members,
    requiresExecutive: true,
  ),
  NavItem(
    route: '/settings',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    labelBuilder: _settings,
  ),
];

/// Administrator-only navigation.
const List<NavItem> kAdminNav = [
  NavItem(
    route: '/users',
    icon: Icons.manage_accounts_outlined,
    activeIcon: Icons.manage_accounts,
    labelBuilder: _userManagement,
    adminOnly: true,
  ),
  NavItem(
    route: '/audit',
    icon: Icons.fact_check_outlined,
    activeIcon: Icons.fact_check,
    labelBuilder: _auditLogs,
    adminOnly: true,
  ),
];

// Top-level functions so the lists can stay `const`.
String _home(AppStrings s) => s.home;
String _history(AppStrings s) => s.history;
String _departments(AppStrings s) => s.departments;
String _reports(AppStrings s) => s.reports;
String _gallery(AppStrings s) => s.gallery;
String _members(AppStrings s) => s.membersManagement;
String _settings(AppStrings s) => s.settings;
String _userManagement(AppStrings s) => s.userManagement;
String _auditLogs(AppStrings s) => s.auditLogs;
