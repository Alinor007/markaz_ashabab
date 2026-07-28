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
import '../../widgets/common/app_dropdown.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/feedback/app_snackbar.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import '../tarbiya/widgets/confirm_dialog.dart';

enum _Sort { nameAsc, nameDesc, newestFirst, oldestFirst }

/// Pending Members — new members await Admin review here before they become
/// visible anywhere else in the app (search, lists, pickers). Executives can
/// view the queue; only Admin can approve, decline, or delete.
class PendingMembersScreen extends StatefulWidget {
  const PendingMembersScreen({super.key});

  @override
  State<PendingMembersScreen> createState() => _PendingMembersScreenState();
}

class _PendingMembersScreenState extends State<PendingMembersScreen> {
  int _tab = 0; // 0 pending, 1 declined
  String _query = '';
  String? _areaFilter; // area id, null = all
  String? _shubaFilter; // shuba id, null = all
  int? _levelFilter; // null = all
  int _genderFilter = 0; // 0 all, 1 male, 2 female
  _Sort _sort = _Sort.newestFirst;

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

  String? _areaIdFor(Member m) => _shubaById[m.shubaId]?.areaId;

  String _locationLabel(Member m) {
    final shuba = _shubaById[m.shubaId];
    final area = shuba == null ? null : _areaById[shuba.areaId];
    final shubaName = shuba == null ? '—' : shuba.name;
    final areaName = area == null ? '—' : area.name;
    return '$areaName · $shubaName';
  }

