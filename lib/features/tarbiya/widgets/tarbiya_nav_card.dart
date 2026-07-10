import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';

/// A tappable hierarchy card (Area / Shu'ba) with optional edit/delete actions
/// and a stats footer.
class TarbiyaNavCard extends StatelessWidget {
  const TarbiyaNavCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.accent = AppColors.emerald,
    this.stats = const [],
    this.onEdit,
    this.onDelete,
    this.footer,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color accent;
  final VoidCallback onTap;
  final List<({IconData icon, String value, String label})> stats;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  /// Optional footer below the stats (e.g. a Shu'ba's Mas'ul row).
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                    child: Icon(icon, color: accent, size: 24),
                  ),
                  const Spacer(),
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert,
                          color: AppColors.textMuted, size: 20),
                      tooltip: 'Actions',
                      onSelected: (v) {
                        if (v == 'edit') onEdit?.call();
                        if (v == 'delete') onDelete?.call();
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                        if (onDelete != null)
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                      ],
                    )
                  else
                    Icon( Icons.arrow_forward,
                        size: 18, color: AppColors.textFaint),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                textDirection: TextDirection.ltr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
              if (subtitle != null)
                Text(subtitle!, style: theme.textTheme.bodySmall),
              if (stats.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    for (final s in stats) ...[
                      Icon(s.icon, size: 16, color: accent),
                      const SizedBox(width: AppSpacing.xs),
                      Text(s.value, style: theme.textTheme.titleSmall),
                      const SizedBox(width: AppSpacing.xs),
                      Text(s.label, style: theme.textTheme.bodySmall),
                      const SizedBox(width: AppSpacing.lg),
                    ],
                  ],
                ),
              ],
              if (footer != null) ...[
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.sm),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Responsive wrapping grid used by the Tarbiya hierarchy screens.
class TarbiyaCardGrid extends StatelessWidget {
  const TarbiyaCardGrid({super.key, required this.children, this.minColumns = 2});
  final List<Widget> children;
  final int minColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = AppSpacing.lg;
        final columns = constraints.maxWidth > 1100
            ? 3
            : AppLayout.gridColumns(constraints.maxWidth).clamp(minColumns, 3);
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return SingleChildScrollView(
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final child in children)
                SizedBox(width: itemWidth, child: child),
            ],
          ),
        );
      },
    );
  }
}
