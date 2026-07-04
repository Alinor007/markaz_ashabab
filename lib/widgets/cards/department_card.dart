import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/patterns/geometric_pattern.dart';
import '../../core/repositories/department_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

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
                                    child: Text('Edit')),
                              if (onDelete != null)
                                PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete')),
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
                      department.displayName(isArabic),
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: isArabic
                          ? AppTypography.arabic(
                              fontSize: 20, fontWeight: FontWeight.w700)
                          : theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 40,
                      child: Text(
                        isArabic
                            ? department.descriptionAr
                            : department.description,
                        textDirection:
                            isArabic ? TextDirection.rtl : TextDirection.ltr,
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
                          // Read the assigned Head member (same source as the
                          // Department Detail screen) so both stay in sync.
                          child: StreamBuilder<Member?>(
                            stream: context
                                .read<DepartmentRepository>()
                                .watchHead(department.id),
                            builder: (context, snap) {
                              final head = snap.data;
                              return Text(
                                head == null
                                    ? 'No head assigned'
                                    : head.displayName(isArabic),
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
