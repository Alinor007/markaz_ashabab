import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/department_repository.dart';
import '../../core/repositories/report_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/cards/report_card.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/common/profile_header.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
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
      length: 3,
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
              nameAr: department.nameAr,
              subtitleEn: 'Department',
              subtitleAr: 'قسم',
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
    final isArabic = context.isArabic;
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
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: InfoPanel(
                    icon: Icons.info_outline,
                    title: context.tr('About', 'نبذة'),
                    action: editAction,
                    child: Text(
                      (isArabic ? department.descriptionAr : department.description)
                              .isEmpty
                          ? context.tr('No description provided.', 'لا يوجد وصف.')
                          : (isArabic
                              ? department.descriptionAr
                              : department.description),
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      style: isArabic
                          ? AppTypography.arabic(fontSize: 16, height: 1.9)
                          : Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  flex: 2,
                  child: InfoPanel(
                    icon: Icons.contact_mail_outlined,
                    title: context.tr('Department Head & Contact',
                        'رئيس القسم والتواصل'),
                    action: editAction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _kv(context, Icons.person_outline,
                            department.headName.isEmpty
                                ? context.tr('Not assigned', 'غير معيّن')
                                : department.headName),
                        const SizedBox(height: AppSpacing.sm),
                        _kv(context, Icons.email_outlined,
                            department.contactEmail.isEmpty
                                ? '—'
                                : department.contactEmail),
                        const SizedBox(height: AppSpacing.sm),
                        _kv(context, Icons.phone_outlined,
                            department.contactPhone.isEmpty
                                ? '—'
                                : department.contactPhone),
                      ],
                    ),
                  ),
                ),
              ],
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
                    labelArabic: 'إجمالي الأنشطة',
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
                    labelArabic: 'إجمالي التقارير',
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

  Widget _kv(BuildContext context, IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.emerald),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
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
  bool _calendar = false;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<DepartmentRepository>();
    final session = context.watch<SessionController>();
    final canManage = session.can?.manageActivityForDepartment(
            session.user?.departmentId, widget.department.id) ??
        false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Toggle(
              calendar: _calendar,
              onChanged: (c) => setState(() => _calendar = c),
            ),
            const Spacer(),
            if (canManage)
              FilledButton.icon(
                onPressed: () => _add(context, repo),
                icon: const Icon(Icons.add, size: 18),
                label: Text(context.tr('Add Activity', 'إضافة نشاط')),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: StreamBuilder<List<DeptActivity>>(
            stream: repo.watchActivities(widget.department.id),
            builder: (context, snap) {
              if (!snap.hasData) return const LoadingState();
              final items = snap.data!;
              if (items.isEmpty) {
                return EmptyState(
                  icon: Icons.event_busy_outlined,
                  title: context.tr('No activities yet', 'لا توجد أنشطة بعد'),
                );
              }
              return _calendar
                  ? _CalendarView(activities: items)
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) => _ActivityTile(
                        activity: items[i],
                        canManage: canManage,
                        onEdit: () => _edit(context, repo, items[i]),
                        onDelete: () => _delete(context, repo, items[i]),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _add(BuildContext context, DepartmentRepository repo) async {
    final r = await showActivityForm(context);
    if (r == null) return;
    await repo.addActivity(
      departmentId: widget.department.id,
      title: r.title,
      description: r.description,
      date: r.date,
      status: r.status,
      attendance: r.attendance,
    );
  }

  Future<void> _edit(
      BuildContext context, DepartmentRepository repo, DeptActivity a) async {
    final r = await showActivityForm(context, existing: a);
    if (r == null) return;
    await repo.updateActivity(a.id,
        title: r.title,
        description: r.description,
        date: r.date,
        status: r.status,
        attendance: r.attendance);
  }

  Future<void> _delete(
      BuildContext context, DepartmentRepository repo, DeptActivity a) async {
    final ok = await confirmDialog(context,
        title: context.trRead('Delete activity?', 'حذف النشاط؟'),
        message: a.title);
    if (ok) await repo.deleteActivity(a.id);
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({required this.calendar, required this.onChanged});
  final bool calendar;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _seg(context, Icons.view_list_outlined,
              context.tr('List', 'قائمة'), !calendar, () => onChanged(false)),
          _seg(context, Icons.calendar_month_outlined,
              context.tr('Calendar', 'تقويم'), calendar, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _seg(BuildContext context, IconData icon, String label, bool active,
      VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        color: active ? AppColors.emerald : Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: active ? AppColors.onEmerald : AppColors.textMuted),
            const SizedBox(width: AppSpacing.xs),
            Text(label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color:
                        active ? AppColors.onEmerald : AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.activity,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });
  final DeptActivity activity;
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = activity.statusEnum;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(Icons.event_outlined, color: status.color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: theme.textTheme.titleSmall),
                Text(
                  [
                    activity.date,
                    if (activity.attendance > 0)
                      '${activity.attendance} ${context.tr('attended', 'حضروا')}'
                  ].where((s) => s.isNotEmpty).join(' · '),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 2),
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(status.label(context.isArabic),
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: status.color, fontWeight: FontWeight.w700)),
          ),
          if (canManage)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 18),
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Text(context.trRead('Edit', 'تعديل'))),
                PopupMenuItem(
                    value: 'delete', child: Text(context.trRead('Delete', 'حذف'))),
              ],
            ),
        ],
      ),
    );
  }
}

