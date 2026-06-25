import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/nav_items.dart';
import '../../core/auth/session_controller.dart';
import '../../core/data/models.dart';
import '../../core/i18n/locale_controller.dart';
import '../../core/i18n/strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// The top navigation bar: breadcrumbs, a global search field, language toggle,
/// notifications, and the user avatar.
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
    final locale = context.watch<LocaleController>();
    final session = context.watch<SessionController>();
    final isArabic = locale.isArabic;
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

          // Global search
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
          ),
          const SizedBox(width: AppSpacing.lg),

          // Language toggle
          _LanguageToggle(locale: locale),
          const SizedBox(width: AppSpacing.md),

          // Notifications
          _NotificationsButton(tooltip: s.notifications, isArabic: isArabic),
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

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({required this.locale});
  final LocaleController locale;

  @override
  Widget build(BuildContext context) {
    Widget seg(String text, bool active) => Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: active ? AppColors.emerald : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: active ? AppColors.onEmerald : AppColors.textMuted,
            ),
          ),
        );

    return Material(
      color: AppColors.ivory,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        onTap: locale.toggle,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              seg('EN', !locale.isArabic),
              const SizedBox(width: 2),
              seg('ع', locale.isArabic),
            ],
          ),
        ),
      ),
    );
  }
}

/// The notifications bell. There is no notifications backend yet, so rather
/// than show a fake unread badge it opens an honest empty-state popover. A
/// badge is shown only when [count] is greater than zero.
class _NotificationsButton extends StatelessWidget {
  const _NotificationsButton({
    required this.tooltip,
    required this.isArabic,
  });

  final String tooltip;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<void>(
      tooltip: tooltip,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 8),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.panel),
      itemBuilder: (context) => [
        PopupMenuItem<void>(
          enabled: false,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 220),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tooltip,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    const Icon(Icons.notifications_off_outlined,
                        size: 18, color: AppColors.textFaint),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      isArabic
                          ? 'لا توجد إشعارات جديدة'
                          : 'No new notifications',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Icon(Icons.notifications_outlined,
            size: 24, color: AppColors.charcoal),
      ),
    );
  }
}
