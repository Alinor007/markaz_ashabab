import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/minutes_report_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/feedback/app_snackbar.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import '../tarbiya/widgets/confirm_dialog.dart';
import 'minutes_report_form.dart';

/// A colour per report type (for badges and placeholders).
Color _typeColor(ReportType t) => switch (t) {
      ReportType.minutes => AppColors.navy,
      ReportType.resolution => AppColors.goldDeep,
      _ => AppColors.emerald,
    };

/// Executive Reports archive: Minutes of Meeting, Resolutions and other report
/// kinds, each an album of attached images. Shown as a filterable grid; tapping
/// a card opens a swipeable image viewer. Visible only to executives
/// (route-guarded); department reports use the P-2 form elsewhere.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String? _typeFilter; // report type code, null = all
  int? _yearFilter;

  bool get _canManage =>
      context.read<SessionController>().can?.manageAllReports ?? false;

  Future<void> _add() async {
    final r = await showMinutesReportForm(context);
    if (r == null || !mounted) return;
    await context.read<MinutesReportRepository>().create(
          title: r.title,
          year: r.year,
          type: r.type,
          imagePaths: r.imagePaths,
        );
    if (mounted) {
      showAppSnackBar(
          context, context.trRead('Report added.', 'تمت إضافة التقرير.'));
    }
  }

  Future<void> _edit(MinutesReport report) async {
    final r = await showMinutesReportForm(context, existing: report);
    if (r == null || !mounted) return;
    await context.read<MinutesReportRepository>().update(
          report.id,
          title: r.title,
          year: r.year,
          type: r.type,
          imagePaths: r.imagePaths,
        );
    if (mounted) {
      showAppSnackBar(
          context, context.trRead('Report updated.', 'تم تحديث التقرير.'));
    }
  }

  Future<void> _delete(MinutesReport report) async {
    final ok = await confirmDialog(context,
        title: context.trRead('Delete report?', 'حذف التقرير؟'),
        message: report.title);
    if (!ok || !mounted) return;
    await context.read<MinutesReportRepository>().delete(report.id);
    if (mounted) {
      showAppSnackBar(
          context, context.trRead('Report deleted.', 'تم حذف التقرير.'),
          tone: SnackTone.info);
    }
  }

  void _openViewer(MinutesReport report) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => _ReportViewer(
        report: report,
        canManage: _canManage,
        onEdit: () {
          Navigator.of(context, rootNavigator: true).pop();
          _edit(report);
        },
        onDelete: () {
          Navigator.of(context, rootNavigator: true).pop();
          _delete(report);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MinutesReportRepository>();
    final canManage = _canManage;

    return ModulePage(
      english: 'Reports',
      arabic: 'التقارير',
      actions: [
        if (canManage)
          FilledButton.icon(
            onPressed: _add,
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.tr('Add Report', 'إضافة تقرير')),
          ),
      ],
      child: StreamBuilder<List<MinutesReport>>(
        stream: repo.watchAll(),
        builder: (context, snap) {
          if (!snap.hasData) return const LoadingState();
          final all = snap.data!;
          if (all.isEmpty) {
            return EmptyState(
              icon: Icons.description_outlined,
              title: context.tr('No reports yet', 'لا توجد تقارير بعد'),
              message: canManage
                  ? context.tr('Add the first report.', 'أضف أول تقرير.')
                  : null,
            );
          }

          // Filter options derived from the data.
          final typesPresent = [
            for (final t in ReportType.values)
              if (t != ReportType.programCompletion &&
                  all.any((r) => r.type == t.code))
                t,
          ];
          final years = all.map((r) => r.year).where((y) => y > 0).toSet().toList()
            ..sort((a, b) => b - a);

          final filtered = all.where((r) {
            final byType = _typeFilter == null || r.type == _typeFilter;
            final byYear = _yearFilter == null || r.year == _yearFilter;
            return byType && byYear;
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (typesPresent.length > 1)
                FilterBar(
                  options: [
                    context.tr('All Types', 'كل الأنواع'),
                    for (final t in typesPresent) t.label(context.isArabic),
                  ],
                  selectedIndex: _typeFilter == null
                      ? 0
                      : typesPresent
                              .indexWhere((t) => t.code == _typeFilter) +
                          1,
                  onSelected: (i) => setState(() =>
                      _typeFilter = i == 0 ? null : typesPresent[i - 1].code),
                ),
              if (typesPresent.length > 1 && years.length > 1)
                const SizedBox(height: AppSpacing.sm),
              if (years.length > 1)
                FilterBar(
                  options: [
                    context.tr('All Years', 'كل السنوات'),
                    for (final y in years) '$y',
                  ],
                  selectedIndex:
                      _yearFilter == null ? 0 : years.indexOf(_yearFilter!) + 1,
                  onSelected: (i) => setState(
                      () => _yearFilter = i == 0 ? null : years[i - 1]),
                ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        icon: Icons.filter_alt_off_outlined,
                        title: context.tr('No matching reports',
                            'لا توجد تقارير مطابقة'),
                      )
                    : SingleChildScrollView(
                        child: LayoutBuilder(
                          builder: (context, box) {
                            const spacing = AppSpacing.lg;
                            final columns =
                                AppLayout.gridColumns(box.maxWidth);
                            final itemWidth = (box.maxWidth -
                                    spacing * (columns - 1)) /
                                columns;
                            return Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              children: [
                                for (final r in filtered)
                                  SizedBox(
                                    width: itemWidth,
                                    child: _ReportGridCard(
                                      report: r,
                                      canManage: canManage,
                                      onTap: () => _openViewer(r),
                                      onEdit: () => _edit(r),
                                      onDelete: () => _delete(r),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A report album tile: a cover image (or a typed placeholder), a type badge,
/// an image-count chip, the title and year, plus an editor menu.
class _ReportGridCard extends StatelessWidget {
  const _ReportGridCard({
    required this.report,
    required this.canManage,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });
  final MinutesReport report;
  final bool canManage;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final images = MinutesReportRepository.imagesOf(report);
    final type = ReportType.fromCode(report.type);
    final color = _typeColor(type);
    final cover = images.isNotEmpty ? images.first : null;

    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.card,
      child: InkWell(
        borderRadius: AppRadius.card,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover
              AspectRatio(
                aspectRatio: 1.4,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.md)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (cover != null && File(cover).existsSync())
                        Image.file(File(cover), fit: BoxFit.cover)
                      else
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                color.withValues(alpha: 0.18),
                                color.withValues(alpha: 0.38),
                              ],
                            ),
                          ),
                          child: Icon(Icons.description_outlined,
                              size: 48,
                              color: AppColors.surface.withValues(alpha: 0.9)),
                        ),
                      PositionedDirectional(
                        top: AppSpacing.sm,
                        start: AppSpacing.sm,
                        child: _TypeBadge(type: type),
                      ),
                      if (images.length > 1)
                        PositionedDirectional(
                          bottom: AppSpacing.sm,
                          end: AppSpacing.sm,
                          child: _CountChip(count: images.length),
                        ),
                      if (canManage)
                        PositionedDirectional(
                          top: AppSpacing.xs,
                          end: AppSpacing.xs,
                          child: Material(
                            color: Colors.black.withValues(alpha: 0.30),
                            shape: const CircleBorder(),
                            child: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert,
                                  size: 18, color: Colors.white),
                              onSelected: (v) {
                                if (v == 'edit') onEdit();
                                if (v == 'delete') onDelete();
                              },
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                    value: 'edit',
                                    child:
                                        Text(context.trRead('Edit', 'تعديل'))),
                                PopupMenuItem(
                                    value: 'delete',
                                    child:
                                        Text(context.trRead('Delete', 'حذف'))),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (report.year > 0)
                          Text('${report.year}',
                              style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                        Icon(Icons.collections_outlined,
                            size: 14, color: AppColors.textFaint),
                        const SizedBox(width: AppSpacing.xs),
                        Text('${images.length}',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.collections_outlined, size: 13, color: Colors.white),
          const SizedBox(width: AppSpacing.xs),
          Text('$count',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});
  final ReportType type;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(type);
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(type.label(context.isArabic),
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: color, fontWeight: FontWeight.w700)),
    );
  }
}

/// A swipeable image viewer for a report album, mirroring the Gallery lightbox.
class _ReportViewer extends StatelessWidget {
  const _ReportViewer({
    required this.report,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });
  final MinutesReport report;
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final images = MinutesReportRepository.imagesOf(report);
    final type = ReportType.fromCode(report.type);
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.panel),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 620),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.lg)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (images.isNotEmpty)
                      PageView(
                        children: [
                          for (final path in images)
                            Container(
                              color: Colors.black,
                              alignment: Alignment.center,
                              child: File(path).existsSync()
                                  ? InteractiveViewer(
                                      child: Image.file(File(path),
                                          fit: BoxFit.contain))
                                  : const Icon(Icons.broken_image_outlined,
                                      color: Colors.white54, size: 64),
                            ),
                        ],
                      )
                    else
                      Container(
                        color: Colors.black,
                        alignment: Alignment.center,
                        child: Icon(Icons.description_outlined,
                            size: 96,
                            color: Colors.white.withValues(alpha: 0.5)),
                      ),
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.md,
                      child: Row(
                        children: [
                          if (canManage) ...[
                            _RoundIconButton(
                              icon: Icons.edit_outlined,
                              tooltip: context.tr('Edit', 'تعديل'),
                              onTap: onEdit,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _RoundIconButton(
                              icon: Icons.delete_outline,
                              tooltip: context.tr('Delete', 'حذف'),
                              onTap: onDelete,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          _RoundIconButton(
                            icon: Icons.close,
                            tooltip: context.tr('Close', 'إغلاق'),
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    if (images.length > 1)
                      Positioned(
                        bottom: AppSpacing.md,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              context.tr('Swipe to browse · ${images.length}',
                                  'اسحب للتصفح · ${images.length}'),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.title,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: isArabic
                        ? AppTypography.arabic(
                            fontSize: 22, fontWeight: FontWeight.w700)
                        : Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      _TypeBadge(type: type),
                      const SizedBox(width: AppSpacing.sm),
                      if (report.year > 0)
                        Text('${report.year}',
                            style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }
}
