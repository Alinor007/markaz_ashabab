import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/tarbiya_repository.dart';
import '../../widgets/common/hierarchy_breadcrumb.dart';
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
        final isArabic = context.isArabic;
        return ModulePage(
          english: area.name,
          arabic: area.nameAr,
          breadcrumb: HierarchyBreadcrumb(
            crumbs: [
              Crumb(
                label: context.tr('Tarbiya Al-Kawadeer', 'تربية الكوادر'),
                route: '/tarbiya',
                icon: Icons.hub_outlined,
              ),
              Crumb(label: isArabic ? area.nameAr : area.name),
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
              return TarbiyaCardGrid(
                children: [
                  for (final shuba in shubas)
                    TarbiyaNavCard(
                      icon: Icons.location_city_outlined,
                      title: shuba.name,
                      titleAr: shuba.nameAr,
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
    await repo.createShuba(
        areaId: areaId, name: result.name, nameAr: result.nameAr);
  }

  Future<void> _editShuba(
      BuildContext context, TarbiyaRepository repo, Shuba shuba) async {
    final result = await NameFormDialog.show(context,
        title: context.trRead("Edit Shu'ba", 'تعديل الشُّعبة'),
        name: shuba.name,
        nameAr: shuba.nameAr);
    if (result == null) return;
    await repo.updateShuba(shuba.id, name: result.name, nameAr: result.nameAr);
  }

  Future<void> _deleteShuba(
      BuildContext context, TarbiyaRepository repo, Shuba shuba) async {
    final ok = await confirmDialog(
      context,
      title: context.trRead(
          'Delete “${shuba.name}”?', 'حذف «${shuba.nameAr}»؟'),
      message: context.trRead(
          'Members under it will be permanently deleted.',
          'سيُحذف الأعضاء التابعون لها نهائيًا.'),
    );
    if (ok) await repo.deleteShuba(shuba.id);
  }
}
