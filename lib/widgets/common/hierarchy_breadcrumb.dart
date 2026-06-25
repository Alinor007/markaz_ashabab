import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/localized.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// One crumb in a [HierarchyBreadcrumb]. A null [route] marks the current
/// (non-navigable) level.
class Crumb {
  const Crumb({required this.label, this.route, this.icon});
  final String label;
  final String? route;
  final IconData? icon;
}

/// A breadcrumb trail for hierarchical navigation (e.g. Tarbiya Kawadeer:
/// Area → Municipality → Roster → Member). Direction-aware separators.
class HierarchyBreadcrumb extends StatelessWidget {
  const HierarchyBreadcrumb({super.key, required this.crumbs});

  final List<Crumb> crumbs;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final theme = Theme.of(context);
    final children = <Widget>[];
    for (var i = 0; i < crumbs.length; i++) {
      final crumb = crumbs[i];
      final isLast = i == crumbs.length - 1;
      children.add(
        InkWell(
          onTap: crumb.route == null ? null : () => context.go(crumb.route!),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (crumb.icon != null) ...[
                  Icon(crumb.icon,
                      size: 15,
                      color: isLast ? AppColors.emerald : AppColors.textMuted),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  crumb.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isLast ? AppColors.emerald : AppColors.textMuted,
                    fontWeight: isLast ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      if (!isLast) {
        children.add(Icon(
          isArabic ? Icons.chevron_left : Icons.chevron_right,
          size: 16,
          color: AppColors.textFaint,
        ));
      }
    }
    return Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: children);
  }
}
