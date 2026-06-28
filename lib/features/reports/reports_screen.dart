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
import '../../widgets/feedback/app_snackbar.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import '../tarbiya/widgets/confirm_dialog.dart';
import 'minutes_report_form.dart';

/// Executive Reports archive: Minutes of Meeting and Resolutions, each shown as
/// an album of attached images grouped under its title. Visible only to
/// executives (route-guarded); department reports use the P-2 form elsewhere.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  bool _canManage(BuildContext c) =>
      c.read<SessionController>().can?.manageAllReports ?? false;

  Future<void> _add(BuildContext context) async {
    final r = await showMinutesReportForm(context);
    if (r == null || !context.mounted) return;
    await context.read<MinutesReportRepository>().create(
          title: r.title,
          year: r.year,
          type: r.type,
          content: r.content,
          imagePaths: r.imagePaths,
        );
    if (context.mounted) {
      showAppSnackBar(
          context, context.trRead('Report added.', 'تمت إضافة التقرير.'));
    }
  }

  Future<void> _edit(BuildContext context, MinutesReport report) async {
    final r = await showMinutesReportForm(context, existing: report);
    if (r == null || !context.mounted) return;
    await context.read<MinutesReportRepository>().update(
          report.id,
          title: r.title,
          year: r.year,
          type: r.type,
          content: r.content,
          imagePaths: r.imagePaths,
        );
    if (context.mounted) {
      showAppSnackBar(
          context, context.trRead('Report updated.', 'تم تحديث التقرير.'));
    }
  }

  Future<void> _delete(BuildContext context, MinutesReport report) async {
    final ok = await confirmDialog(context,
        title: context.trRead('Delete report?', 'حذف التقرير؟'),
        message: report.title);
    if (!ok || !context.mounted) return;
    await context.read<MinutesReportRepository>().delete(report.id);
    if (context.mounted) {
      showAppSnackBar(
          context, context.trRead('Report deleted.', 'تم حذف التقرير.'),
          tone: SnackTone.info);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MinutesReportRepository>();
    final canManage = _canManage(context);

    return ModulePage(
      english: 'Reports',
      arabic: 'التقارير',
      actions: [
        if (canManage)
          FilledButton.icon(
            onPressed: () => _add(context),
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.tr('Add Report', 'إضافة تقرير')),
          ),
      ],
      child: StreamBuilder<List<MinutesReport>>(
        stream: repo.watchAll(),
        builder: (context, snap) {
          if (!snap.hasData) return const LoadingState();
          final reports = snap.data!;
          if (reports.isEmpty) {
            return EmptyState(
              icon: Icons.description_outlined,
              title: context.tr('No reports yet', 'لا توجد تقارير بعد'),
              message: canManage
                  ? context.tr('Add the first report.', 'أضف أول تقرير.')
                  : null,
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                for (final r in reports)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: _ReportAlbumCard(
                      report: r,
                      canManage: canManage,
                      onEdit: () => _edit(context, r),
                      onDelete: () => _delete(context, r),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A report shown as an album: header (title, type, year, actions), the body
/// content, and a grid of attached images (tap to view full screen).
class _ReportAlbumCard extends StatelessWidget {
  const _ReportAlbumCard({
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
    final images = MinutesReportRepository.imagesOf(report);
    final type = ReportType.fromCode(report.type);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.title,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        _TypeBadge(type: type),
                        const SizedBox(width: AppSpacing.sm),
                        if (report.year > 0)
                          Text('${report.year}',
                              style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              if (canManage)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 18),
                  onSelected: (v) {
                    if (v == 'edit') onEdit();
                    if (v == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        value: 'edit',
                        child: Text(context.trRead('Edit', 'تعديل'))),
                    PopupMenuItem(
                        value: 'delete',
                        child: Text(context.trRead('Delete', 'حذف'))),
                  ],
                ),
            ],
          ),
          if (report.content.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(report.content,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (images.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final path in images)
                  InkWell(
                    onTap: () => _viewImage(context, images, path),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: _AlbumThumb(path: path),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _viewImage(BuildContext context, List<String> all, String path) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: File(path).existsSync()
                    ? Image.file(File(path))
                    : const Icon(Icons.broken_image_outlined,
                        color: Colors.white54, size: 64),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(dialogContext),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlbumThumb extends StatelessWidget {
  const _AlbumThumb({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: file.existsSync()
          ? Image.file(file, width: 120, height: 120, fit: BoxFit.cover)
          : Container(
              width: 120,
              height: 120,
              color: AppColors.surfaceAlt,
              child: const Icon(Icons.broken_image_outlined,
                  color: AppColors.textFaint),
            ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});
  final ReportType type;

  @override
  Widget build(BuildContext context) {
    final isMinutes = type == ReportType.minutes;
    final color = isMinutes ? AppColors.navy : AppColors.goldDeep;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(type.label(context.isArabic),
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}
