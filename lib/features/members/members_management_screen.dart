import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/repositories/tarbiya_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/app_dropdown.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/feedback/app_snackbar.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import '../tarbiya/widgets/confirm_dialog.dart';

/// Members Management — a directory of every member across all shu'bas with
/// search, filtering, pagination, and full CRUD. Executive-only (the route is
/// guarded in the router; the sidebar entry is gated too).
class MembersManagementScreen extends StatefulWidget {
  const MembersManagementScreen({super.key});

  @override
  State<MembersManagementScreen> createState() =>
      _MembersManagementScreenState();
}

class _MembersManagementScreenState extends State<MembersManagementScreen> {
  static const _pageSize = 12;

  String _query = '';
  int _statusFilter = 0; // 0 all, 1 active, 2 inactive
  String? _areaFilter; // area id, null = all
  int? _levelFilter; // null = all
  int _genderFilter = 0; // 0 all, 1 male, 2 female
  int _page = 0;

  bool _ready = false;
  List<TarbiyaArea> _areas = const [];
  Map<String, TarbiyaArea> _areaById = const {};
  Map<String, Shuba> _shubaById = const {};

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final repo = context.read<TarbiyaRepository>();
    final areas = await repo.getAreas();
    final shubas = await repo.getAllShubas();
    if (!mounted) return;
    setState(() {
      _areas = areas;
      _areaById = {for (final a in areas) a.id: a};
      _shubaById = {for (final s in shubas) s.id: s};
      _ready = true;
    });
  }

  /// Reset to the first page whenever the filter set changes.
  void _resetPage() => _page = 0;

  String? _areaIdFor(Member m) => _shubaById[m.shubaId]?.areaId;

  String _locationLabel(Member m, bool isArabic) {
    final shuba = _shubaById[m.shubaId];
    final area = shuba == null ? null : _areaById[shuba.areaId];
    final shubaName = shuba == null ? '—' : shuba.name;
    final areaName = area == null ? '—' : area.name;
    return '$areaName · $shubaName';
  }

  List<Member> _apply(List<Member> members) {
    final q = _query.trim().toLowerCase();
    final list = members.where((m) {
      final matchesQuery = q.isEmpty ||
          m.fullName.toLowerCase().contains(q) ||
          m.occupation.toLowerCase().contains(q) ||
          m.contactNumber.contains(_query);
      final matchesStatus = _statusFilter == 0 ||
          (_statusFilter == 1 && m.isActive) ||
          (_statusFilter == 2 && !m.isActive);
      final matchesArea = _areaFilter == null || _areaIdFor(m) == _areaFilter;
      final matchesLevel = _levelFilter == null || m.level == _levelFilter;
      final matchesGender = _genderFilter == 0 ||
          (_genderFilter == 1 && m.gender == 'M') ||
          (_genderFilter == 2 && m.gender == 'F');
      return matchesQuery && matchesStatus && matchesArea && matchesLevel && matchesGender;
    }).toList()
      ..sort((a, b) =>
          a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase()));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return ModulePage(
        english: 'Members Management',
        arabic: 'إدارة الأعضاء',
        child: const LoadingState(),
      );
    }

    return ModulePage(
      english: 'Members Management',
      arabic: 'إدارة الأعضاء',
      actions: [
        SearchField(
          width: 260,
          hint: context.tr('Search name, occupation, contact…',
              'ابحث بالاسم أو المهنة أو رقم التواصل…'),
          onChanged: (v) => setState(() {
            _query = v;
            _resetPage();
          }),
        ),
        FilledButton.icon(
          onPressed: _addMember,
          icon: const Icon(Icons.person_add_alt_1, size: 18),
          label: Text(context.tr('Add Member', 'إضافة عضو')),
        ),
      ],
      child: StreamBuilder<List<Member>>(
        stream: context.read<MemberRepository>().watchAllMembers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LoadingState();
          final all = snapshot.data!;
          final filtered = _apply(all);

          final pageCount =
              filtered.isEmpty ? 1 : (filtered.length / _pageSize).ceil();
          if (_page >= pageCount) _page = pageCount - 1;
          final start = _page * _pageSize;
          final pageItems =
              filtered.skip(start).take(_pageSize).toList(growable: false);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FilterRow(
                total: all.length,
                shown: filtered.length,
                statusFilter: _statusFilter,
                onStatus: (i) => setState(() {
                  _statusFilter = i;
                  _resetPage();
                }),
                areas: _areas,
                areaFilter: _areaFilter,
                onArea: (v) => setState(() {
                  _areaFilter = v;
                  _resetPage();
                }),
                levelFilter: _levelFilter,
                onLevel: (v) => setState(() {
                  _levelFilter = v;
                  _resetPage();
                }),
                genderFilter: _genderFilter,
                onGender: (v) => setState(() {
                  _genderFilter = v;
                  _resetPage();
                }),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        icon: Icons.person_off_outlined,
                        title: all.isEmpty
                            ? context.tr('No members yet', 'لا يوجد أعضاء بعد')
                            : context.tr('No matches', 'لا توجد نتائج'),
                        message: all.isEmpty
                            ? context.tr('Add the first member to begin.',
                                'أضف أول عضو للبدء.')
                            : context.tr('Try adjusting your filters.',
                                'حاول تعديل عوامل التصفية.'),
                      )
                    : ListView.separated(
                        itemCount: pageItems.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) => _MemberRow(
                          member: pageItems[i],
                          location: _locationLabel(pageItems[i], context.isArabic),
                          onView: () =>
                              context.go('/tarbiya/member/${pageItems[i].id}'),
                          onEdit: () => context
                              .go('/tarbiya/member/${pageItems[i].id}/edit'),
                          onDelete: () => _deleteMember(pageItems[i]),
                        ),
                      ),
              ),
              if (filtered.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                _Pagination(
                  page: _page,
                  pageCount: pageCount,
                  start: start + 1,
                  end: start + pageItems.length,
                  total: filtered.length,
                  onPrev:
                      _page > 0 ? () => setState(() => _page--) : null,
                  onNext: _page < pageCount - 1
                      ? () => setState(() => _page++)
                      : null,
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _addMember() async {
    final picked = await showDialog<({String shubaId, int level})>(
      context: context,
      builder: (_) => _AddLocationDialog(
        areas: _areas,
        shubasFor: (areaId) =>
            _shubaById.values.where((s) => s.areaId == areaId).toList(),
      ),
    );
    if (picked == null) return;
    if (!mounted) return;
    context.go(
        '/tarbiya/add-member?shuba=${picked.shubaId}&level=${picked.level}');
  }

  Future<void> _deleteMember(Member m) async {
    final repo = context.read<MemberRepository>();
    final ok = await confirmDialog(
      context,
      title: context.trRead('Delete member?', 'حذف العضو؟'),
      message: context.trRead(
        '${m.fullName} and all their records will be permanently deleted.',
        'سيُحذف ${m.displayName(true)} وجميع سجلاته نهائيًا.',
      ),
    );
    if (!ok) return;
    await repo.deleteMember(m.id);
    if (mounted) {
      showAppSnackBar(context, context.trRead('Member deleted.', 'تم حذف العضو.'),
          tone: SnackTone.info);
    }
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.total,
    required this.shown,
    required this.statusFilter,
    required this.onStatus,
    required this.areas,
    required this.areaFilter,
    required this.onArea,
    required this.levelFilter,
    required this.onLevel,
    required this.genderFilter,
    required this.onGender,
  });

  final int total;
  final int shown;
  final int statusFilter;
  final ValueChanged<int> onStatus;
  final List<TarbiyaArea> areas;
  final String? areaFilter;
  final ValueChanged<String?> onArea;
  final int? levelFilter;
  final ValueChanged<int?> onLevel;
  final int genderFilter; // 0 all, 1 male, 2 female
  final ValueChanged<int> onGender;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _CountChip(
            label: context.tr('Showing', 'المعروض'),
            value: '$shown / $total',
            color: AppColors.navy),
        FilterBar(
          options: [
            context.tr('All', 'الكل'),
            context.tr('Active', 'نشط'),
            context.tr('Inactive', 'غير نشط'),
          ],
          selectedIndex: statusFilter,
          onSelected: onStatus,
        ),
        AppDropdown<String?>(
          label: context.tr('Area', 'المنطقة'),
          value: areaFilter,
          items: {
            null: context.tr('All Areas', 'كل المناطق'),
            for (final a in areas) a.id: a.name,
          },
          onChanged: onArea,
        ),
        AppDropdown<int?>(
          label: context.tr('Level', 'المستوى'),
          value: levelFilter,
          items: {
            null: context.tr('All Levels', 'كل المستويات'),
            for (final l in kTarbiyaLevels)
              l: context.tr('Level $l', 'المستوى $l'),
          },
          onChanged: onLevel,
        ),
        AppDropdown<int>(
          label: context.tr('Gender', 'الجنس'),
          value: genderFilter,
          items: {
            0: context.tr('All Genders', 'كل الأجناس'),
            1: context.tr('Male', 'ذكر'),
            2: context.tr('Female', 'أنثى'),
          },
          onChanged: onGender,
        ),
      ],
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip(
      {required this.label, required this.value, required this.color});
  final String label;
  final String value;
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: color)),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.member,
    required this.location,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final Member member;
  final String location;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.card,
      child: InkWell(
        borderRadius: AppRadius.card,
        onTap: onView,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              PortraitAvatar(initials: member.initials, size: 48),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName(isArabic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      style: isArabic
                          ? AppTypography.arabic(
                              fontSize: 17, fontWeight: FontWeight.w700)
                          : theme.textTheme.titleMedium,
                    ),
                    if (member.occupation.isNotEmpty)
                      Text(member.occupation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: Text(location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall),
              ),
              const SizedBox(width: AppSpacing.md),
              _LevelChip(level: member.level),
              const SizedBox(width: AppSpacing.md),
              _StatusPill(active: member.isActive),
              const SizedBox(width: AppSpacing.sm),
              PopupMenuButton<String>(
                tooltip: context.tr('Member actions', 'إجراءات العضو'),
                icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
                onSelected: (v) {
                  switch (v) {
                    case 'view':
                      onView();
                    case 'edit':
                      onEdit();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'view',
                    child: _MenuRow(
                        icon: Icons.visibility_outlined,
                        label: context.trRead('View Profile', 'عرض الملف')),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: _MenuRow(
                        icon: Icons.edit_outlined,
                        label: context.trRead('Edit', 'تعديل')),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: _MenuRow(
                        icon: Icons.delete_outline,
                        label: context.trRead('Delete', 'حذف'),
                        danger: true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.level});
  final int level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        level <= 0 ? '—' : context.tr('L$level', 'م$level'),
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.emerald : AppColors.textFaint;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        active ? context.tr('Active', 'نشط') : context.tr('Inactive', 'غير نشط'),
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow(
      {required this.icon, required this.label, this.danger = false});
  final IconData icon;
  final String label;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.charcoal;
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSpacing.md),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination({
    required this.page,
    required this.pageCount,
    required this.start,
    required this.end,
    required this.total,
    required this.onPrev,
    required this.onNext,
  });

  final int page;
  final int pageCount;
  final int start;
  final int end;
  final int total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          context.tr('$start–$end of $total', '$start–$end من $total'),
          style: theme.textTheme.bodySmall,
        ),
        const Spacer(),
        IconButton(
          onPressed: onPrev,
          tooltip: context.tr('Previous', 'السابق'),
          icon: Icon(context.isArabic ? Icons.chevron_right : Icons.chevron_left),
        ),
        Text(
          context.tr('Page ${page + 1} of $pageCount',
              'صفحة ${page + 1} من $pageCount'),
          style: theme.textTheme.labelMedium,
        ),
        IconButton(
          onPressed: onNext,
          tooltip: context.tr('Next', 'التالي'),
          icon: Icon(context.isArabic ? Icons.chevron_left : Icons.chevron_right),
        ),
      ],
    );
  }
}

