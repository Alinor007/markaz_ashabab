import 'package:flutter/widgets.dart';

/// English UI string table.
///
/// The app was previously bilingual; it is now English-only. Resolve the
/// strings with [AppStrings.of(context)] (the context argument is retained for
/// call-site compatibility).
class AppStrings {
  const AppStrings._();

  static const AppStrings _instance = AppStrings._();

  static AppStrings of(BuildContext context) => _instance;

  // Brand
  String get orgName => 'Markazosshabab Al-Muslim Fil-Filibbin Foundation, Inc.';
  String get missionStatement =>
      'Preserving the legacy, nurturing the leaders, and serving the Muslim '
      'youth of the Philippines through knowledge, da‘wah, and sincere service.';

  // Login
  String get loginTitle => 'Sign in to your account';
  String get loginSubtitle =>
      'Authorized personnel only. Please enter your credentials.';
  String get username => 'Username';
  String get password => 'Password';
  String get rememberMe => 'Remember me';
  String get login => 'Sign In';
  String get usernameHint => 'Enter your username';
  String get passwordHint => 'Enter your password';

  // Navigation
  String get home => 'Home';
  String get dashboard => 'Dashboard';
  String get history => 'History';
  String get leadership => 'Leadership';
  String get tarbiya => 'Tarbiya Al-Kawadeer';
  String get departments => 'Departments';
  String get reports => 'Reports';
  String get gallery => 'Gallery';
  String get search => 'Search';
  String get membersManagement => 'Members';
  String get settings => 'Settings';
  String get userManagement => 'User Management';
  String get auditLogs => 'Audit Logs';
  String get administration => 'Administration';

  // Top bar
  String get globalSearchHint => 'Search members, leaders, reports…';
  String get logout => 'Logout';

  // Home / Dashboard
  String get welcome => 'Welcome back';
  String get quickAccess => 'Quick Access';
  String get atAGlance => 'At a Glance';
  String get statDepartments => 'Departments';
  String get statLeaders => 'Leaders';
  String get statMembers => 'Members';
  String get statReports => 'Reports';
  String get statPhotos => 'Gallery Photos';
  String get statActivities => 'Activities';

  // Generic states
  String get comingSoon => 'Module coming soon';
  String get comingSoonBody =>
      'This module is part of the archive system and will be available in an '
      'upcoming release.';
  String get nothingHere => 'Nothing here yet';
  String get loadingLabel => 'Loading…';
  String get errorTitle => 'Something went wrong';
  String get retry => 'Try again';
}
