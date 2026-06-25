import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../common/portrait_avatar.dart';

/// A leadership profile card: portrait, bilingual name, position, service
/// years, a "View Profile" action, and (for editors) edit/delete.
class LeadershipCard extends StatelessWidget {
  const LeadershipCard({
    super.key,
    required this.leader,
    required this.onView,
    this.onEdit,
    this.onDelete,
  });

  final Leader leader;
  final VoidCallback onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  bool get _canManage => onEdit != null || onDelete != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    final accent = leader.accentColor;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.md),
                  ),
                ),
              ),
              if (_canManage)
                Positioned(
                  top: 4,
                  right: 4,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert,
                        size: 18, color: AppColors.textMuted),
                    onSelected: (v) {
                      if (v == 'edit') onEdit?.call();
                      if (v == 'delete') onDelete?.call();
                    },
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        PopupMenuItem(
                            value: 'edit',
                            child: Text(context.tr('Edit', 'تعديل'))),
                      if (onDelete != null)
                        PopupMenuItem(
                            value: 'delete',
                            child: Text(context.tr('Delete', 'حذف'))),
                    ],
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
            child: Column(
              children: [
                PortraitAvatar(
                    initials: leader.initials, accent: accent, size: 80),
                const SizedBox(height: AppSpacing.md),
                Text(
                  isArabic ? leader.nameAr : leader.name,
                  textAlign: TextAlign.center,
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isArabic
                      ? AppTypography.arabic(
                          fontSize: 18, fontWeight: FontWeight.w700)
                      : theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  isArabic ? leader.positionAr : leader.position,
                  textAlign: TextAlign.center,
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (leader.serviceYears.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.schedule,
                          size: 14, color: AppColors.textFaint),
                      const SizedBox(width: AppSpacing.xs),
                      Text(leader.serviceYears,
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onView,
                    icon: const Icon(Icons.person_outline, size: 16),
                    label: Text(context.tr('View Profile', 'عرض الملف')),
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
