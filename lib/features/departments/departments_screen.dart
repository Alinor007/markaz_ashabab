import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/department_repository.dart';
import '../../core/repositories/leader_repository.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/cards/department_card.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import '../tarbiya/widgets/confirm_dialog.dart';
import 'department_form_dialog.dart';

/// Departments overview: a responsive grid of department cards (DB-backed).
class DepartmentsScreen extends StatelessWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<DepartmentRepository>();
    final session = context.read<SessionController>();
    final canManage = session.can?.manageContent ?? false;
    final canTarbiya = session.can?.accessTarbiya ?? false;

    return ModulePage(
      english: 'Departments',
      arabic: 'الأقسام',
      actions: [
        if (canManage)
          FilledButton.icon(
            onPressed: () => _add(context, repo),
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.tr('Add Department', 'إضافة قسم')),
          ),
      ],
      child: StreamBuilder<List<Department>>(
        stream: repo.watchAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LoadingState();
          // Tarbiyah maps to the executive-only Tarbiya Al-Kawadeer module, so
          // hide it from department heads (who have no Tarbiya access).
          final departments = canTarbiya
              ? snapshot.data!
              : snapshot.data!.where((d) => d.id != 'tarbiyah').toList();
          if (departments.isEmpty) {
            return EmptyState(
              icon: Icons.account_tree_outlined,
              title: context.tr('No departments yet', 'لا توجد أقسام بعد'),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              const spacing = AppSpacing.lg;
              final columns = AppLayout.gridColumns(constraints.maxWidth);
              final itemWidth =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;
              return SingleChildScrollView(
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final dept in departments)
                      SizedBox(
                        width: itemWidth,
                        child: DepartmentCard(
                          department: dept,
                          // The Tarbiyah department opens the Tarbiya
                          // Al-Kawadeer module directly (for users with access);
                          // everything else opens the department detail.
                          onTap: () =>
                              dept.id == 'tarbiyah' && canTarbiya
                                  ? context.go('/tarbiya')
                                  : context.go('/departments/${dept.id}'),
                          onEdit:
                              canManage ? () => _edit(context, repo, dept) : null,
                          onDelete: canManage
                              ? () => _delete(context, repo, dept)
                              : null,
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _add(BuildContext context, DepartmentRepository repo) async {
    final r = await showDepartmentForm(context);
    if (r == null) return;
    await repo.create(
      name: r.name,
      description: r.description,
      iconKey: r.iconKey,
    );
  }

  Future<void> _edit(
      BuildContext context, DepartmentRepository repo, Department dept) async {
    final r = await showDepartmentForm(context, existing: dept);
    if (r == null) return;
    await repo.update(dept.id, departmentUpdateCompanion(r));
  }

  Future<void> _delete(
      BuildContext context, DepartmentRepository repo, Department dept) async {
    final leaderRepo = context.read<LeaderRepository>();
    final ok = await confirmDialog(
      context,
      title: context.trRead('Delete “${dept.name}”?'),
      message: context.trRead('Its activities will also be removed.',
          'ستُحذف أنشطته أيضًا.'),
    );
    if (!ok) return;
    // Remove the department's head/staff holder rows (and their stored photos)
    // first; they live in the Leaders table under per-department codes, so the
    // department delete alone would orphan them.
    await leaderRepo.deleteCategory('dept_head_${dept.id}');
    await leaderRepo.deleteCategory('dept_staff_${dept.id}');
    await repo.delete(dept.id);
  }
}
