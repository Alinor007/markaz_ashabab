import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/department_repository.dart';
import '../../core/repositories/gallery_repository.dart';
import '../../core/repositories/leader_repository.dart';
import '../../core/repositories/report_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/cards/report_card.dart';
import '../../widgets/common/hover_lift.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/common/profile_header.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/feedback/app_snackbar.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../leadership/leadership_assign_dialog.dart';
import '../reports/report_form_dialog.dart';
import '../tarbiya/widgets/confirm_dialog.dart';
import 'department_activity_dialog.dart';
import 'department_form_dialog.dart';

/// Department detail with Overview / Activities / Reports tabs.
class DepartmentDetailScreen extends StatelessWidget {
  const DepartmentDetailScreen({super.key, required this.departmentId});

  final String departmentId;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<DepartmentRepository>();
    return StreamBuilder<Department?>(
      stream: repo.watchById(departmentId),
      builder: (context, snap) {
        if (!snap.hasData && snap.connectionState == ConnectionState.waiting) {
          return const Padding(
              padding: EdgeInsets.all(AppSpacing.xxl), child: LoadingState());
        }
        final dept = snap.data;
        if (dept == null) {
          return EmptyState(
            icon: Icons.account_tree_outlined,
            title: context.tr('Department not found', 'القسم غير موجود'),
          );
        }
        return _DetailBody(department: dept);
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.department});
  final Department department;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return DefaultTabController(
      length: 4,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => context.go('/departments'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back,
                        size: 18, color: AppColors.emerald),
                    const SizedBox(width: AppSpacing.sm),
                    Text(context.tr('Back to Departments', 'العودة إلى الأقسام'),
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: AppColors.emerald)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ProfileHeader(
              initials: '',
              leadingIcon: department.icon,
              nameEn: department.name,
              subtitleEn: 'Department',
              accent: department.accentColor,
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.border),
              ),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicator: BoxDecoration(
                  color: AppColors.emerald,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.onEmerald,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: AppTypography.textTheme.labelLarge,
                tabs: [
                  Tab(text: context.tr('Overview', 'نظرة عامة')),
                  Tab(text: context.tr('Staffs', 'الطاقم')),
                  Tab(text: context.tr('Activities', 'الأنشطة')),
                  Tab(text: context.tr('Reports', 'التقارير')),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: TabBarView(
                children: [
                  _OverviewTab(department: department),
                  _StaffsTab(department: department),
                  _ActivitiesTab(department: department),
                  _ReportsTab(department: department),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════ Overview ════════════════════════════

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.department});
  final Department department;

  @override
  Widget build(BuildContext context) {
    final deptRepo = context.read<DepartmentRepository>();
    final reportRepo = context.read<ReportRepository>();
    // Admin and executives may edit the department's overview and contact
    // details; department heads see these cards read-only.
    final canManage =
        context.watch<SessionController>().can?.manageContent ?? false;
    final editAction =
        canManage ? _EditDepartmentButton(department: department) : null;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoPanel(
            icon: Icons.info_outline,
            title: context.tr('About', 'نبذة'),
            action: editAction,
            child: Text(
              department.description.isEmpty
                  ? context.tr('No description provided.', 'لا يوجد وصف.')
                  : department.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: deptRepo.watchActivities(department.id),
                  builder: (context, snap) => StatCard(
                    value: '${snap.data?.length ?? 0}',
                    label: 'Total Activities',
                    icon: Icons.event_available_outlined,
                    accent: AppColors.navy,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: StreamBuilder(
                  stream: reportRepo.watchByDepartment(department.id),
                  builder: (context, snap) => StatCard(
                    value: '${snap.data?.length ?? 0}',
                    label: 'Total Reports',
                    icon: Icons.description_outlined,
                    accent: AppColors.goldDeep,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

// ════════════════════════════ Staffs ════════════════════════════

/// Head of Department + Department Staffs — both filled by manually entering
/// the holder's name, photo, and biography sections (stored as [Leaders] rows
/// under per-department category codes), like the Leadership positions.
/// Admins/executives manage; others read-only. Tapping a row opens the
/// holder's view-only leader profile.
class _StaffsTab extends StatelessWidget {
  const _StaffsTab({required this.department});
  final Department department;

  String get _headCode => 'dept_head_${department.id}';
  String get _staffCode => 'dept_staff_${department.id}';

  /// Opens the assign/edit form, prefilled from [existing] (loading its
  /// biography sections first) when reassigning or editing.
  Future<PositionHolderResult?> _openForm(
      BuildContext context, String positionTitle, Leader? existing) async {
    final leaders = context.read<LeaderRepository>();
    PositionHolderResult? prefill;
    if (existing != null) {
      final sections = await leaders.watchLeaderSections(existing.id).first;
      if (!context.mounted) return null;
      prefill = (
        name: existing.name,
        photoPath: existing.photoPath,
        sections: [for (final s in sections) (title: s.title, body: s.body)],
      );
    }
    return showAssignPersonDialog(context,
        positionTitle: positionTitle, existing: prefill);
  }

  Future<void> _assignHead(BuildContext context, Leader? current) async {
    final leaders = context.read<LeaderRepository>();
    final title = 'Head of ${department.name}';
    final r = await _openForm(context, title, current);
    if (r == null || !context.mounted) return;
    if (current == null) {
      await leaders.createHolder(
        categoryCode: _headCode,
        positionTitle: title,
        name: r.name,
        photoPath: r.photoPath,
        sections: r.sections,
      );
    } else {
      await leaders.setPositionHolder(current.id,
          name: r.name, photoPath: r.photoPath);
      await leaders.setLeaderSections(current.id, r.sections);
    }
  }

  Future<void> _clearHead(BuildContext context, Leader current) =>
      context.read<LeaderRepository>().delete(current.id);

  Future<void> _addStaff(BuildContext context) async {
    final leaders = context.read<LeaderRepository>();
    final title = '${department.name} Staff';
    final r = await _openForm(context, title, null);
    if (r == null || !context.mounted) return;
    await leaders.createHolder(
      categoryCode: _staffCode,
      positionTitle: title,
      name: r.name,
      photoPath: r.photoPath,
      sections: r.sections,
    );
  }

  Future<void> _editStaff(BuildContext context, Leader staff) async {
    final leaders = context.read<LeaderRepository>();
    final r = await _openForm(context, staff.position, staff);
    if (r == null || !context.mounted) return;
    await leaders.setPositionHolder(staff.id,
        name: r.name, photoPath: r.photoPath);
    await leaders.setLeaderSections(staff.id, r.sections);
  }

  Future<void> _removeStaff(BuildContext context, Leader staff) =>
      context.read<LeaderRepository>().delete(staff.id);

  @override
  Widget build(BuildContext context) {
    final repo = context.read<LeaderRepository>();
    final canManage =
        context.watch<SessionController>().can?.manageContent ?? false;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<List<Leader>>(
            stream: repo.watchByCategoryCode(_headCode),
            builder: (context, snap) {
              final rows = snap.data ?? const <Leader>[];
              final head = rows.isEmpty ? null : rows.first;
              return InfoPanel(
                icon: Icons.workspace_premium_outlined,
                title: context.tr('Head of Department', 'رئيس القسم'),
                action: canManage
                    ? _StaffActionButton(
                        icon: Icons.person_search_outlined,
                        label: head == null
                            ? context.tr('Assign', 'تعيين')
                            : context.tr('Reassign', 'إعادة تعيين'),
                        onPressed: () => _assignHead(context, head),
                      )
                    : null,
                child: head == null
                    ? _UnassignedRow(
                        label: context.tr('Unassigned', 'غير معيّن'))
                    : _HolderRow(
                        holder: head,
                        trailing: canManage
                            ? IconButton(
                                tooltip: context.tr('Clear', 'مسح'),
                                icon: const Icon(Icons.person_remove_outlined,
                                    size: 18),
                                onPressed: () => _clearHead(context, head),
                              )
                            : null,
                      ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          InfoPanel(
            icon: Icons.groups_outlined,
            title: context.tr('Department Staffs', 'طاقم القسم'),
            action: canManage
                ? _StaffActionButton(
                    icon: Icons.person_add_alt_1_outlined,
                    label: context.tr('Add', 'إضافة'),
                    onPressed: () => _addStaff(context),
                  )
                : null,
            child: StreamBuilder<List<Leader>>(
              stream: repo.watchByCategoryCode(_staffCode),
              builder: (context, snap) {
                final staff = snap.data ?? const <Leader>[];
                if (staff.isEmpty) {
                  return Text(
                    context.tr('No staff added yet', 'لم تتم إضافة طاقم بعد'),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textMuted),
                  );
                }
                return Column(
                  children: [
                    for (var i = 0; i < staff.length; i++) ...[
                      if (i > 0) const Divider(height: AppSpacing.lg),
                      _HolderRow(
                        holder: staff[i],
                        trailing: canManage
                            ? PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.more_vert, size: 18),
                                onSelected: (v) {
                                  if (v == 'edit') {
                                    _editStaff(context, staff[i]);
                                  }
                                  if (v == 'remove') {
                                    _removeStaff(context, staff[i]);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 'edit',
                                      child: Text(
                                          context.trRead('Edit', 'تعديل'))),
                                  PopupMenuItem(
                                      value: 'remove',
                                      child: Text(
                                          context.trRead('Remove', 'إزالة'))),
                                ],
                              )
                            : null,
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A compact action button used in the Staffs panel headers.
class _StaffActionButton extends StatelessWidget {
  const _StaffActionButton(
      {required this.icon, required this.label, required this.onPressed});
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

/// Initials from a free-text holder name: first + last word, or the first two
/// letters of a single word.
String _initialsOf(String name) {
  final parts = name.replaceAll('.', '').trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return '';
  if (parts.length == 1) {
    return parts.first
        .substring(0, parts.first.length >= 2 ? 2 : 1)
        .toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

/// A position-holder row (photo + name + office) used in the Staffs tab;
/// tapping opens the holder's view-only leader profile.
class _HolderRow extends StatelessWidget {
  const _HolderRow({required this.holder, this.trailing});
  final Leader holder;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onTap: () => context.push('/leadership/position/${holder.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            PortraitAvatar(
                initials: _initialsOf(holder.name),
                imagePath: holder.photoPath,
                size: 44,
                ring: false),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(holder.name,
                      style: Theme.of(context).textTheme.titleSmall),
                  Text(holder.position,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// Placeholder shown when no Head of Department is assigned.
class _UnassignedRow extends StatelessWidget {
  const _UnassignedRow({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceAlt,
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.person_outline,
              size: 20, color: AppColors.textFaint),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textMuted)),
      ],
    );
  }
}

/// A compact edit button (shown to admin/executives) that opens the department
/// form to update the overview, head, and contact details. The detail screen
/// streams the department, so saved changes appear immediately.
class _EditDepartmentButton extends StatelessWidget {
  const _EditDepartmentButton({required this.department});
  final Department department;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.tr('Edit', 'تعديل'),
      icon: const Icon(Icons.edit_outlined, size: 18),
      color: AppColors.emerald,
      visualDensity: VisualDensity.compact,
      onPressed: () => _edit(context),
    );
  }

  Future<void> _edit(BuildContext context) async {
    final repo = context.read<DepartmentRepository>();
    final r = await showDepartmentForm(context, existing: department);
    if (r == null) return;
    await repo.update(department.id, departmentUpdateCompanion(r));
  }
}

// ════════════════════════════ Activities ════════════════════════════

class _ActivitiesTab extends StatefulWidget {
  const _ActivitiesTab({required this.department});
  final Department department;

  @override
  State<_ActivitiesTab> createState() => _ActivitiesTabState();
}

class _ActivitiesTabState extends State<_ActivitiesTab> {
  static const _pageSize = 8;
  int _visible = _pageSize;
  String _query = '';
  int _statusFilter = 0; // index into ActivityStatus.values

  Department get department => widget.department;

  List<DeptActivity> _apply(List<DeptActivity> items) {
    final q = _query.trim().toLowerCase();
    return items.where((a) {
      final matchesQuery =
          q.isEmpty || a.title.toLowerCase().contains(q);
      final matchesStatus =
          a.status == ActivityStatus.values[_statusFilter].code;
      return matchesQuery && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<DepartmentRepository>();
    final session = context.watch<SessionController>();
    final canManage = session.can?.manageActivityForDepartment(
            session.user?.departmentId, department.id) ??
        false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (canManage)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton.icon(
              onPressed: () => _add(context, repo),
              icon: const Icon(Icons.add, size: 18),
              label: Text(context.tr('Add Activity', 'إضافة نشاط')),
            ),
          ),
        if (canManage) const SizedBox(height: AppSpacing.md),
        Expanded(
          child: StreamBuilder<List<DeptActivity>>(
            stream: repo.watchActivities(department.id),
            builder: (context, snap) {
              if (!snap.hasData) return const LoadingState();
              final items = snap.data!;
              if (items.isEmpty) {
                return EmptyState(
                  icon: Icons.event_busy_outlined,
                  title: context.tr('No activities yet', 'لا توجد أنشطة بعد'),
                );
              }
              final filtered = _apply(items);
              final shown = filtered.take(_visible).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ActivityFilterBar(
                    query: _query,
                    onQuery: (v) => setState(() => _query = v),
                    statusFilter: _statusFilter,
                    onStatus: (i) => setState(() => _statusFilter = i),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: filtered.isEmpty
                        ? EmptyState(
                            icon: Icons.filter_alt_off_outlined,
                            title: context.tr(
                                'No matching activities', 'لا توجد نتائج مطابقة'),
                          )
                        : _PagedList(
                            shownCount: shown.length,
                            total: filtered.length,
                            onLoadMore: () =>
                                setState(() => _visible += _pageSize),
                            itemBuilder: (context, i) => _ActivityTile(
                              activity: shown[i],
                              canManage: canManage,
                              onTap: () => context.go(
                                  '/departments/${department.id}/activities/${shown[i].id}'),
                              onEdit: () => _edit(context, repo, shown[i]),
                              onDelete: () => _delete(context, repo, shown[i]),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _add(BuildContext context, DepartmentRepository repo) async {
    final r = await showActivityForm(context, department: department);
    if (r == null) return;
    try {
      await repo.addActivity(
        departmentId: department.id,
        title: r.title,
        description: r.description,
        date: r.date,
        status: r.status,
        attendance: r.attendance,
        formData: r.formData,
      );
      if (context.mounted) {
        showAppSnackBar(
            context, context.trRead('Activity saved.', 'تم حفظ النشاط.'));
      }
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(
            context, context.trRead('Could not save activity: $e',
                'تعذّر حفظ النشاط: $e'),
            tone: SnackTone.error);
      }
    }
  }

  Future<void> _edit(
      BuildContext context, DepartmentRepository repo, DeptActivity a) async {
    final r = await showActivityForm(context,
        department: department, existing: a);
    if (r == null) return;
    try {
      await repo.updateActivity(a.id,
          title: r.title,
          description: r.description,
          date: r.date,
          status: r.status,
          attendance: r.attendance,
          formData: r.formData);
      if (context.mounted) {
        showAppSnackBar(
            context, context.trRead('Activity updated.', 'تم تحديث النشاط.'));
      }
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(
            context, context.trRead('Could not save activity: $e',
                'تعذّر حفظ النشاط: $e'),
            tone: SnackTone.error);
      }
    }
  }

  Future<void> _delete(
      BuildContext context, DepartmentRepository repo, DeptActivity a) async {
    final ok = await confirmDialog(context,
        title: context.trRead('Delete activity?', 'حذف النشاط؟'),
        message: a.title);
    if (ok) await repo.deleteActivity(a.id);
  }
}

/// Search + status filter row for the Activities tab. Wraps responsively on
/// narrow screens.
class _ActivityFilterBar extends StatelessWidget {
  const _ActivityFilterBar({
    required this.query,
    required this.onQuery,
    required this.statusFilter,
    required this.onStatus,
  });
  final String query;
  final ValueChanged<String> onQuery;
  final int statusFilter;
  final ValueChanged<int> onStatus;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SearchField(
          width: 240,
          hint: context.tr('Search activities…', 'ابحث عن الأنشطة…'),
          onChanged: onQuery,
        ),
        FilterBar(
          options: [
            for (final s in ActivityStatus.values) s.label(),
          ],
          selectedIndex: statusFilter,
          onSelected: onStatus,
        ),
      ],
    );
  }
}

/// Search + year filter row for the Reports tab. Wraps responsively on narrow
/// screens; the year filter is hidden entirely when there's only one year.
class _ReportFilterBar extends StatelessWidget {
  const _ReportFilterBar({
    required this.query,
    required this.onQuery,
    required this.years,
    required this.yearFilter,
    required this.onYear,
  });
  final String query;
  final ValueChanged<String> onQuery;
  final List<int> years;
  final int? yearFilter;
  final ValueChanged<int?> onYear;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SearchField(
          width: 240,
          hint: context.tr('Search reports…', 'ابحث عن التقارير…'),
          onChanged: onQuery,
        ),
        if (years.length > 1)
          FilterBar(
            options: [
              context.tr('All Years', 'كل السنوات'),
              for (final y in years) '$y',
            ],
            selectedIndex: yearFilter == null ? 0 : years.indexOf(yearFilter!) + 1,
            onSelected: (i) => onYear(i == 0 ? null : years[i - 1]),
          ),
      ],
    );
  }
}

/// A paginated vertical list: shows [shownCount] of [total] items with a
/// "Load more" button while more remain.
class _PagedList extends StatelessWidget {
  const _PagedList({
    required this.shownCount,
    required this.total,
    required this.onLoadMore,
    required this.itemBuilder,
  });
  final int shownCount;
  final int total;
  final VoidCallback onLoadMore;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final hasMore = total > shownCount;
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: shownCount,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: itemBuilder,
          ),
        ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: OutlinedButton.icon(
              onPressed: onLoadMore,
              icon: const Icon(Icons.expand_more, size: 18),
              label: Text(context.tr('Load more (${total - shownCount})',
                  'تحميل المزيد (${total - shownCount})')),
            ),
          ),
      ],
    );
  }
}

const List<String> _kMonthAbbrev = [
  'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
];

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.activity,
    required this.canManage,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });
  final DeptActivity activity;
  final bool canManage;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    final status = activity.statusEnum;
    final parsedDate = DateTime.tryParse(activity.date);

    return HoverLift(
      radius: AppRadius.card,
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.card,
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // A ticket-stub date badge — day (bold) over a 3-letter month.
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: status.color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: status.color.withValues(alpha: 0.3)),
                  ),
                  child: parsedDate == null
                      ? Icon(Icons.event_outlined, color: status.color)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${parsedDate.day}',
                                style: TextStyle(
                                  fontFamily: AppTypography.serif,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: status.color,
                                  height: 1.0,
                                )),
                            Text(_kMonthAbbrev[parsedDate.month - 1],
                                style: theme.textTheme.labelSmall?.copyWith(
                                    color: status.color,
                                    letterSpacing: 0.6)),
                          ],
                        ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      if (activity.attendance > 0) ...[
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.groups_outlined,
                                size: 14, color: AppColors.textFaint),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${activity.attendance} ${context.tr('attended', 'حضروا')}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: 2),
                  decoration: BoxDecoration(
                    color: status.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(status.label(isArabic),
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: status.color, fontWeight: FontWeight.w700)),
                ),
                if (canManage)
                  SizedBox(
                    height: 24,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.more_vert, size: 18),
                      onSelected: (v) {
                        if (v == 'edit') onEdit();
                        if (v == 'delete') onDelete();
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 'edit',
                            child: Text(context.trRead('Edit', 'تعديل'))),
                        PopupMenuItem(
                            value: 'delete',
                            child: Text(context.trRead('Delete', 'حذف'))),
                      ],
                    ),
                  )
                else
                  Icon(isArabic ? Icons.arrow_back : Icons.arrow_forward,
                      size: 16, color: AppColors.textFaint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════ Reports ════════════════════════════

class _ReportsTab extends StatefulWidget {
  const _ReportsTab({required this.department});
  final Department department;

  @override
  State<_ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<_ReportsTab> {
  static const _pageSize = 6;
  int _visible = _pageSize;
  String _query = '';
  int? _yearFilter;

  Department get department => widget.department;

  List<Report> _apply(List<Report> reports) {
    final q = _query.trim().toLowerCase();
    return reports.where((r) {
      final matchesQuery = q.isEmpty ||
          r.title.toLowerCase().contains(q) ||
          r.summary.toLowerCase().contains(q);
      final matchesYear = _yearFilter == null || r.year == _yearFilter;
      return matchesQuery && matchesYear;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ReportRepository>();
    final session = context.watch<SessionController>();
    final canManage = session.can?.manageReportForDepartment(
            session.user?.departmentId, department.id) ??
        false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (canManage)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton.icon(
              onPressed: () => _add(context, repo),
              icon: const Icon(Icons.add, size: 18),
              label: Text(context.tr('Add Report', 'إضافة تقرير')),
            ),
          ),
        if (canManage) const SizedBox(height: AppSpacing.md),
        Expanded(
          child: StreamBuilder<List<Report>>(
            stream: repo.watchByDepartment(department.id),
            builder: (context, snap) {
              if (!snap.hasData) return const LoadingState();
              final reports = snap.data!;
              if (reports.isEmpty) {
                return EmptyState(
                  icon: Icons.description_outlined,
                  title: context.tr('No reports yet', 'لا توجد تقارير بعد'),
                );
              }
              final years = reports.map((r) => r.year).where((y) => y > 0).toSet().toList()
                ..sort((a, b) => b - a);
              final filtered = _apply(reports);
              final shown = filtered.take(_visible).toList();
              final hasMore = filtered.length > shown.length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReportFilterBar(
                    query: _query,
                    onQuery: (v) => setState(() => _query = v),
                    years: years,
                    yearFilter: _yearFilter,
                    onYear: (y) => setState(() => _yearFilter = y),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: filtered.isEmpty
                        ? EmptyState(
                            icon: Icons.filter_alt_off_outlined,
                            title: context.tr(
                                'No matching reports', 'لا توجد تقارير مطابقة'),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              const spacing = AppSpacing.lg;
                              final columns =
                                  constraints.maxWidth > 1000 ? 2 : 1;
                              final itemWidth = (constraints.maxWidth -
                                      spacing * (columns - 1)) /
                                  columns;
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Wrap(
                                      spacing: spacing,
                                      runSpacing: spacing,
                                      children: [
                                        for (final r in shown)
                                          SizedBox(
                                            width: itemWidth,
                                            child: ReportCard(
                                              report: r,
                                              onTap: () => context.go(
                                                  '/departments/${department.id}/reports/${r.id}'),
                                              onEdit: canManage
                                                  ? () =>
                                                      _edit(context, repo, r)
                                                  : null,
                                              onDelete: canManage
                                                  ? () => _delete(
                                                      context, repo, r)
                                                  : null,
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (hasMore) ...[
                                      const SizedBox(height: AppSpacing.lg),
                                      OutlinedButton.icon(
                                        onPressed: () => setState(
                                            () => _visible += _pageSize),
                                        icon: const Icon(Icons.expand_more,
                                            size: 18),
                                        label: Text(context.tr(
                                            'Load more (${filtered.length - shown.length})',
                                            'تحميل المزيد (${filtered.length - shown.length})')),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _add(BuildContext context, ReportRepository repo) async {
    final galleryRepo = context.read<GalleryRepository>();
    final r = await showReportForm(context,
        departments: [department], lockedDepartmentId: department.id);
    if (r == null) return;
    try {
      final id = await repo.create(
        departmentId: department.id,
        title: r.title,
        summary: r.summary,
        date: r.date,
        year: r.year,
        type: r.type,
        formData: r.formData,
      );
      await galleryRepo.setAlbumForReport(
        reportId: id,
        title: r.title,
        year: r.year,
        imagePaths: r.photoPaths,
      );
      if (context.mounted) {
        showAppSnackBar(
            context, context.trRead('Report saved.', 'تم حفظ التقرير.'));
      }
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(
            context, context.trRead('Could not save report: $e',
                'تعذّر حفظ التقرير: $e'),
            tone: SnackTone.error);
      }
    }
  }

  Future<void> _edit(
      BuildContext context, ReportRepository repo, Report report) async {
    final galleryRepo = context.read<GalleryRepository>();
    final r = await showReportForm(context,
        departments: [department],
        existing: report,
        lockedDepartmentId: department.id);
    if (r == null) return;
    try {
      await repo.update(
        report.id,
        ReportsCompanion(
          title: Value(r.title),
          summary: Value(r.summary),
          date: Value(r.date),
          year: Value(r.year),
          type: Value(r.type),
          formData: Value(r.formData),
        ),
      );
      await galleryRepo.setAlbumForReport(
        reportId: report.id,
        title: r.title,
        year: r.year,
        imagePaths: r.photoPaths,
      );
      if (context.mounted) {
        showAppSnackBar(
            context, context.trRead('Report updated.', 'تم تحديث التقرير.'));
      }
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(
            context, context.trRead('Could not save report: $e',
                'تعذّر حفظ التقرير: $e'),
            tone: SnackTone.error);
      }
    }
  }

  Future<void> _delete(
      BuildContext context, ReportRepository repo, Report report) async {
    final galleryRepo = context.read<GalleryRepository>();
    final ok = await confirmDialog(context,
        title: context.trRead('Delete report?', 'حذف التقرير؟'),
        message: report.title);
    if (!ok) return;
    // Remove the linked photo album (and its files) before the report; the DB
    // cascade would drop the album row but leave the image files on disk.
    final album = await galleryRepo.getForReport(report.id);
    if (album != null) await galleryRepo.delete(album.id);
    await repo.delete(report.id);
  }
}