/// Picks an Area → Shu'ba → Level for a new member, since the Members
/// Management directory adds across the whole hierarchy.
class _AddLocationDialog extends StatefulWidget {
  const _AddLocationDialog({required this.areas, required this.shubasFor});

  final List<TarbiyaArea> areas;
  final List<Shuba> Function(String areaId) shubasFor;

  @override
  State<_AddLocationDialog> createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends State<_AddLocationDialog> {
  String? _areaId;
  String? _shubaId;
  int _level = 1;

  @override
  Widget build(BuildContext context) {
    final shubas = _areaId == null ? <Shuba>[] : widget.shubasFor(_areaId!);

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(context.tr('Add Member — Location', 'إضافة عضو — الموقع')),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.tr('Choose where this member belongs.',
                  'اختر الموقع الذي ينتمي إليه هذا العضو.'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<String>(
              initialValue: _areaId,
              isExpanded: true,
              decoration:
                  InputDecoration(labelText: context.tr('Area', 'المنطقة')),
              items: [
                for (final a in widget.areas)
                  DropdownMenuItem(value: a.id, child: Text(a.name)),
              ],
              onChanged: (v) => setState(() {
                _areaId = v;
                _shubaId = null;
              }),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _shubaId,
              isExpanded: true,
              decoration:
                  InputDecoration(labelText: context.tr("Shu'ba", 'الشُّعبة')),
              items: [
                for (final s in shubas)
                  DropdownMenuItem(value: s.id, child: Text(s.name)),
              ],
              onChanged: _areaId == null
                  ? null
                  : (v) => setState(() => _shubaId = v),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<int>(
              initialValue: _level,
              isExpanded: true,
              decoration:
                  InputDecoration(labelText: context.tr('Level', 'المستوى')),
              items: [
                for (final l in kTarbiyaLevels)
                  DropdownMenuItem(
                      value: l,
                      child: Text(context.tr('Level $l', 'المستوى $l'))),
              ],
              onChanged: (v) => setState(() => _level = v ?? 1),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.tr('Cancel', 'إلغاء')),
        ),
        FilledButton(
          onPressed: _shubaId == null
              ? null
              : () => Navigator.of(context)
                  .pop((shubaId: _shubaId!, level: _level)),
          child: Text(context.tr('Continue', 'متابعة')),
        ),
      ],
    );
  }
}
