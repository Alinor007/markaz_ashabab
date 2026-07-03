import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/i18n/localized.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../common/hover_lift.dart';

/// The completion status of a P-2 report's primary objective, read straight off
/// `formData` (`ProgramReport.objectiveStatus`) without depending on the report
/// forms module. Falls back to "unset" for legacy/empty payloads.
(String, Color) _objectiveStatusChip(BuildContext context, String formData) {
  var code = '';
  if (formData.isNotEmpty) {
    try {
      final json = jsonDecode(formData) as Map<String, dynamic>;
      code = '${json['objectiveStatus'] ?? ''}';
    } catch (_) {
      // Legacy/malformed payload — fall through to the unset chip.
    }
  }
  return switch (code) {
    'achieved' => (context.tr('Achieved', 'تحقق'), AppColors.emerald),
    'partial' => (
        context.tr('Partially Achieved', 'تحقق جزئيًا'),
        AppColors.goldDeep
      ),
    'not' => (context.tr('Not Achieved', 'لم يتحقق'), AppColors.error),
    _ => (context.tr('Not Reviewed', 'لم تُراجع بعد'), AppColors.textFaint),
  };
}

/// A Program Completion Report (P-2) card for a single department's Reports
/// tab: a gold "dossier" accent, the program title, a date/year, a
/// status-at-a-glance pill for the objective, a summary snippet, and an
/// optional edit/delete menu. Gently lifts on hover.
class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.report,
    required this.onTap,
    this.selected = false,
    this.onEdit,
    this.onDelete,
  });

  final Report report;
  final VoidCallback onTap;
  final bool selected;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    final (statusLabel, statusColor) =
        _objectiveStatusChip(context, report.formData);

    return HoverLift(
      radius: AppRadius.panel,
      child: Material(
        color: selected ? AppColors.emeraldTint : AppColors.surface,
        borderRadius: AppRadius.panel,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.panel,
              border: Border.all(
                  color: selected ? AppColors.emerald : AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 4, color: AppColors.goldDeep),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.goldTint,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Text(
                              'P2',
                              style: TextStyle(
                                fontFamily: AppTypography.serif,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.goldDeep,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              isArabic && report.titleAr.isNotEmpty
                                  ? report.titleAr
                                  : report.title,
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: isArabic
                                  ? AppTypography.arabic(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)
                                  : theme.textTheme.titleMedium,
                            ),
                          ),
                          if (onEdit != null || onDelete != null)
                            SizedBox(
                              height: 24,
                              child: PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
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
                                        child: Text(
                                            context.trRead('Edit', 'تعديل'))),
                                  if (onDelete != null)
                                    PopupMenuItem(
                                        value: 'delete',
                                        child: Text(
                                            context.trRead('Delete', 'حذف'))),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Icon(Icons.event_outlined,
                              size: 14, color: AppColors.textFaint),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            report.date.isEmpty
                                ? context.tr('Undated', 'بدون تاريخ')
                                : report.date,
                            style: theme.textTheme.bodySmall,
                          ),
                          if (report.year > 0) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceAlt,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.pill),
                              ),
                              child: Text('${report.year}',
                                  style: theme.textTheme.labelSmall),
                            ),
                          ],
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(statusLabel,
                                style: theme.textTheme.labelSmall?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      if (report.summary.isNotEmpty ||
                          report.summaryAr.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          isArabic && report.summaryAr.isNotEmpty
                              ? report.summaryAr
                              : report.summary,
                          textDirection: isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ],
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
