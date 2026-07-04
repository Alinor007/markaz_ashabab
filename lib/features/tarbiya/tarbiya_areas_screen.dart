import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/tarbiya_repository.dart';
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
      child: StreamBuilder<List<TarbiyaArea>>(
        stream: repo.watchAreas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LoadingState();
          final areas = snapshot.data!;
          if (areas.isEmpty) {
            return EmptyState(
              icon: Icons.map_outlined,
              title: 'No areas yet',
            );
          }
          return TarbiyaCardGrid(
            children: [
              for (final area in areas)
                TarbiyaNavCard(
                  icon: Icons.map_outlined,
                  accent: Color(area.accent),
                  title: area.name,
                  titleAr: area.nameAr,
                  subtitle: area.region.isEmpty ? null : area.region,
                  onTap: () => context.go('/tarbiya/area/${area.id}'),
                  onEdit: canManage ? () => _editArea(context, repo, area) : null,
                  onDelete:
                      canManage ? () => _deleteArea(context, repo, area) : null,
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _editArea(
      BuildContext context, TarbiyaRepository repo, TarbiyaArea area) async {
    final result = await NameFormDialog.show(context,
        title: 'Edit Area',
        name: area.name,
        nameAr: area.nameAr);
    if (result == null) return;
    await repo.updateArea(area.id, name: result.name, nameAr: result.nameAr);
  }

  Future<void> _deleteArea(
      BuildContext context, TarbiyaRepository repo, TarbiyaArea area) async {
    final ok = await confirmDialog(
      context,
      title: context.trRead('Delete area “${area.name}”?'),
      message: "Shu'bas and members under it will be permanently deleted.",
    );
    if (ok) await repo.deleteArea(area.id);
  }
}
