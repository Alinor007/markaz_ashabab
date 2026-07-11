import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/nav_items.dart';
import '../../core/auth/session_controller.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/i18n/strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// The top navigation bar: breadcrumbs, a global search field, language
/// toggle, and the user avatar.
class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key});

  String _currentLabel(AppStrings s, String route, bool isArabic) {
    if (route.startsWith('/tarbiya')) {
      return isArabic ? 'تربية الكوادر' : 'Tarbiya Kawadeer';
    }
    if (route.startsWith('/leadership')) return s.leadership;
    if (route.startsWith('/search')) return s.search;
    // Longest matching nav prefix wins (so detail routes resolve correctly).
    String? best;
    String? label;
    for (final item in [...kPrimaryNav, ...kAdminNav]) {
      if (route == item.route || route.startsWith('${item.route}/')) {
        if (best == null || item.route.length > best.length) {
          best = item.route;
          label = item.labelBuilder(s);
        }
      }
    }
    return label ?? s.home;
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final session = context.watch<SessionController>();
    final isArabic = context.isArabic;
    final route = GoRouterState.of(context).uri.path;
    final pageLabel = _currentLabel(s, route, isArabic);

    return Container(
      height: AppLayout.topBarHeight,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Row(
        children: [
          // Breadcrumbs
          Icon(Icons.home_outlined, size: 18, color: AppColors.textMuted),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            isArabic ? Icons.chevron_left : Icons.chevron_right,
            size: 18,
            color: AppColors.textFaint,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(pageLabel, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(width: AppSpacing.xl),

          // Global search — hidden from department heads.
          if (session.can?.globalSearch ?? false)
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: SizedBox(
                  height: 42,
                  child: TextField(
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      final q = value.trim();
                      if (q.isEmpty) return;
                      context.go('/search?q=${Uri.encodeQueryComponent(q)}');
                    },
                    decoration: InputDecoration(
                      hintText: s.globalSearchHint,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      isDense: true,
                      fillColor: AppColors.ivory,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    ),
                  ),
                ),
              ),
            )
          else
            const Spacer(),
          const SizedBox(width: AppSpacing.lg),

          // Avatar
          if (session.user != null)
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.emerald,
              child: Text(
                session.user!.avatarInitials.toUpperCase(),
                style: AppTypography.textTheme.titleSmall
                    ?.copyWith(color: AppColors.onEmerald),
              ),
            ),
        ],
      ),
    );
  }
}

