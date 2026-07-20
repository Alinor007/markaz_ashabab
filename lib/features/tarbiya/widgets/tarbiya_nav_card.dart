import 'package:flutter/material.dart';

import '../../../core/i18n/localized.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';

/// A tappable hierarchy card (Area / Shu'ba) — chrome only. Each screen
/// composes its own header/stats/footer layout inside [child].
class TarbiyaNavCard extends StatelessWidget {
  const TarbiyaNavCard({super.key, required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
          child: child,
        ),
      ),
    );
  }
}

/// The three-dot actions menu shared by the Area/Shu'ba cards. Falls back to
/// a plain forward arrow when neither action is available.
class TarbiyaCardMenu extends StatelessWidget {
  const TarbiyaCardMenu({super.key, this.onEdit, this.onDelete});

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    if (onEdit == null && onDelete == null) {
      return const Icon(Icons.arrow_forward,
          size: 18, color: AppColors.textFaint);
    }
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.textMuted, size: 20),
      tooltip: context.tr('Actions', 'إجراءات'),
      onSelected: (v) {
        if (v == 'edit') onEdit?.call();
        if (v == 'delete') onDelete?.call();
      },
      itemBuilder: (context) => [
        if (onEdit != null)
          PopupMenuItem(
            value: 'edit',
            child: Text(context.trRead('Edit', 'تعديل')),
          ),
        if (onDelete != null)
          PopupMenuItem(
            value: 'delete',
            child: Text(context.trRead('Delete', 'حذف')),
          ),
      ],
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
