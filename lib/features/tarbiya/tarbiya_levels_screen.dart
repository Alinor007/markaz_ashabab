import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/repositories/tarbiya_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/hierarchy_breadcrumb.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import 'widgets/tarbiya_nav_card.dart';

/// Level 3 — the five tarbiya levels for a Shu'ba, with member counts.
class TarbiyaLevelsScreen extends StatelessWidget {
  const TarbiyaLevelsScreen({
    super.key,
    required this.areaId,
    required this.shubaId,
  });

  final String areaId;
  final String shubaId;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<TarbiyaRepository>();

    return FutureBuilder<(TarbiyaArea?, Shuba?)>(
      future: _loadContext(repo),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const ModulePage(
              english: 'Levels',  child: LoadingState());
        }
        final area = snap.data?.$1;
        final shuba = snap.data?.$2;
        if (area == null || shuba == null) {
          return ModulePage(
            english: 'Levels',
            child: EmptyState(
              icon: Icons.layers_outlined,
              title: 'Shu\'ba not found',
            ),
          );
        }
  
        return ModulePage(
          english: shuba.name,
          breadcrumb: HierarchyBreadcrumb(
            crumbs: [
              Crumb(
                label: 'Tarbiya Al-Kawadeer',
                route: '/tarbiya',
                icon: Icons.hub_outlined,
              ),
              Crumb(
                  label: area.name,
                  route: '/tarbiya/area/$areaId'),
              Crumb(label: shuba.name)
            ],
          ),
          child: StreamBuilder<Map<int, LevelCounts>>(
            stream: repo.watchLevelCounts(shubaId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const LoadingState();
              final counts = snapshot.data!;
              return TarbiyaCardGrid(
                children: [
                  for (final level in [1, 2, 3, 4, 5])
                    _LevelCard(
                      level: level,
                      counts: counts[level] ?? const LevelCounts(),
                      onTap: () => context.go(
                          '/tarbiya/area/$areaId/shuba/$shubaId/level/$level'),
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
    final area = await repo.getArea(areaId);
    final shuba = await repo.getShuba(shubaId);
    return (area, shuba);
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.counts,
    required this.onTap,
  });
  final int level;
  final LevelCounts counts;
  final VoidCallback onTap;

  static const _accents = [
    AppColors.emerald,
    AppColors.navy,
    AppColors.goldDeep,
    AppColors.emeraldDark,
    AppColors.info,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = _accents[(level - 1) % _accents.length];
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
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    alignment: Alignment.center,
                    child: Text('$level',
                        style: AppTypography.textTheme.titleLarge
                            ?.copyWith(color: accent)),
                  ),
                  const Spacer(),
                  Text('${counts.total}',
                      style: theme.textTheme.displaySmall
                          ?.copyWith(color: accent)),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Level $level',
                  style: theme.textTheme.titleLarge),
              Text('members',
                  style: theme.textTheme.bodySmall),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  _Pill(
                      color: AppColors.emerald,
                      label: 'Active',
                      value: counts.active),
                  const SizedBox(width: AppSpacing.sm),
                  _Pill(
                      color: AppColors.textFaint,
                      label: 'Inactive',
                      value: counts.inactive),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.color, required this.label, required this.value});
  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text('$value $label',
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: color, fontWeight: FontWeight.w700)),
    );
  }
}
