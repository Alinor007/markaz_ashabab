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
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import 'add_class_dialog.dart';

enum _Sort { teacherAsc, sectionAsc, studentsDesc }

/// The tutorial classes of one shu'ba level — members grouped by shared
/// Naqib (teacher) + section. Tapping a class pushes the read-only Tutorial
/// Class Information screen.
class TarbiyaClassesScreen extends StatefulWidget {
  const TarbiyaClassesScreen({
    super.key,
    required this.areaId,
    required this.shubaId,
    required this.level,
  });

  final String areaId;
  final String shubaId;
  final int level;

  @override
  State<TarbiyaClassesScreen> createState() => _TarbiyaClassesScreenState();
}

class _TarbiyaClassesScreenState extends State<TarbiyaClassesScreen> {
  /// Sentinel for the "All sections" entry in the section filter menu (real
  /// sections are trimmed user text and never collide with it in practice).
  static const _allSections = '__all__';

  String _query = '';
  _Sort _sort = _Sort.teacherAsc;
  int _genderFilter = 0; // 0 all, 1 male, 2 female — by the teacher's gender.
  String _sectionFilter = _allSections;

  List<TutorialClass> _apply(List<TutorialClass> classes) {
    final q = _query.trim().toLowerCase();
    var list = classes.where((c) {
      final matchesQuery = q.isEmpty ||
          c.teacher.fullName.toLowerCase().contains(q) ||
          c.section.toLowerCase().contains(q);
      final matchesGender = _genderFilter == 0 ||
          (_genderFilter == 1 && c.teacher.gender == 'M') ||
          (_genderFilter == 2 && c.teacher.gender == 'F');
      final matchesSection =
          _sectionFilter == _allSections || c.section == _sectionFilter;
      return matchesQuery && matchesGender && matchesSection;
    }).toList();
    list.sort((a, b) {
      switch (_sort) {
        case _Sort.teacherAsc:
          final byTeacher = a.teacher.fullName
              .toLowerCase()
              .compareTo(b.teacher.fullName.toLowerCase());
          return byTeacher != 0
              ? byTeacher
              : a.section.compareTo(b.section);
        case _Sort.sectionAsc:
          final bySection =
              a.section.toLowerCase().compareTo(b.section.toLowerCase());
          return bySection != 0
              ? bySection
              : a.teacher.fullName.compareTo(b.teacher.fullName);
        case _Sort.studentsDesc:
          return b.students.length.compareTo(a.students.length);
      }
    });
    return list;
  }

  void _openClass(TutorialClass c) {
    final url = Uri(
      path:
          '/tarbiya/area/${widget.areaId}/shuba/${widget.shubaId}/level/${widget.level}/class-info',
      queryParameters: {'naqib': c.teacher.id, 'section': c.section},
    ).toString();
    // Pushed (not go) so Back returns to this Class Screen.
    context.push(url);
  }

