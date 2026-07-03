import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'locale_controller.dart';

/// Bilingual (English / Arabic) string table.
///
/// Each user-facing string exists in both languages. Resolve the active set
/// with [AppStrings.of(context)] — it follows the [LocaleController].
class AppStrings {
  const AppStrings._(this._en, this._ar, this._isArabic);

  final _Strings _en;
  final _Strings _ar;
  final bool _isArabic;

  _Strings get _s => _isArabic ? _ar : _en;

  static AppStrings of(BuildContext context) {
    final isArabic = context.watch<LocaleController>().isArabic;
    return AppStrings._(_englishStrings, _arabicStrings, isArabic);
  }

  // Brand
  String get orgName => _s.orgName;
  String get orgNameArabic => _arabicBrand; // always Arabic, both languages
  String get missionStatement => _s.missionStatement;

  // Login
  String get loginTitle => _s.loginTitle;
  String get loginSubtitle => _s.loginSubtitle;
  String get username => _s.username;
  String get password => _s.password;
  String get rememberMe => _s.rememberMe;
  String get login => _s.login;
  String get usernameHint => _s.usernameHint;
  String get passwordHint => _s.passwordHint;

  // Navigation
  String get home => _s.home;
  String get dashboard => _s.dashboard;
  String get history => _s.history;
  String get leadership => _s.leadership;
  String get tarbiya => _isArabic ? 'تربية الكوادر' : 'Tarbiya Al-Kawadeer';
  String get departments => _s.departments;
  String get reports => _s.reports;
  String get gallery => _s.gallery;
  String get search => _s.search;
  String get membersManagement => _s.membersManagement;
  String get settings => _s.settings;
  String get userManagement => _s.userManagement;
  String get auditLogs => _s.auditLogs;
  String get administration => _s.administration;

  // Top bar
  String get globalSearchHint => _s.globalSearchHint;
  String get notifications => _s.notifications;
  String get logout => _s.logout;
  String get languageName => _s.languageName;

  // Home / Dashboard
  String get welcome => _s.welcome;
  String get quickAccess => _s.quickAccess;
  String get atAGlance => _s.atAGlance;
  String get statDepartments => _s.statDepartments;
  String get statLeaders => _s.statLeaders;
  String get statMembers => _s.statMembers;
  String get statReports => _s.statReports;
  String get statPhotos => _s.statPhotos;
  String get statActivities => _s.statActivities;

  // Generic states
  String get comingSoon => _s.comingSoon;
  String get comingSoonBody => _s.comingSoonBody;
  String get nothingHere => _s.nothingHere;
  String get loadingLabel => _s.loadingLabel;
  String get errorTitle => _s.errorTitle;
  String get retry => _s.retry;
}

/// Arabic org name shown in both language modes (proper noun).
const String _arabicBrand = 'مؤسسة مركز الشباب المسلم في الفلبين';

class _Strings {
  const _Strings({
    required this.orgName,
    required this.missionStatement,
    required this.loginTitle,
    required this.loginSubtitle,
    required this.username,
    required this.password,
    required this.rememberMe,
    required this.login,
    required this.usernameHint,
    required this.passwordHint,
    required this.home,
    required this.dashboard,
    required this.history,
    required this.leadership,
    required this.departments,
    required this.reports,
    required this.gallery,
    required this.search,
    required this.membersManagement,
    required this.settings,
    required this.userManagement,
    required this.auditLogs,
    required this.administration,
    required this.globalSearchHint,
    required this.notifications,
    required this.logout,
    required this.languageName,
    required this.welcome,
    required this.quickAccess,
    required this.atAGlance,
    required this.statDepartments,
    required this.statLeaders,
    required this.statMembers,
    required this.statReports,
    required this.statPhotos,
    required this.statActivities,
    required this.comingSoon,
    required this.comingSoonBody,
    required this.nothingHere,
    required this.loadingLabel,
    required this.errorTitle,
    required this.retry,
  });

  final String orgName;
  final String missionStatement;
  final String loginTitle;
  final String loginSubtitle;
  final String username;
  final String password;
  final String rememberMe;
  final String login;
  final String usernameHint;
  final String passwordHint;
  final String home;
  final String dashboard;
  final String history;
  final String leadership;
  final String departments;
  final String reports;
  final String gallery;
  final String search;
  final String membersManagement;
  final String settings;
  final String userManagement;
  final String auditLogs;
  final String administration;
  final String globalSearchHint;
  final String notifications;
  final String logout;
  final String languageName;
  final String welcome;
  final String quickAccess;
  final String atAGlance;
  final String statDepartments;
  final String statLeaders;
  final String statMembers;
  final String statReports;
  final String statPhotos;
  final String statActivities;
  final String comingSoon;
  final String comingSoonBody;
  final String nothingHere;
  final String loadingLabel;
  final String errorTitle;
  final String retry;
}

