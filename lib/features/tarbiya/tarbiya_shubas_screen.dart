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
              english: 'Shu\'ba', child: LoadingState());
        }
        if (area == null) {
          return ModulePage(
            english: 'Shu\'ba',
            child: EmptyState(
              icon: Icons.map_outlined,
              title: 'Area not found',
            ),
          );
        }
        return ModulePage(
          english: area.name,
          breadcrumb: HierarchyBreadcrumb(
            crumbs: [
              Crumb(
                label: 'Tarbiya Al-Kawadeer',
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
                label: Text("Add Shu'ba"),
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
                  title: "No Shu'bas yet",
                  message: canManage
                      ? "Add the first Shu'ba."
                      : null,
                );
              }
              return TarbiyaCardGrid(
                children: [
                  for (final shuba in shubas)
                    TarbiyaNavCard(
                      icon: Icons.location_city_outlined,
                      title: shuba.name,
                      onTap: () => context.go(
                          '/tarbiya/area/$areaId/shuba/${shuba.id}'),
                      onEdit: canManage
                          ? () => _editShuba(context, repo, shuba)
                          : null,
                      onDelete: canManage
                          ? () => _deleteShuba(context, repo, shuba)
                          : null,
                      footer: _MasulFooter(shuba: shuba, canManage: canManage),
                    ),
                ],
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
        title: "Add Shu'ba");
    if (result == null) return;
    await repo.createShuba(
        areaId: areaId, name: result.name);
  }

  Future<void> _editShuba(
      BuildContext context, TarbiyaRepository repo, Shuba shuba) async {
    final result = await NameFormDialog.show(context,
        title: "Edit Shu'ba",
        name: shuba.name);
    if (result == null) return;
    await repo.updateShuba(shuba.id, name: result.name);
  }

  Future<void> _deleteShuba(
      BuildContext context, TarbiyaRepository repo, Shuba shuba) async {
    final ok = await confirmDialog(
      context,
      title: context.trRead('Delete “${shuba.name}”?'),
      message: 'Members under it will be permanently deleted.',
    );
    if (ok) await repo.deleteShuba(shuba.id);
  }
}

/// The Mas'ul (Person-in-Charge) row shown at the bottom of a Shu'ba card:
/// the assigned member's photo + name, or an "Unassigned" placeholder, with an
/// Assign/Change action for managers.
class _MasulFooter extends StatelessWidget {
  const _MasulFooter({required this.shuba, required this.canManage});
  final Shuba shuba;
  final bool canManage;

  Future<void> _assign(BuildContext context) async {
    final memberRepo = context.read<MemberRepository>();
    final picked = await pickMember(context, memberRepo,
        title: 'Assign Mas\'ul');
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
                    ? 'Unassigned'
                    : masul.displayName(context.isArabic),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: masul == null
                          ? AppColors.textMuted
                          : AppColors.charcoal,
                    ),
              ),
            ),
            if (canManage) ...[
              TextButton.icon(
                onPressed: () => _assign(context),
                icon: const Icon(Icons.person_search_outlined, size: 16),
                label: Text(masul == null
                    ? 'Assign'
                    : 'Change'),
              ),
              if (masul != null)
                IconButton(
                  tooltip: 'Clear',
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
