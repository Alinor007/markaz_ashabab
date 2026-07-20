import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/repositories/tarbiya_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/common/hierarchy_breadcrumb.dart';
import '../../widgets/common/member_picker.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/common/stat_chip.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import 'widgets/confirm_dialog.dart';
import 'widgets/name_form_dialog.dart';
import 'widgets/tarbiya_nav_card.dart';

/// Level 2 — Shu'ba directory for an area (DB-backed, with CRUD).
class TarbiyaShubasScreen extends StatelessWidget {
  const TarbiyaShubasScreen({super.key, required this.areaId});

  final String areaId;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<TarbiyaRepository>();
    final canManage = context.read<SessionController>().can?.manageTarbiya ?? false;

    return FutureBuilder<TarbiyaArea?>(
      future: repo.getArea(areaId),
      builder: (context, areaSnap) {
        final area = areaSnap.data;
        if (areaSnap.connectionState == ConnectionState.waiting) {
          return const ModulePage(
              english: 'Shu\'ba', arabic: 'الشُّعبة', child: LoadingState());
        }
        if (area == null) {
          return ModulePage(
            english: 'Shu\'ba',
            arabic: 'الشُّعبة',
            child: EmptyState(
              icon: Icons.map_outlined,
              title: context.tr('Area not found', 'المنطقة غير موجودة'),
            ),
          );
        }
        return ModulePage(
          english: area.name,
          breadcrumb: HierarchyBreadcrumb(
            crumbs: [
              Crumb(
                label: context.tr('Tarbiya Al-Kawadeer', 'تربية الكوادر'),
                route: '/tarbiya',
                icon: Icons.hub_outlined,
              ),
              Crumb(label: area.name),
            ],
          ),
          actions: [
            if (canManage)
              FilledButton.icon(
                onPressed: () => _addShuba(context, repo),
                icon: const Icon(Icons.add, size: 18),
                label: Text(context.tr("Add Shu'ba", 'إضافة شُعبة')),
              ),
          ],
          child: StreamBuilder<List<Shuba>>(
            stream: repo.watchShubas(areaId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const LoadingState();
              final shubas = snapshot.data!;
              if (shubas.isEmpty) {
                return EmptyState(
                  icon: Icons.location_city_outlined,
                  title: context.tr("No Shu'bas yet", 'لا توجد شُعب بعد'),
                  message: canManage
                      ? context.tr(
                          "Add the first Shu'ba.", 'أضف أول شُعبة.')
                      : null,
                );
              }
              return StreamBuilder<Map<String, ShubaStats>>(
                stream: repo.watchShubaStats(areaId),
                builder: (context, statsSnap) {
                  final stats = statsSnap.data ?? const {};
                  return TarbiyaCardGrid(
                    children: [
                      for (final shuba in shubas)
                        _ShubaCard(
                          shuba: shuba,
                          stats: stats[shuba.id] ?? const ShubaStats(),
                          canManage: canManage,
                          onTap: () => context.go(
                              '/tarbiya/area/$areaId/shuba/${shuba.id}'),
                          onEdit: canManage
                              ? () => _editShuba(context, repo, shuba)
                              : null,
                          onDelete: canManage
                              ? () => _deleteShuba(context, repo, shuba)
                              : null,
                        ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _addShuba(BuildContext context, TarbiyaRepository repo) async {
    // trRead (not tr) — these run inside an event handler, outside build, so a
    // listening lookup would throw "listen from outside the widget tree".
    final result = await NameFormDialog.show(context,
        title: context.trRead("Add Shu'ba", 'إضافة شُعبة'));
    if (result == null) return;
    await repo.createShuba(areaId: areaId, name: result.name);
  }

  Future<void> _editShuba(
      BuildContext context, TarbiyaRepository repo, Shuba shuba) async {
    final result = await NameFormDialog.show(context,
        title: context.trRead("Edit Shu'ba", 'تعديل الشُّعبة'),
        name: shuba.name);
    if (result == null) return;
    await repo.updateShuba(shuba.id, name: result.name);
  }

  Future<void> _deleteShuba(
      BuildContext context, TarbiyaRepository repo, Shuba shuba) async {
    final ok = await confirmDialog(
      context,
      title: context.trRead('Delete “${shuba.name}”?'),
      message: context.trRead(
          'Members under it will be permanently deleted.',
          'سيُحذف الأعضاء التابعون لها نهائيًا.'),
    );
    if (ok) await repo.deleteShuba(shuba.id);
  }
}

/// A Shu'ba directory card: icon + member count + menu, shu'ba name, the
/// Mas'ul row, and female/male stat chips.
class _ShubaCard extends StatelessWidget {
  const _ShubaCard({
    required this.shuba,
    required this.stats,
    required this.canManage,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final Shuba shuba;
  final ShubaStats stats;
  final bool canManage;
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.apartment,
                    color: AppColors.emerald, size: 22),
              ),
              const Spacer(),
              Text('${stats.memberCount}', style: theme.textTheme.titleLarge),
              const SizedBox(width: AppSpacing.sm),
              TarbiyaCardMenu(onEdit: onEdit, onDelete: onDelete),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(shuba.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          _MasulFooter(shuba: shuba, canManage: canManage),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
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

/// The Mas'ul (Person-in-Charge) row shown on a Shu'ba card: the assigned
/// member's photo + name, or an "Unassigned" placeholder, with an
/// Assign/Reassign action for managers.
class _MasulFooter extends StatelessWidget {
  const _MasulFooter({required this.shuba, required this.canManage});
  final Shuba shuba;
  final bool canManage;

  Future<void> _assign(BuildContext context) async {
    final memberRepo = context.read<MemberRepository>();
    final picked = await pickMember(context, memberRepo,
        title: context.trRead('Assign Mas\'ul', 'تعيين المسؤول'));
    if (picked == null || !context.mounted) return;
    await context.read<TarbiyaRepository>().assignMasul(shuba.id, picked.id);
  }

  Future<void> _clear(BuildContext context) =>
      context.read<TarbiyaRepository>().assignMasul(shuba.id, null);

  @override
  Widget build(BuildContext context) {
    final repo = context.read<TarbiyaRepository>();
    return StreamBuilder<Member?>(
      stream: repo.watchMasul(shuba.id),
      builder: (context, snap) {
        final masul = snap.data;
        return Row(
          children: [
            if (masul != null)
              PortraitAvatar(
                  initials: masul.initials,
                  imagePath: masul.photoPath,
                  size: 28,
                  ring: false)
            else
              const Icon(Icons.person_outline,
                  size: 22, color: AppColors.textFaint),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                masul == null
                    ? context.tr('Unassigned', 'غير معيّن')
                    : masul.displayName(context.isArabic),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: masul == null
                          ? AppColors.textMuted
                          : AppColors.emerald,
                    ),
              ),
            ),
            if (canManage) ...[
              TextButton.icon(
                onPressed: () => _assign(context),
                icon: const Icon(Icons.person_search_outlined, size: 16),
                label: Text(masul == null
                    ? context.tr('Assign', 'تعيين')
                    : context.tr('Reassign', 'إعادة تعيين')),
              ),
              if (masul != null)
                IconButton(
                  tooltip: context.tr('Clear', 'مسح'),
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => _clear(context),
                ),
            ],
          ],
        );
      },
    );
  }
}
