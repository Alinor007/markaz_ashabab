import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/patterns/geometric_pattern.dart';
import '../../core/repositories/leader_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// A department card: patterned banner with the department icon, bilingual
/// name and description, and an optional edit/delete menu.
class DepartmentCard extends StatelessWidget {
  const DepartmentCard({
    super.key,
    required this.department,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final Department department;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  bool get _canManage => onEdit != null || onDelete != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    final accent = department.accentColor;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 96,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.md)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accent,
                              Color.alphaBlend(
                                  Colors.black.withValues(alpha: 0.25), accent),
                            ],
                          ),
                        ),
                      ),
                      const GeometricPattern(
                          color: Colors.white, opacity: 0.10, tile: 64),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Icon(department.icon,
                              size: 40,
                              color: Colors.white.withValues(alpha: 0.95)),
                        ),
                      ),
                      if (_canManage)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert,
                                color: Colors.white.withValues(alpha: 0.9),
                                size: 20),
                            onSelected: (v) {
                              if (v == 'edit') onEdit?.call();
                              if (v == 'delete') onDelete?.call();
                            },
                            itemBuilder: (context) => [
                              if (onEdit != null)
                                PopupMenuItem(
                                    value: 'edit',
                                    child: Text(context.trRead('Edit', 'تعديل'))),
                              if (onDelete != null)
                                PopupMenuItem(
                                    value: 'delete',
                                    child: Text(context.trRead('Delete', 'حذف'))),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      department.displayName(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 40,
                      child: Text(
                        department.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Divider(height: 1),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        const Icon(Icons.person_outline,
                            size: 16, color: AppColors.emerald),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          // Read the assigned Head (same source as the
                          // Department Detail screen) so both stay in sync.
                          child: StreamBuilder<List<Leader>>(
                            stream: context
                                .read<LeaderRepository>()
                                .watchByCategoryCode(
                                    'dept_head_${department.id}'),
                            builder: (context, snap) {
                              final rows = snap.data ?? const <Leader>[];
                              final head = rows.isEmpty ? null : rows.first;
                              return Text(
                                head == null
                                    ? context.tr(
                                        'No head assigned', 'بدون رئيس')
                                    : head.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall,
                              );
                            },
                          ),
                        ),
                        Icon(
                          isArabic ? Icons.arrow_back : Icons.arrow_forward,
                          size: 18,
                          color: AppColors.textFaint,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
