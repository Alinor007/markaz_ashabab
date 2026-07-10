import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/tarbiya_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/hierarchy_breadcrumb.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';

enum _Sort { nameAsc, nameDesc, statusFirst }

/// Level 4 (list) — members assigned to a level within a Shu'ba.
class TarbiyaMemberListScreen extends StatefulWidget {
  const TarbiyaMemberListScreen({
    super.key,
    required this.areaId,
    required this.shubaId,
    required this.level,
  });

  final String areaId;
  final String shubaId;
  final int level;

  @override
  State<TarbiyaMemberListScreen> createState() =>
      _TarbiyaMemberListScreenState();
}

class _TarbiyaMemberListScreenState extends State<TarbiyaMemberListScreen> {
  String _query = '';
  _Sort _sort = _Sort.nameAsc;
  int _statusFilter = 0; // 0 all, 1 active, 2 inactive
  int _genderFilter = 0; // 0 all, 1 male, 2 female

  List<Member> _apply(List<Member> members) {
    var list = members.where((m) {
      final q = _query.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          m.fullName.toLowerCase().contains(q) ;
        
      final matchesStatus = _statusFilter == 0 ||
          (_statusFilter == 1 && m.isActive) ||
          (_statusFilter == 2 && !m.isActive);
      final matchesGender = _genderFilter == 0 ||
          (_genderFilter == 1 && m.gender == 'M') ||
          (_genderFilter == 2 && m.gender == 'F');
      return matchesQuery && matchesStatus && matchesGender;
    }).toList();
    list.sort((a, b) {
      switch (_sort) {
        case _Sort.nameAsc:
          return a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
        case _Sort.nameDesc:
          return b.lastName.toLowerCase().compareTo(a.lastName.toLowerCase());
        case _Sort.statusFirst:
          if (a.isActive == b.isActive) return a.lastName.compareTo(b.lastName);
          return a.isActive ? -1 : 1;
      }
    });
    return list;
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
          english: 'Level ${widget.level} Members',
          breadcrumb: HierarchyBreadcrumb(
            crumbs: [
              Crumb(
                label: 'Tarbiya Al-Kawadeer',
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
              Crumb(label: context.tr('Level ${widget.level}')),
            ],
          ),
          actions: [
            SearchField(
              width: 240,
              hint: 'Search members…',
              onChanged: (v) => setState(() => _query = v),
            ),
            if (canManage)
              FilledButton.icon(
                onPressed: () => context.go(
                    '/tarbiya/add-member?shuba=${widget.shubaId}&level=${widget.level}'),
                icon: const Icon(Icons.person_add_alt_1, size: 18),
                label: Text('Add Member'),
              ),
          ],
          child: StreamBuilder<List<Member>>(
            stream: repo.watchMembers(widget.shubaId, widget.level),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const LoadingState();
              final all = snapshot.data!;
              final filtered = _apply(all);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Toolbar(
                    total: all.length,
                    active: all.where((m) => m.isActive).length,
                    statusFilter: _statusFilter,
                    onStatus: (i) => setState(() => _statusFilter = i),
                    genderFilter: _genderFilter,
                    onGender: (i) => setState(() => _genderFilter = i),
                    sort: _sort,
                    onSort: (s) => setState(() => _sort = s),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: filtered.isEmpty
                        ? EmptyState(
                            icon: Icons.person_off_outlined,
                            title: all.isEmpty
                                ? 'No members in this level'
                                : 'No matches',
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppSpacing.sm),
                            itemBuilder: (context, i) =>
                                _MemberRow(member: filtered[i]),
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
    return (await repo.getArea(widget.areaId), await repo.getShuba(widget.shubaId));
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.total,
    required this.active,
    required this.statusFilter,
    required this.onStatus,
    required this.genderFilter,
    required this.onGender,
    required this.sort,
    required this.onSort,
  });
  final int total;
  final int active;
  final int statusFilter;
  final ValueChanged<int> onStatus;
  final int genderFilter;
  final ValueChanged<int> onGender;
  final _Sort sort;
  final ValueChanged<_Sort> onSort;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _Count(label: 'Total', value: total,
            color: AppColors.navy),
        const SizedBox(width: AppSpacing.sm),
        _Count(label: 'Active', value: active,
            color: AppColors.emerald),
        const SizedBox(width: AppSpacing.sm),
        _Count(label: 'Inactive', value: total - active,
            color: AppColors.textFaint),
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
                  'All',
                  'Male',
                  'Female',
                ],
                selectedIndex: genderFilter,
                onSelected: onGender,
              ),
              FilterBar(
                options: [
                  'All',
                  'Active',
                  'Inactive',
                ],
                selectedIndex: statusFilter,
                onSelected: onStatus,
              ),
              _sortButton(context, theme),
            ],
          ),
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
                Text('Sort',
                    style: theme.textTheme.labelMedium),
              ],
            ),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
                value: _Sort.nameAsc,
                child: Text('Name A–Z')),
            PopupMenuItem(
                value: _Sort.nameDesc,
                child: Text('Name Z–A')),
            PopupMenuItem(
                value: _Sort.statusFirst,
                child: Text('Active first')),
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

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member});
  final Member member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.card,
      child: InkWell(
        borderRadius: AppRadius.card,
        onTap: () => context.go('/tarbiya/member/${member.id}'),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName(isArabic),
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      style: isArabic
                          ? AppTypography.arabic(
                              fontSize: 17, fontWeight: FontWeight.w700)
                          : theme.textTheme.titleMedium,
                    ),
                    if (member.occupation.isNotEmpty)
                      Text(member.occupation, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              _StatusPill(active: member.isActive),
              const SizedBox(width: AppSpacing.md),
              Icon(isArabic ? Icons.arrow_back : Icons.arrow_forward,
                  size: 18, color: AppColors.textFaint),
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