/// A lightweight calendar: activities grouped by month.
class _CalendarView extends StatelessWidget {
  const _CalendarView({required this.activities});
  final List<DeptActivity> activities;

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<DeptActivity>>{};
    for (final a in activities) {
      final key = a.date.isEmpty
          ? context.tr('Undated', 'بدون تاريخ')
          : a.date.substring(0, a.date.length >= 7 ? 7 : a.date.length);
      groups.putIfAbsent(key, () => []).add(a);
    }
    final keys = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    return ListView(
      children: [
        for (final key in keys) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(key, style: Theme.of(context).textTheme.titleSmall),
          ),
          for (final a in groups[key]!)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        color: a.statusEnum.color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(a.title)),
                  Text(a.date, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

// ════════════════════════════ Reports ════════════════════════════

class _ReportsTab extends StatelessWidget {
  const _ReportsTab({required this.department});
  final Department department;

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
              return LayoutBuilder(
                builder: (context, constraints) {
                  const spacing = AppSpacing.lg;
                  final columns = constraints.maxWidth > 1000 ? 2 : 1;
                  final itemWidth = (constraints.maxWidth -
                          spacing * (columns - 1)) /
                      columns;
                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (final r in reports)
                          SizedBox(
                            width: itemWidth,
                            child: ReportCard(
                              report: r,
                              departmentName:
                                  department.displayName(context.isArabic),
                              onTap: () {},
                              onEdit: canManage
                                  ? () => _edit(context, repo, r)
                                  : null,
                              onDelete: canManage
                                  ? () => _delete(context, repo, r)
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
        ),
      ],
    );
  }

  Future<void> _add(BuildContext context, ReportRepository repo) async {
    final r = await showReportForm(context,
        departments: [department], lockedDepartmentId: department.id);
    if (r == null) return;
    await repo.create(
      departmentId: department.id,
      title: r.title,
      titleAr: r.titleAr,
      summary: r.summary,
      summaryAr: r.summaryAr,
      date: r.date,
      year: r.year,
      type: r.type,
      pages: r.pages,
    );
  }

  Future<void> _edit(
      BuildContext context, ReportRepository repo, Report report) async {
    final r = await showReportForm(context,
        departments: [department],
        existing: report,
        lockedDepartmentId: department.id);
    if (r == null) return;
    await repo.update(
      report.id,
      ReportsCompanion(
        title: Value(r.title),
        titleAr: Value(r.titleAr),
        summary: Value(r.summary),
        summaryAr: Value(r.summaryAr),
        date: Value(r.date),
        year: Value(r.year),
        type: Value(r.type),
        pages: Value(r.pages),
      ),
    );
  }

  Future<void> _delete(
      BuildContext context, ReportRepository repo, Report report) async {
    final ok = await confirmDialog(context,
        title: context.trRead('Delete report?', 'حذف التقرير؟'),
        message: report.title);
    if (ok) await repo.delete(report.id);
  }
}