const _Strings _englishStrings = _Strings(
  orgName: 'Markazosshabab Al-Muslim Fil-Filibbin Foundation, Inc.',
  missionStatement:
      'Preserving the legacy, nurturing the leaders, and serving the Muslim '
      'youth of the Philippines through knowledge, da‘wah, and sincere service.',
  loginTitle: 'Sign in to your account',
  loginSubtitle: 'Authorized personnel only. Please enter your credentials.',
  username: 'Username',
  password: 'Password',
  rememberMe: 'Remember me',
  login: 'Sign In',
  usernameHint: 'Enter your username',
  passwordHint: 'Enter your password',
  home: 'Home',
  dashboard: 'Dashboard',
  history: 'History',
  leadership: 'Leadership',
  departments: 'Departments',
  reports: 'Reports',
  gallery: 'Gallery',
  search: 'Search',
  membersManagement: 'Members',
  settings: 'Settings',
  userManagement: 'User Management',
  auditLogs: 'Audit Logs',
  administration: 'Administration',
  globalSearchHint: 'Search members, leaders, reports…',
  notifications: 'Notifications',
  logout: 'Logout',
  languageName: 'EN',
  welcome: 'Welcome back',
  quickAccess: 'Quick Access',
  atAGlance: 'At a Glance',
  statDepartments: 'Departments',
  statLeaders: 'Leaders',
  statMembers: 'Members',
  statReports: 'Reports',
  statPhotos: 'Gallery Photos',
  statActivities: 'Activities',
  comingSoon: 'Module coming soon',
  comingSoonBody:
      'This module is part of the archive system and will be available in an '
      'upcoming release.',
  nothingHere: 'Nothing here yet',
  loadingLabel: 'Loading…',
  errorTitle: 'Something went wrong',
  retry: 'Try again',
);

const _Strings _arabicStrings = _Strings(
  orgName: 'مؤسسة مركز الشباب المسلم في الفلبين',
  missionStatement:
      'حفظ الإرث، وتربية القادة، وخدمة الشباب المسلم في الفلبين عبر العلم '
      'والدعوة والعمل المخلص.',
  loginTitle: 'تسجيل الدخول إلى حسابك',
  loginSubtitle: 'للمصرّح لهم فقط. الرجاء إدخال بيانات الدخول.',
  username: 'اسم المستخدم',
  password: 'كلمة المرور',
  rememberMe: 'تذكّرني',
  login: 'تسجيل الدخول',
  usernameHint: 'أدخل اسم المستخدم',
  passwordHint: 'أدخل كلمة المرور',
  home: 'الرئيسية',
  dashboard: 'لوحة التحكم',
  history: 'التاريخ',
  leadership: 'القيادة',
  departments: 'الأقسام',
  reports: 'التقارير',
  gallery: 'المعرض',
  search: 'البحث',
  membersManagement: 'إدارة الأعضاء',
  settings: 'الإعدادات',
  userManagement: 'إدارة المستخدمين',
  auditLogs: 'سجلات التدقيق',
  administration: 'الإدارة',
  globalSearchHint: 'ابحث عن الأعضاء والقادة والتقارير…',
  notifications: 'الإشعارات',
  logout: 'تسجيل الخروج',
  languageName: 'ع',
  welcome: 'مرحبًا بعودتك',
  quickAccess: 'الوصول السريع',
  atAGlance: 'نظرة عامة',
  statDepartments: 'الأقسام',
  statLeaders: 'القادة',
  statMembers: 'الأعضاء',
  statReports: 'التقارير',
  statPhotos: 'صور المعرض',
  statActivities: 'الأنشطة',
  comingSoon: 'الوحدة قيد التطوير',
  comingSoonBody:
      'هذه الوحدة جزء من نظام الأرشيف وستكون متاحة في إصدار قادم بإذن الله.',
  nothingHere: 'لا يوجد شيء هنا بعد',
  loadingLabel: 'جارٍ التحميل…',
  errorTitle: 'حدث خطأ ما',
  retry: 'إعادة المحاولة',
);
