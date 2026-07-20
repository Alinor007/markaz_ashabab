import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// A small tinted pill showing an icon and a label (e.g. "4 shuba",
/// "8 female") — used on the Tarbiya Area/Shu'ba directory cards. Matches the
/// app's soft-tint chip convention (see `_CountChip`, `AppTheme.chipTheme`)
/// rather than a solid fill, so it sits quietly alongside the rest of the UI.
class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.label,
    this.color = AppColors.emerald,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
