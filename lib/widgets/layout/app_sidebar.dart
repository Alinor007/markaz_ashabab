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
import '../common/brand_emblem.dart';
import '../common/role_badge.dart';

/// The permanent left sidebar: brand header, primary navigation, an
/// admin-only section, and a bottom user profile card with logout.
class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final session = context.watch<SessionController>();
    final currentRoute =
        GoRouterState.of(context).uri.path;

    return Container(
      width: AppLayout.sidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.navy,
        border: Border(
          right: BorderSide(color: AppColors.emeraldDark, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BrandHeader(strings: s),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.lg,
                horizontal: AppSpacing.md,
              ),
              children: [
                for (final item in kPrimaryNav) ...[
                  if ((!item.requiresTarbiya ||
                          (session.can?.accessTarbiya ?? false)) &&
                      (!item.requiresExecutive ||
                          (session.can?.manageMembers ?? false)))
                    _NavTile(
                      item: item,
                      strings: s,
                      selected: currentRoute == item.route ||
                          currentRoute.startsWith('${item.route}/'),
                    ),
                  // Insert the Leadership group right after History.
                  if (item.route == '/history')
                    _LeadershipNavGroup(currentRoute: currentRoute),
                ],
                if (session.isAdmin) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(text: s.administration),
                  const SizedBox(height: AppSpacing.sm),
                  for (final item in kAdminNav)
                    _NavTile(
                      item: item,
                      strings: s,
                      selected: currentRoute == item.route ||
                        currentRoute.startsWith('${item.route}/'),
                    ),
                ],
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          _ProfileCard(strings: s),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.strings});
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          const BrandEmblem(size: 48, onLight: false),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.orgName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.onNavy,
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  strings.orgNameArabic,
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.arabic(
                    fontSize: 13,
                    color: AppColors.gold,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white38,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.strings,
    required this.selected,
  });

  final NavItem item;
  final AppStrings strings;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final label = item.labelBuilder(strings);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: selected ? AppColors.emerald : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: () => context.go(item.route),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                // Gold active indicator.
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.gold : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Icon(
                  selected ? item.activeIcon : item.icon,
                  size: 20,
                  color: selected ? AppColors.onEmerald : Colors.white70,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color:
                              selected ? AppColors.onEmerald : Colors.white70,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// An expandable Leadership group with three dedicated sub-pages.
class _LeadershipNavGroup extends StatefulWidget {
  const _LeadershipNavGroup({required this.currentRoute});
  final String currentRoute;

  @override
  State<_LeadershipNavGroup> createState() => _LeadershipNavGroupState();
}

class _LeadershipNavGroupState extends State<_LeadershipNavGroup> {
  bool? _expandedOverride;

  bool get _isOnLeadership => widget.currentRoute.startsWith('/leadership');
  bool get _expanded => _expandedOverride ?? _isOnLeadership;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final isArabic = context.watch<LocaleController>().isArabic;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Material(
            color: _isOnLeadership && !_expanded
                ? AppColors.emerald
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: () =>
                  setState(() => _expandedOverride = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.md),
                child: Row(
                  children: [
                    const SizedBox(width: 3),
                    const SizedBox(width: AppSpacing.md),
                    Icon(
                      _isOnLeadership
                          ? Icons.workspace_premium
                          : Icons.workspace_premium_outlined,
                      size: 20,
                      color: _isOnLeadership
                          ? AppColors.gold
                          : Colors.white70,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        s.leadership,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_expanded)
          for (final category in LeadershipCategory.values)
            _LeadershipSubTile(
              label: isArabic ? category.ar : category.en,
              route: '/leadership/${_routeSuffix(category)}',
              selected: widget.currentRoute ==
                  '/leadership/${_routeSuffix(category)}',
            ),
      ],
    );
  }

  String _routeSuffix(LeadershipCategory category) {
    switch (category) {
      case LeadershipCategory.officePresident:
        return 'office-president';
      case LeadershipCategory.board:
        return 'board';
      case LeadershipCategory.assembly:
        return 'assembly';
    }
  }
}

class _LeadershipSubTile extends StatelessWidget {
  const _LeadershipSubTile({
    required this.label,
    required this.route,
    required this.selected,
  });
  final String label;
  final String route;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs, left: AppSpacing.lg),
      child: Material(
        color: selected ? AppColors.emerald : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: () => context.go(route),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.gold : Colors.white38,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color:
                              selected ? AppColors.onEmerald : Colors.white60,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.strings});
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>();
    final isArabic = context.watch<LocaleController>().isArabic;
    final user = session.user;
    if (user == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.gold,
                  child: Text(
                    user.avatarInitials.toUpperCase(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.onGold,
                        ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    user.displayName(isArabic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: isArabic
                        ? AppTypography.arabic(
                            fontSize: 15, color: AppColors.onNavy)
                        : Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.onNavy,
                            ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: RoleBadge(role: user.role, compact: true),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<SessionController>().signOut();
                  context.go('/login');
                },
                icon: const Icon(Icons.logout, size: 18),
                label: Text(strings.logout),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.onNavy,
                  side: const BorderSide(color: Colors.white24),
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
