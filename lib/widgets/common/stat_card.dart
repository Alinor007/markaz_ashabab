import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// A statistic tile: an emerald-tinted icon chip, a large value, and a
/// bilingual label. Used across the dashboard.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.accent = AppColors.emerald,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: accent, size: 24),
              ),
              const Spacer(),
              Icon(Icons.trending_up, size: 16, color: AppColors.textFaint),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            value,
            style: theme.textTheme.displaySmall?.copyWith(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
           label,
            textDirection: TextDirection.ltr,
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
