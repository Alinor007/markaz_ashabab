import 'package:flutter/material.dart';

import '../../core/auth/roles.dart';
import '../../core/theme/app_dimens.dart';

/// A small colored pill conveying a [UserRole].
class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role, this.compact = false});

  final UserRole role;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: compact ? 2 : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: role.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: role.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: role.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              role.label(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: role.color, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