  Future<void> _addClass() async {
    await showAddClassDialog(
      context,
      memberRepo: context.read<MemberRepository>(),
      shubaId: widget.shubaId,
      level: widget.level,
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<TarbiyaRepository>();
    final canManage =
        context.read<SessionController>().can?.manageTarbiya ?? false;

    return FutureBuilder<(TarbiyaArea?, Shuba?)>(
      future: _loadContext(repo),
      builder: (context, ctxSnap) {
        final area = ctxSnap.data?.$1;
        final shuba = ctxSnap.data?.$2;
        return ModulePage(
          english: 'Level ${widget.level} Classes',
          breadcrumb: HierarchyBreadcrumb(
            crumbs: [
              Crumb(
                label: context.tr('Tarbiya Al-Kawadeer', 'تربية الكوادر'),
                route: '/tarbiya',
                icon: Icons.hub_outlined,
              ),
              if (area != null)
                Crumb(
                    label: area.name,
                    route: '/tarbiya/area/${widget.areaId}'),
              if (shuba != null)
                Crumb(
                    label: shuba.name,
                    route:
                        '/tarbiya/area/${widget.areaId}/shuba/${widget.shubaId}'),
              Crumb(
                  label: context.tr('Level ${widget.level} Classes',
                      'فصول المستوى ${widget.level}')),
            ],
          ),
          actions: [
            SearchField(
              width: 240,
              hint: context.tr('Search classes…', 'ابحث عن الفصول…'),
              onChanged: (v) => setState(() => _query = v),
            ),
            if (canManage)
              FilledButton.icon(
                onPressed: _addClass,
                icon: const Icon(Icons.add, size: 18),
                label: Text(context.tr('Add Class', 'إضافة فصل')),
              ),
          ],
          child: StreamBuilder<List<TutorialClass>>(
            stream: repo.watchClasses(widget.shubaId, widget.level),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const LoadingState();
              final all = snapshot.data!;
              final filtered = _apply(all);
              final sections =
                  all.map((c) => c.section).toSet().toList()..sort();
              final totalStudents =
                  all.fold<int>(0, (sum, c) => sum + c.students.length);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Toolbar(
                    classes: all.length,
                    students: totalStudents,
                    sections: sections.length,
                    sectionOptions: sections,
                    sectionFilter: _sectionFilter,
                    onSection: (s) => setState(() => _sectionFilter = s),
                    genderFilter: _genderFilter,
                    onGender: (i) => setState(() => _genderFilter = i),
                    sort: _sort,
                    onSort: (s) => setState(() => _sort = s),
                    allSectionsValue: _allSections,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: filtered.isEmpty
                        ? EmptyState(
                            icon: Icons.school_outlined,
                            title: all.isEmpty
                                ? context.tr('No classes in this level',
                                    'لا فصول في هذا المستوى')
                                : context.tr('No matches', 'لا توجد نتائج'),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppSpacing.sm),
                            itemBuilder: (context, i) => _ClassRow(
                              tutorialClass: filtered[i],
                              onTap: () => _openClass(filtered[i]),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<(TarbiyaArea?, Shuba?)> _loadContext(TarbiyaRepository repo) async {
    return (
      await repo.getArea(widget.areaId),
      await repo.getShuba(widget.shubaId)
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.classes,
    required this.students,
    required this.sections,
    required this.sectionOptions,
    required this.sectionFilter,
    required this.onSection,
    required this.genderFilter,
    required this.onGender,
    required this.sort,
    required this.onSort,
    required this.allSectionsValue,
  });

  final int classes;
  final int students;
  final int sections;
  final List<String> sectionOptions;
  final String sectionFilter;
  final ValueChanged<String> onSection;
  final int genderFilter;
  final ValueChanged<int> onGender;
  final _Sort sort;
  final ValueChanged<_Sort> onSort;
  final String allSectionsValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Count(
            label: context.tr('Classes', 'فصول'),
            value: classes,
            color: AppColors.navy),
        const SizedBox(width: AppSpacing.sm),
        _Count(
            label: context.tr('Students', 'طلاب'),
            value: students,
            color: AppColors.emerald),
        const SizedBox(width: AppSpacing.sm),
        _Count(
            label: context.tr('Sections', 'أقسام'),
            value: sections,
            color: AppColors.goldDeep),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilterBar(
                options: [
                  context.tr('All', 'الكل'),
                  context.tr('Male', 'ذكر'),
                  context.tr('Female', 'أنثى'),
                ],
                selectedIndex: genderFilter,
                onSelected: onGender,
              ),
              _sectionButton(context, theme),
              _sortButton(context, theme),
            ],
          ),
        ),
      ],
    );
  }

  String _sectionLabel(BuildContext context, String section) =>
      section == allSectionsValue
          ? context.tr('All sections', 'كل الأقسام')
          : section.isEmpty
              ? context.tr('(No section)', '(بدون قسم)')
              : section;

  Widget _sectionButton(BuildContext context, ThemeData theme) {
    return PopupMenuButton<String>(
      initialValue: sectionFilter,
      onSelected: onSection,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_alt_outlined,
                size: 16, color: AppColors.textMuted),
            const SizedBox(width: AppSpacing.xs),
            Text(_sectionLabel(context, sectionFilter),
                style: theme.textTheme.labelMedium),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: allSectionsValue,
            child: Text(context.trRead('All sections', 'كل الأقسام'))),
        for (final s in sectionOptions)
          PopupMenuItem(value: s, child: Text(_sectionLabel(context, s))),
      ],
    );
  }

  Widget _sortButton(BuildContext context, ThemeData theme) {
    return PopupMenuButton<_Sort>(
      initialValue: sort,
      onSelected: onSort,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort, size: 16, color: AppColors.textMuted),
            const SizedBox(width: AppSpacing.xs),
            Text(context.tr('Sort', 'ترتيب'), style: theme.textTheme.labelMedium),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: _Sort.teacherAsc,
            child: Text(context.trRead('Teacher A–Z', 'المعلم أ–ي'))),
        PopupMenuItem(
            value: _Sort.sectionAsc,
            child: Text(context.trRead('Section A–Z', 'القسم أ–ي'))),
        PopupMenuItem(
            value: _Sort.studentsDesc,
            child: Text(context.trRead('Most students', 'الأكثر طلاباً'))),
      ],
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.label, required this.value, required this.color});
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Text('$value',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: color)),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _ClassRow extends StatelessWidget {
  const _ClassRow({required this.tutorialClass, required this.onTap});
  final TutorialClass tutorialClass;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final teacher = tutorialClass.teacher;
    final section = tutorialClass.section;
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.card,
      child: InkWell(
        borderRadius: AppRadius.card,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              PortraitAvatar(
                  initials: teacher.initials,
                  imagePath: teacher.photoPath,
                  size: 48),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(teacher.displayName(context.isArabic),
                        style: theme.textTheme.titleMedium),
                    Text(
                      section.isEmpty
                          ? context.tr('(No section)', '(بدون قسم)')
                          : section,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: section.isEmpty
                              ? AppColors.textFaint
                              : AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              _Tag(
                label: teacher.gender == 'F'
                    ? context.tr('Female', 'أنثى')
                    : context.tr('Male', 'ذكر'),
                color:
                    teacher.gender == 'F' ? AppColors.goldDeep : AppColors.navy,
              ),
              const SizedBox(width: AppSpacing.sm),
              _Tag(
                label: context.tr(
                    '${tutorialClass.students.length} students',
                    '${tutorialClass.students.length} طالباً'),
                color: AppColors.emerald,
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(Icons.arrow_forward,
                  size: 18, color: AppColors.textFaint),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
