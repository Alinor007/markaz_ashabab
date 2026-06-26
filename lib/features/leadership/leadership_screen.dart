import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/audit_repository.dart';
import '../../core/repositories/leader_repository.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/cards/leadership_card.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/error_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';

/// A leadership category page (Office of the President / Board of Trustees /
/// Consultative Assembly). Lists records from the database; executives can
/// create, edit, and delete. Department heads have read-only access.
class LeadershipScreen extends StatelessWidget {
  const LeadershipScreen({super.key, required this.category});

  final LeadershipCategory category;

  LeaderRepository _repo(BuildContext c) => c.read<LeaderRepository>();
  AuditRepository _audit(BuildContext c) => c.read<AuditRepository>();
  String _actor(BuildContext c) =>
      c.read<SessionController>().user?.username ?? 'system';

  // Add / edit now open a dedicated full screen instead of a modal dialog.
  void _create(BuildContext context) =>
      context.go('/leadership/add/${category.code}');

  void _edit(BuildContext context, Leader leader) =>
      context.go('/leadership/profile/${leader.id}/edit');

  Future<void> _delete(BuildContext context, Leader leader) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.tr('Delete', 'حذف')),
        content: Text(context.tr(
            'Delete "${leader.name}"? This cannot be undone.',
            'حذف «${leader.name}»؟ لا يمكن التراجع.')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.tr('Cancel', 'إلغاء'))),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.tr('Delete', 'حذف'))),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await _repo(context).delete(leader.id);
    if (!context.mounted) return;
    await _audit(context).log(
      username: _actor(context),
      action: 'Deleted leader "${leader.name}"',
      actionAr: 'حذف قائدًا «${leader.name}»',
      module: 'Leadership',
      moduleAr: 'القيادة',
    );
  }

  @override
  Widget build(BuildContext context) {
    final canManage =
        context.watch<SessionController>().can?.manageLeadership ?? false;

    return ModulePage(
      english: category.en,
      arabic: category.ar,
      actions: [
        if (canManage)
          FilledButton.icon(
            onPressed: () => _create(context),
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.tr('Add Leader', 'إضافة قائد')),
          ),
      ],
      child: StreamBuilder<List<Leader>>(
        stream: _repo(context).watchByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorState(
                title: context.tr(
                    'Failed to load leadership.', 'تعذّر تحميل القيادة.'));
          }
          if (!snapshot.hasData) return const LoadingState();
          final leaders = snapshot.data!;
          if (leaders.isEmpty) {
            return EmptyState(
              icon: Icons.workspace_premium_outlined,
              title: context.tr('No records yet', 'لا توجد سجلات بعد'),
              message: canManage
                  ? context.tr('Add the first leadership record.',
                      'أضف أول سجل قيادة.')
                  : null,
            );
          }
          return SingleChildScrollView(
            child: Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: [
                for (final leader in leaders)
                  SizedBox(
                    width: 240,
                    child: LeadershipCard(
                      leader: leader,
                      onView: () =>
                          context.go('/leadership/profile/${leader.id}'),
                      onEdit:
                          canManage ? () => _edit(context, leader) : null,
                      onDelete:
                          canManage ? () => _delete(context, leader) : null,
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
