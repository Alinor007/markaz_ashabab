import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/session_controller.dart';
import '../features/audit/audit_screen.dart';
import '../features/home/home_screen.dart';
import '../features/departments/department_activity_view_screen.dart';
import '../features/departments/department_detail_screen.dart';
import '../features/departments/departments_screen.dart';
import '../features/gallery/gallery_screen.dart';
import '../features/history/history_screen.dart';
import '../features/history/legacy_leader_profile_screen.dart';
import '../features/leadership/leader_profile_screen.dart';
import '../features/leadership/leadership_screen.dart';
import '../features/login/login_screen.dart';
import '../features/members/members_management_screen.dart';
import '../features/reports/department_report_view_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/tarbiya/member_form_screen.dart';
import '../features/tarbiya/member_profile_screen.dart';
import '../features/tarbiya/tarbiya_areas_screen.dart';
import '../features/tarbiya/class_info_screen.dart';
import '../features/tarbiya/tarbiya_classes_screen.dart';
import '../features/tarbiya/tarbiya_levels_screen.dart';
import '../features/tarbiya/tarbiya_member_list_screen.dart';
import '../features/tarbiya/tarbiya_shubas_screen.dart';
import '../features/users/users_screen.dart';
import '../widgets/layout/app_shell.dart';

/// Builds the app router. Authentication is enforced via [redirect] using the
/// [session] controller (also the router's refresh listenable). Admin-only
/// routes are guarded so they cannot be reached by non-admin roles.
GoRouter createRouter(SessionController session) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: session,
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';
      if (!session.isAuthenticated) {
        return loggingIn ? null : '/login';
      }
      if (loggingIn) return '/home';

      // Role-based route guards (RBAC).
      final loc = state.matchedLocation;
      final can = session.can;

      // Account management, audit logs & settings — Administrator only.
      if ((loc.startsWith('/users') ||
              loc.startsWith('/audit') ||
              loc.startsWith('/settings')) &&
          !session.isAdmin) {
        return '/home';
      }
      // Tarbiya module — department heads have no access.
      if (loc.startsWith('/tarbiya') && !(can?.accessTarbiya ?? false)) {
        return '/home';
      }
      // Members Management — executives only.
      if (loc.startsWith('/members') && !(can?.manageMembers ?? false)) {
        return '/home';
      }
      // Reports archive (Minutes / Resolutions) — executives only.
      if (loc.startsWith('/reports') && !(can?.manageAllReports ?? false)) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/history/legacy/:id',
            builder: (context, state) => LegacyLeaderProfileScreen(
              legacyLeaderId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/leadership',
            redirect: (_, _) => '/leadership/office-president',
          ),
          GoRoute(
            path: '/leadership/office-president',
            builder: (context, state) => const LeadershipPositionsScreen(
              code: 'office_president',
              titleEn: 'Office of the President',
              titleAr: 'مكتب الرئيس',
            ),
          ),
          GoRoute(
            path: '/leadership/board',
            builder: (context, state) => const LeadershipPositionsScreen(
              code: 'board',
              titleEn: 'Board of Trustees',
              titleAr: 'مجلس الأمناء',
            ),
          ),
          GoRoute(
            path: '/leadership/assembly',
            redirect: (_, _) => '/leadership/assembly/general',
          ),
          GoRoute(
            path: '/leadership/assembly/general',
            builder: (context, state) => const LeadershipPositionsScreen(
              code: 'assembly_general',
              titleEn: 'General Membership',
              titleAr: 'العضوية العامة',
            ),
          ),
          GoRoute(
            path: '/leadership/assembly/committee/hayah',
            builder: (context, state) => const LeadershipPositionsScreen(
              code: 'committee_hayah',
              titleEn: "Hay-ah Shar'iyyah",
              titleAr: 'الهيئة الشرعية',
            ),
          ),
          GoRoute(
            path: '/leadership/assembly/committee/audit',
            builder: (context, state) => const LeadershipPositionsScreen(
              code: 'committee_audit',
              titleEn: 'Audit',
              titleAr: 'التدقيق',
            ),
          ),
          GoRoute(
            path: '/leadership/position/:leaderId',
            builder: (context, state) => LeaderProfileScreen(
              leaderId: state.pathParameters['leaderId']!,
            ),
          ),
          GoRoute(
            path: '/departments',
            builder: (context, state) => const DepartmentsScreen(),
          ),
          GoRoute(
            path: '/departments/:id',
            builder: (context, state) => DepartmentDetailScreen(
              departmentId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/departments/:id/activities/:activityId',
            builder: (context, state) => DepartmentActivityViewScreen(
              departmentId: state.pathParameters['id']!,
              activityId: state.pathParameters['activityId']!,
            ),
          ),
          GoRoute(
            path: '/departments/:id/reports/:reportId',
            builder: (context, state) => DepartmentReportViewScreen(
              departmentId: state.pathParameters['id']!,
              reportId: state.pathParameters['reportId']!,
            ),
          ),
          GoRoute(
            path: '/tarbiya',
            builder: (context, state) => const TarbiyaAreasScreen(),
          ),
          GoRoute(
            path: '/tarbiya/area/:areaId',
            builder: (context, state) => TarbiyaShubasScreen(
              areaId: state.pathParameters['areaId']!,
            ),
          ),
          GoRoute(
            path: '/tarbiya/area/:areaId/shuba/:shubaId',
            builder: (context, state) => TarbiyaLevelsScreen(
              areaId: state.pathParameters['areaId']!,
              shubaId: state.pathParameters['shubaId']!,
            ),
          ),
          GoRoute(
            path: '/tarbiya/area/:areaId/shuba/:shubaId/level/:level',
            builder: (context, state) => TarbiyaMemberListScreen(
              areaId: state.pathParameters['areaId']!,
              shubaId: state.pathParameters['shubaId']!,
              level: int.tryParse(state.pathParameters['level'] ?? '1') ?? 1,
            ),
          ),
          GoRoute(
            path: '/tarbiya/area/:areaId/shuba/:shubaId/level/:level/classes',
            builder: (context, state) => TarbiyaClassesScreen(
              areaId: state.pathParameters['areaId']!,
              shubaId: state.pathParameters['shubaId']!,
              level: int.tryParse(state.pathParameters['level'] ?? '1') ?? 1,
            ),
          ),
          GoRoute(
            // Section is free text, so the class identity (naqib + section)
            // travels in query parameters rather than path segments.
            path: '/tarbiya/area/:areaId/shuba/:shubaId/level/:level/class-info',
            builder: (context, state) => ClassInfoScreen(
              areaId: state.pathParameters['areaId']!,
              shubaId: state.pathParameters['shubaId']!,
              level: int.tryParse(state.pathParameters['level'] ?? '1') ?? 1,
              naqibId: state.uri.queryParameters['naqib'] ?? '',
              section: state.uri.queryParameters['section'] ?? '',
            ),
          ),
          GoRoute(
            path: '/tarbiya/add-member',
            builder: (context, state) => MemberFormScreen(
              shubaId: state.uri.queryParameters['shuba'],
              level: int.tryParse(state.uri.queryParameters['level'] ?? ''),
            ),
          ),
          GoRoute(
            path: '/tarbiya/member/:memberId',
            builder: (context, state) => MemberProfileScreen(
              memberId: state.pathParameters['memberId']!,
            ),
          ),
          GoRoute(
            path: '/tarbiya/member/:memberId/edit',
            builder: (context, state) => MemberFormScreen(
              memberId: state.pathParameters['memberId'],
            ),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/gallery',
            builder: (context, state) => const GalleryScreen(),
          ),
          GoRoute(
            path: '/members',
            builder: (context, state) => const MembersManagementScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => SearchScreen(
              key: ValueKey(state.uri.queryParameters['q'] ?? ''),
              initialQuery: state.uri.queryParameters['q'],
            ),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) => const UsersScreen(),
          ),
          GoRoute(
            path: '/audit',
            builder: (context, state) => const AuditScreen(),
          ),
        ],
      ),
    ],
  );
}