  List<Member> _filter(List<Member> members) {
    final q = _query.trim().toLowerCase();
    final list = members.where((m) {
      final matchesQuery = q.isEmpty || m.fullName.toLowerCase().contains(q);
      final matchesArea = _areaFilter == null || _areaIdFor(m) == _areaFilter;
      final matchesShuba = _shubaFilter == null || m.shubaId == _shubaFilter;
      final matchesLevel = _levelFilter == null || m.level == _levelFilter;
      final matchesGender =
          _genderFilter == 0 ||
          (_genderFilter == 1 && m.gender == 'M') ||
          (_genderFilter == 2 && m.gender == 'F');
      return matchesQuery &&
          matchesArea &&
          matchesShuba &&
          matchesLevel &&
          matchesGender;
    }).toList();
    list.sort((a, b) {
      switch (_sort) {
        case _Sort.nameAsc:
          return a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
        case _Sort.nameDesc:
          return b.lastName.toLowerCase().compareTo(a.lastName.toLowerCase());
        case _Sort.newestFirst:
          return b.createdAt.compareTo(a.createdAt);
        case _Sort.oldestFirst:
          return a.createdAt.compareTo(b.createdAt);
      }
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return ModulePage(
        english: 'Pending Members',
        arabic: 'الأعضاء قيد الموافقة',
        child: const LoadingState(),
      );
    }

    final session = context.watch<SessionController>();
    final isAdmin = session.isAdmin;
    final repo = context.read<MemberRepository>();
    final stream = _tab == 0
        ? repo.watchPendingMembers()
        : repo.watchDeclinedMembers();

    return ModulePage(
      english: 'Pending Members',
      arabic: 'الأعضاء قيد الموافقة',
      actions: [
        SearchField(
          width: 260,
          hint: context.tr('Search name…', 'ابحث بالاسم…'),
          onChanged: (v) => setState(() => _query = v),
        ),
        if (isAdmin && _tab == 0)
          FilledButton.icon(
            onPressed: _approveAll,
            icon: const Icon(Icons.done_all, size: 18),
            label: Text(context.tr('Approve All', 'الموافقة على الجميع')),
          ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<List<Member>>(
            stream: repo.watchPendingMembers(),
            builder: (context, pendingSnap) {
              final pendingAll = pendingSnap.data ?? const [];
              return StreamBuilder<List<Member>>(
                stream: repo.watchDeclinedMembers(),
                builder: (context, declinedSnap) {
                  final declinedAll = declinedSnap.data ?? const [];
                  final currentAll = _tab == 0 ? pendingAll : declinedAll;
                  final currentShown = _filter(currentAll).length;
                  return _FilterRow(
                    shown: currentShown,
                    total: currentAll.length,
                    tab: _tab,
                    onTab: (i) => setState(() => _tab = i),
                    areas: _areas,
                    areaFilter: _areaFilter,
                    onArea: (v) => setState(() {
                      _areaFilter = v;
                      if (_shubaFilter != null &&
                          _shubaById[_shubaFilter]?.areaId != v) {
                        _shubaFilter = null;
                      }
                    }),
                    shubas: _areaFilter == null
                        ? _shubaById.values.toList()
                        : _shubaById.values
                              .where((s) => s.areaId == _areaFilter)
                              .toList(),
                    shubaFilter: _shubaFilter,
                    onShuba: (v) => setState(() => _shubaFilter = v),
                    levelFilter: _levelFilter,
                    onLevel: (v) => setState(() => _levelFilter = v),
                    genderFilter: _genderFilter,
                    onGender: (v) => setState(() => _genderFilter = v),
                    sort: _sort,
                    onSort: (s) => setState(() => _sort = s),
                  );
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: StreamBuilder<List<Member>>(
              stream: stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const LoadingState();
                final filtered = _filter(snapshot.data!);
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.how_to_reg_outlined,
                    title: _tab == 0
                        ? context.tr(
                            'No pending members',
                            'لا يوجد أعضاء قيد الانتظار',
                          )
                        : context.tr(
                            'No declined members',
                            'لا يوجد أعضاء مرفوضون',
                          ),
                    message: _tab == 0
                        ? context.tr(
                            'New members will appear here awaiting approval.',
                            'سيظهر الأعضاء الجدد هنا بانتظار الموافقة.',
                          )
                        : null,
                  );
                }
                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) => _PendingMemberCard(
                    member: filtered[i],
                    location: _locationLabel(filtered[i]),
                    isAdmin: isAdmin,
                    declined: _tab == 1,
                    onApprove: () => _approve(filtered[i]),
                    onDecline: () => _decline(filtered[i]),
                    onDelete: () => _delete(filtered[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Approves every pending member matching the current search/filters —
  /// re-fetches the pending list fresh rather than relying on the
  /// `StreamBuilder`'s last frame, so it always acts on up-to-date data.
  Future<void> _approveAll() async {
    final repo = context.read<MemberRepository>();
    final targets = _filter(await repo.watchPendingMembers().first);
    if (targets.isEmpty || !mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(dialogContext.tr('Approve all?', 'الموافقة على الجميع؟')),
        content: Text(
          dialogContext.tr(
            'Approve ${targets.length} member(s) matching the current filters?',
            'هل تريد الموافقة على ${targets.length} عضوًا وفقًا لعوامل التصفية الحالية؟',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.tr('Cancel', 'إلغاء')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.tr('Approve All', 'الموافقة على الجميع')),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    for (final m in targets) {
      await repo.setApproval(m.id, 'approved');
    }
    if (mounted) {
      showAppSnackBar(
        context,
        context.trRead(
          '${targets.length} member(s) approved.',
          'تمت الموافقة على الأعضاء.',
        ),
        tone: SnackTone.success,
      );
    }
  }

  Future<void> _approve(Member m) async {
    final repo = context.read<MemberRepository>();
    await repo.setApproval(m.id, 'approved');
    if (mounted) {
      showAppSnackBar(
        context,
        context.trRead('${m.fullName} approved.', 'تمت الموافقة على العضو.'),
        tone: SnackTone.success,
      );
    }
  }

  Future<void> _decline(Member m) async {
    final ok = await confirmDialog(
      context,
      title: context.trRead('Decline member?', 'رفض العضو؟'),
      message: context.trRead(
        '${m.fullName} will be hidden from the app until re-approved.',
        'سيُخفى العضو حتى تتم الموافقة عليه مرة أخرى.',
      ),
      confirmLabel: context.trRead('Decline', 'رفض'),
    );
    if (!ok || !mounted) return;
    final repo = context.read<MemberRepository>();
    await repo.setApproval(m.id, 'declined');
    if (mounted) {
      showAppSnackBar(
        context,
        context.trRead('${m.fullName} declined.', 'تم رفض العضو.'),
        tone: SnackTone.info,
      );
    }
  }

  Future<void> _delete(Member m) async {
    final ok = await confirmDialog(
      context,
      title: context.trRead('Delete member?', 'حذف العضو؟'),
      message: context.trRead(
        '${m.fullName} and all their records will be permanently deleted.',
        'سيُحذف العضو وجميع سجلاته نهائيًا.',
      ),
    );
    if (!ok || !mounted) return;
    final repo = context.read<MemberRepository>();
    await repo.deleteMember(m.id);
    if (mounted) {
      showAppSnackBar(
        context,
        context.trRead('Member deleted.', 'تم حذف العضو.'),
        tone: SnackTone.info,
      );
    }
  }
}

class _PendingMemberCard extends StatelessWidget {
  const _PendingMemberCard({
    required this.member,
    required this.location,
    required this.isAdmin,
    required this.declined,
    required this.onApprove,
    required this.onDecline,
    required this.onDelete,
  });

  final Member member;
  final String location;
  final bool isAdmin;
  final bool declined;
  final VoidCallback onApprove;
  final VoidCallback onDecline;
  final VoidCallback onDelete;

  String _genderLabel(BuildContext context) => member.gender == 'F'
      ? context.tr('Female', 'أنثى')
      : context.tr('Male', 'ذكر');

  String _dateLabel() {
    final d = member.createdAt;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.card,
      child: InkWell(
        borderRadius: AppRadius.card,
        onTap: () => context.go('/tarbiya/member/${member.id}'),
        child: Container(
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
                      member.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      _genderLabel(context),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 1,
                child: Text(
                  context.tr('Added ${_dateLabel()}', 'أُضيف ${_dateLabel()}'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ),
              if (isAdmin) ...[
                const SizedBox(width: AppSpacing.md),
                if (declined) ...[
                  OutlinedButton(
                    onPressed: onApprove,
                    child: Text(context.tr('Approve', 'موافقة')),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    onPressed: onDelete,
                    child: Text(context.tr('Delete', 'حذف')),
                  ),
                ] else ...[
                  FilledButton(
                    onPressed: onApprove,
                    child: Text(context.tr('Approve', 'موافقة')),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    onPressed: onDecline,
                    child: Text(context.tr('Decline', 'رفض')),
                  ),
                ],
              ],
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.chevron_right, color: AppColors.textFaint),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.shown,
    required this.total,
    required this.tab,
    required this.onTab,
    required this.areas,
    required this.areaFilter,
    required this.onArea,
    required this.shubas,
    required this.shubaFilter,
    required this.onShuba,
    required this.levelFilter,
    required this.onLevel,
    required this.genderFilter,
    required this.onGender,
    required this.sort,
    required this.onSort,
  });

  final int shown;
  final int total;
  final int tab; // 0 pending, 1 declined
  final ValueChanged<int> onTab;
  final List<TarbiyaArea> areas;
  final String? areaFilter;
  final ValueChanged<String?> onArea;
  final List<Shuba> shubas;
  final String? shubaFilter;
  final ValueChanged<String?> onShuba;
  final int? levelFilter;
  final ValueChanged<int?> onLevel;
  final int genderFilter; // 0 all, 1 male, 2 female
  final ValueChanged<int> onGender;
  final _Sort sort;
  final ValueChanged<_Sort> onSort;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _CountChip(
              label: context.tr('Showing', 'المعروض'),
              value: '$shown / $total',
              color: AppColors.navy,
            ),
            FilterBar(
              options: [
                context.tr('Pending', 'قيد الانتظار'),
                context.tr('Declined', 'مرفوض'),
              ],
              selectedIndex: tab,
              onSelected: onTab,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppDropdown<String?>(
              label: context.tr('Area', 'المنطقة'),
              value: areaFilter,
              items: {
                null: context.tr('All Areas', 'كل المناطق'),
                for (final a in areas) a.id: a.name,
              },
              onChanged: onArea,
            ),
            AppDropdown<String?>(
              label: context.tr("Shu'ba", 'الشُّعبة'),
              value: shubaFilter,
              items: {
                null: context.tr("All Shu'bas", 'كل الشُّعب'),
                for (final s in shubas) s.id: s.name,
              },
              onChanged: onShuba,
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
            _sortButton(context, theme),
          ],
        ),
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
            value: _Sort.nameAsc,
            child: Text(context.trRead('Name A–Z', 'الاسم أ–ي'))),
        PopupMenuItem(
            value: _Sort.nameDesc,
            child: Text(context.trRead('Name Z–A', 'الاسم ي–أ'))),
        PopupMenuItem(
            value: _Sort.newestFirst,
            child: Text(context.trRead('Newest first', 'الأحدث أولاً'))),
        PopupMenuItem(
            value: _Sort.oldestFirst,
            child: Text(context.trRead('Oldest first', 'الأقدم أولاً'))),
      ],
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: color),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
