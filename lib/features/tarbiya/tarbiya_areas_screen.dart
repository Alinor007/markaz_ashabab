import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/tarbiya_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/common/stat_chip.dart';
import '../../widgets/feedback/app_snackbar.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import 'widgets/confirm_dialog.dart';
import 'widgets/name_form_dialog.dart';
import 'widgets/tarbiya_nav_card.dart';

/// Level 1 — Tarbiya Al-Kawadeer areas (DB-backed, with CRUD).
class TarbiyaAreasScreen extends StatelessWidget {
  const TarbiyaAreasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<TarbiyaRepository>();
    final canManage = context.read<SessionController>().can?.manageTarbiya ?? false;

    return ModulePage(
      english: 'Tarbiya Al-Kawadeer',
      arabic: 'تربية الكوادر',
      actions: [
        if (canManage)
          FilledButton.icon(
            onPressed: () => _addArea(context, repo),
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.tr('Add Area', 'إضافة منطقة')),
          ),
      ],
      child: StreamBuilder<List<TarbiyaArea>>(
        stream: repo.watchAreas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LoadingState();
          final areas = snapshot.data!;
          if (areas.isEmpty) {
            return EmptyState(
              icon: Icons.map_outlined,
              title: context.tr('No areas yet', 'لا توجد مناطق بعد'),
            );
          }
          return StreamBuilder<Map<String, AreaStats>>(
            stream: repo.watchAreaStats(),
            builder: (context, statsSnap) {
              final stats = statsSnap.data ?? const {};
              return TarbiyaCardGrid(
                children: [
                  for (final area in areas)
                    _AreaCard(
                      area: area,
                      stats: stats[area.id] ?? const AreaStats(),
                      onTap: () => context.go('/tarbiya/area/${area.id}'),
                      onEdit:
                          canManage ? () => _editArea(context, repo, area) : null,
                      onDelete: canManage
                          ? () => _deleteArea(context, repo, area)
                          : null,
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _addArea(BuildContext context, TarbiyaRepository repo) async {
    // trRead (not tr) — runs inside an event handler, outside build, so a
    // listening lookup would throw "listen from outside the widget tree".
    final result = await NameFormDialog.show(context,
        title: context.trRead('Add Area', 'إضافة منطقة'));
    if (result == null) return;
    await repo.createArea(name: result.name);
  }

  Future<void> _editArea(
      BuildContext context, TarbiyaRepository repo, TarbiyaArea area) async {
    final result = await NameFormDialog.show(context,
        title: context.trRead('Edit Area', 'تعديل المنطقة'),
        name: area.name);
    if (result == null) return;
    await repo.updateArea(area.id, name: result.name);
  }

  Future<void> _deleteArea(
      BuildContext context, TarbiyaRepository repo, TarbiyaArea area) async {
    // Pre-check so a non-empty area never even offers the confirm dialog —
    // deleteArea() used to cascade-delete every Shu'ba (and every member
    // inside them) under the area; it now refuses instead, since that's how
    // an accidental tap could wipe out an entire roster with no way back.
    final shubaCount = await repo.shubaCount(area.id);
    if (!context.mounted) return;
    if (shubaCount > 0) {
      showAppSnackBar(
        context,
        context.trRead(
          'Area "${area.name}" still has $shubaCount shu\'ba(s). '
          'Move or delete them first.',
          'لا تزال المنطقة "${area.name}" تحتوي على $shubaCount شُعبة. '
          'انقلها أو احذفها أولاً.',
        ),
        tone: SnackTone.error,
      );
      return;
    }
    final ok = await confirmDialog(
      context,
      title: context.trRead('Delete area “${area.name}”?'),
      message: context.trRead(
          'This area has no Shu\'bas and will be permanently deleted.',
          'هذه المنطقة لا تحتوي على شُعب وستُحذف نهائيًا.'),
    );
    if (!ok || !context.mounted) return;
    try {
      await repo.deleteArea(area.id);
    } on AreaNotEmptyException {
      // Backstop for a race with the pre-check above (e.g. a Shu'ba added
      // between the check and the confirm) — same message either way.
      if (!context.mounted) return;
      showAppSnackBar(
        context,
        context.trRead(
          'Area "${area.name}" still has Shu\'bas. Move or delete them first.',
          'لا تزال المنطقة "${area.name}" تحتوي على شُعب. انقلها أو احذفها أولاً.',
        ),
        tone: SnackTone.error,
      );
    }
  }
}

/// An Area directory card: "Area" label + menu, area name, and a 2×2 grid of
/// stat chips (shu'ba count, member count, female, male).
class _AreaCard extends StatelessWidget {
  const _AreaCard({
    required this.area,
    required this.stats,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final TarbiyaArea area;
  final AreaStats stats;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TarbiyaNavCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.tr('Area', 'المنطقة'),
                style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.emerald, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TarbiyaCardMenu(onEdit: onEdit, onDelete: onDelete),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(area.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              StatChip(
                label: context.tr(
                    '${stats.shubaCount} shuba', '${stats.shubaCount} شعبة'),
              ),
              StatChip(
                label: context.tr('${stats.memberCount} members',
                    '${stats.memberCount} أعضاء'),
              ),
              StatChip(
                label:
                    context.tr('${stats.female} female', '${stats.female} إناث'),
              ),
              StatChip(
                label: context.tr('${stats.male} male', '${stats.male} ذكور'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
