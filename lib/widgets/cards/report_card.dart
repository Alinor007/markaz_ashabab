import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// A coloured pill for a report type.
class ReportTypeBadge extends StatelessWidget {
  const ReportTypeBadge({super.key, required this.type});
  final ReportType type;

  @override
  Widget build(BuildContext context) {
    final color =
        type == ReportType.resolution ? AppColors.goldDeep : AppColors.navy;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(type.label(context.isArabic),
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: color, fontWeight: FontWeight.w700)),
    );
  }
}

/// A report card (grid view): type badge, bilingual title, department, date,
/// summary, and optional edit/delete.
class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.report,
    required this.departmentName,
    required this.onTap,
    this.selected = false,
    this.onEdit,
    this.onDelete,
  });

  final Report report;
  final String departmentName;
  final VoidCallback onTap;
  final bool selected;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    return Material(
      color: selected ? AppColors.emeraldTint : AppColors.surface,
      borderRadius: AppRadius.card,
      child: InkWell(
        borderRadius: AppRadius.card,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.card,
            border: Border.all(
                color: selected ? AppColors.emerald : AppColors.border),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ReportTypeBadge(type: report.typeEnum),
                  const Spacer(),
                  Text(report.date, style: theme.textTheme.bodySmall),
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton<String>(
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
                              child: Text(context.trRead('Edit', 'تعديل'))),
                        if (onDelete != null)
                          PopupMenuItem(
                              value: 'delete',
                              child: Text(context.trRead('Delete', 'حذف'))),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                isArabic && report.titleAr.isNotEmpty
                    ? report.titleAr
                    : report.title,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: isArabic
                    ? AppTypography.arabic(fontSize: 18, fontWeight: FontWeight.w700)
                    : theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  const Icon(Icons.apartment_outlined,
                      size: 14, color: AppColors.textFaint),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(departmentName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall),
                  ),
                  Text('${report.pages} ${context.tr('pages', 'صفحة')}',
                      style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                isArabic && report.summaryAr.isNotEmpty
                    ? report.summaryAr
                    : report.summary,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
