import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/session_controller.dart';
import '../core/data/models.dart';
import '../features/audit/audit_screen.dart';
import '../features/home/home_screen.dart';
import '../features/departments/department_detail_screen.dart';
import '../features/departments/departments_screen.dart';
import '../features/gallery/gallery_screen.dart';
import '../features/history/history_screen.dart';
import '../features/leadership/leader_form_screen.dart';
import '../features/leadership/leader_profile_screen.dart';
import '../features/leadership/leadership_screen.dart';
import '../features/login/login_screen.dart';
import '../features/members/members_management_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/tarbiya/member_form_screen.dart';
import '../features/tarbiya/member_profile_screen.dart';
import '../features/tarbiya/tarbiya_areas_screen.dart';
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

      // Account management & audit logs — Administrator only.
      if ((loc.startsWith('/users') || loc.startsWith('/audit')) &&
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
      // Creating / editing a leader — executives only (viewing stays open).
      final leaderMutation = loc.startsWith('/leadership/add') ||
          (loc.startsWith('/leadership/profile/') && loc.endsWith('/edit'));
      if (leaderMutation && !(can?.manageLeadership ?? false)) {
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
            path: '/leadership',
            redirect: (_, _) => '/leadership/office-president',
          ),
          GoRoute(
            path: '/leadership/office-president',
            builder: (context, state) => const LeadershipScreen(
              category: LeadershipCategory.officePresident,
            ),
          ),
          GoRoute(
            path: '/leadership/board',
            builder: (context, state) => const LeadershipScreen(
              category: LeadershipCategory.board,
            ),
          ),
          GoRoute(
            path: '/leadership/assembly',
            builder: (context, state) => const LeadershipScreen(
              category: LeadershipCategory.assembly,
            ),
          ),
          GoRoute(
            path: '/leadership/profile/:id',
            builder: (context, state) => LeaderProfileScreen(
              leaderId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/leadership/profile/:id/edit',
            builder: (context, state) => LeaderFormScreen(
              leaderId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/leadership/add/:category',
            builder: (context, state) => LeaderFormScreen(
              category: LeadershipCategory.fromCode(
                  state.pathParameters['category']!),
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
