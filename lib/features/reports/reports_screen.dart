import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/department_repository.dart';
import '../../core/repositories/report_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/cards/report_card.dart';
import '../../widgets/common/app_dropdown.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/feedback/app_snackbar.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/skeleton.dart';
import '../../widgets/layout/module_page.dart';
import '../tarbiya/widgets/confirm_dialog.dart';
import 'report_form_dialog.dart';

/// Reports / document management: searchable, filterable (department / year /
/// type) report archive with grid & list views and role-based CRUD.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _query = '';
  String? _deptFilter;
  int? _yearFilter;
  ReportType? _typeFilter;
  bool _grid = true;

  List<Department> _departments = const [];
  Map<String, Department> _deptById = const {};

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    final depts = await context.read<DepartmentRepository>().getAll();
    if (!mounted) return;
    setState(() {
      _departments = depts;
      _deptById = {for (final d in depts) d.id: d};
    });
  }

  String _deptName(String id) =>
      _deptById[id]?.displayName(context.isArabic) ?? '—';

  List<Report> _apply(List<Report> reports) {
    return reports.where((r) {
      final q = _query.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          r.title.toLowerCase().contains(q) ||
          r.titleAr.contains(_query) ||
          _deptName(r.departmentId).toLowerCase().contains(q);
      final matchesDept = _deptFilter == null || r.departmentId == _deptFilter;
      final matchesYear = _yearFilter == null || r.year == _yearFilter;
      final matchesType = _typeFilter == null || r.typeEnum == _typeFilter;
      return matchesQuery && matchesDept && matchesYear && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ReportRepository>();
    final session = context.watch<SessionController>();
    final user = session.user;
    final userDept = user?.departmentId;
    final can = session.can;
    final canAdd = (can?.manageAllReports ?? false) ||
        (userDept != null && userDept.isNotEmpty);

    return ModulePage(
      english: 'Reports',
      arabic: 'التقارير',
      actions: [
        SearchField(
          width: 240,
          hint: context.tr('Search reports…', 'ابحث في التقارير…'),
          onChanged: (v) => setState(() => _query = v),
        ),
        _ViewToggle(grid: _grid, onChanged: (g) => setState(() => _grid = g)),
        if (canAdd)
          FilledButton.icon(
            onPressed: () => _add(context, repo, userDept,
                lockToOwn: !(can?.manageAllReports ?? false)),
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.tr('Add Report', 'إضافة تقرير')),
          ),
      ],
      child: StreamBuilder<List<Report>>(
        stream: repo.watchAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SkeletonGrid(count: 6, cardHeight: 150);
          }
          final all = snapshot.data!;
          final years = (all.map((r) => r.year).where((y) => y > 0).toSet()
                .toList()
                ..sort((a, b) => b - a));
          final filtered = _apply(all);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FilterRow(
                departments: _departments,
                years: years,
                deptFilter: _deptFilter,
                yearFilter: _yearFilter,
                typeFilter: _typeFilter,
                onDept: (v) => setState(() => _deptFilter = v),
                onYear: (v) => setState(() => _yearFilter = v),
                onType: (v) => setState(() => _typeFilter = v),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        icon: Icons.search_off,
                        title:
                            context.tr('No reports found', 'لا توجد تقارير'),
                        message: all.isEmpty && canAdd
                            ? context.tr('Add the first report.',
                                'أضف أول تقرير.')
                            : context.tr('Try adjusting your filters.',
                                'حاول تعديل عوامل التصفية.'),
                      )
                    : _grid
                        ? _GridView(
                            reports: filtered,
                            deptName: _deptName,
                            canManage: _canManageReport,
                            onEdit: (r) => _edit(context, repo, r),
                            onDelete: (r) => _delete(context, repo, r),
                          )
                        : _ListView(
                            reports: filtered,
                            deptName: _deptName,
                            canManage: _canManageReport,
                            onEdit: (r) => _edit(context, repo, r),
                            onDelete: (r) => _delete(context, repo, r),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _canManageReport(Report r) {
    final session = context.read<SessionController>();
    return session.can
            ?.manageReportForDepartment(
                session.user?.departmentId, r.departmentId) ??
        false;
  }

  Future<void> _add(BuildContext context, ReportRepository repo,
      String? userDept, {required bool lockToOwn}) async {
    final r = await showReportForm(
      context,
      departments: _departments,
      lockedDepartmentId: lockToOwn ? userDept : null,
    );
    if (r == null) return;
    await repo.create(
      departmentId: r.departmentId,
      title: r.title,
      titleAr: r.titleAr,
      summary: r.summary,
      summaryAr: r.summaryAr,
      date: r.date,
      year: r.year,
      type: r.type,
      pages: r.pages,
    );
    if (context.mounted) {
      showAppSnackBar(
          context, context.trRead('Report added.', 'تمت إضافة التقرير.'));
    }
  }

  Future<void> _edit(
      BuildContext context, ReportRepository repo, Report report) async {
    final r = await showReportForm(context,
        departments: _departments, existing: report);
    if (r == null) return;
    await repo.update(
      report.id,
      ReportsCompanion(
        departmentId: Value(r.departmentId),
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
    if (context.mounted) {
      showAppSnackBar(
          context, context.trRead('Report updated.', 'تم تحديث التقرير.'));
    }
  }

  Future<void> _delete(
      BuildContext context, ReportRepository repo, Report report) async {
    final ok = await confirmDialog(
      context,
      title: context.trRead('Delete report?', 'حذف التقرير؟'),
      message: report.title,
    );
    if (ok) {
      await repo.delete(report.id);
      if (context.mounted) {
        showAppSnackBar(
            context, context.trRead('Report deleted.', 'تم حذف التقرير.'),
            tone: SnackTone.info);
      }
    }
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.grid, required this.onChanged});
  final bool grid;
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
          _seg(context, Icons.grid_view_outlined, grid, () => onChanged(true)),
          _seg(context, Icons.view_list_outlined, !grid, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _seg(BuildContext context, IconData icon, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        color: active ? AppColors.emerald : Colors.transparent,
        child: Icon(icon,
            size: 20, color: active ? AppColors.onEmerald : AppColors.textMuted),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.departments,
    required this.years,
    required this.deptFilter,
    required this.yearFilter,
    required this.typeFilter,
    required this.onDept,
    required this.onYear,
    required this.onType,
  });
  final List<Department> departments;
  final List<int> years;
  final String? deptFilter;
  final int? yearFilter;
  final ReportType? typeFilter;
  final ValueChanged<String?> onDept;
  final ValueChanged<int?> onYear;
  final ValueChanged<ReportType?> onType;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppDropdown<String?>(
          label: context.tr('Department', 'القسم'),
          value: deptFilter,
          items: {
            null: context.tr('All Departments', 'كل الأقسام'),
            for (final d in departments) d.id: d.displayName(context.isArabic),
          },
          onChanged: onDept,
        ),
        AppDropdown<int?>(
          label: context.tr('Year', 'السنة'),
          value: yearFilter,
          items: {
            null: context.tr('All Years', 'كل السنوات'),
            for (final y in years) y: '$y',
          },
          onChanged: onYear,
        ),
        AppDropdown<ReportType?>(
          label: context.tr('Type', 'النوع'),
          value: typeFilter,
          items: {
            null: context.tr('All Types', 'كل الأنواع'),
            for (final t in ReportType.values) t: t.label(context.isArabic),
          },
          onChanged: onType,
        ),
      ],
    );
  }
}

class _GridView extends StatelessWidget {
  const _GridView({
    required this.reports,
    required this.deptName,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });
  final List<Report> reports;
  final String Function(String) deptName;
  final bool Function(Report) canManage;
  final ValueChanged<Report> onEdit;
  final ValueChanged<Report> onDelete;

  @override
  Widget build(BuildContext context) {
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
              for (final r in reports)
                SizedBox(
                  width: itemWidth,
                  child: ReportCard(
                    report: r,
                    departmentName: deptName(r.departmentId),
                    onTap: () {},
                    onEdit: canManage(r) ? () => onEdit(r) : null,
                    onDelete: canManage(r) ? () => onDelete(r) : null,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView({
    required this.reports,
    required this.deptName,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });
  final List<Report> reports;
  final String Function(String) deptName;
  final bool Function(Report) canManage;
  final ValueChanged<Report> onEdit;
  final ValueChanged<Report> onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
            ),
            child: Row(
              children: [
                Expanded(flex: 4, child: Text(context.tr('Title', 'العنوان'),
                    style: theme.textTheme.labelSmall)),
                Expanded(flex: 2, child: Text(context.tr('Department', 'القسم'),
                    style: theme.textTheme.labelSmall)),
                Expanded(flex: 2, child: Text(context.tr('Type', 'النوع'),
                    style: theme.textTheme.labelSmall)),
                Expanded(flex: 2, child: Text(context.tr('Date', 'التاريخ'),
                    style: theme.textTheme.labelSmall)),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: reports.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final r = reports[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          isArabic && r.titleAr.isNotEmpty ? r.titleAr : r.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(deptName(r.departmentId),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall)),
                      Expanded(flex: 2, child: ReportTypeBadge(type: r.typeEnum)),
                      Expanded(
                          flex: 2,
                          child: Text(r.date,
                              style: theme.textTheme.bodySmall)),
                      SizedBox(
                        width: 48,
                        child: canManage(r)
                            ? PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert, size: 18),
                                tooltip:
                                    context.tr('Report actions', 'إجراءات التقرير'),
                                onSelected: (v) {
                                  if (v == 'edit') onEdit(r);
                                  if (v == 'delete') onDelete(r);
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 'edit',
                                      child: Text(context.tr('Edit', 'تعديل'))),
                                  PopupMenuItem(
                                      value: 'delete',
                                      child: Text(context.tr('Delete', 'حذف'))),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
