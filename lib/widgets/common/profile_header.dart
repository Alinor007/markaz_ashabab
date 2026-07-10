import 'package:flutter/material.dart';

import '../../core/patterns/geometric_pattern.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import 'portrait_avatar.dart';

/// A meta item shown under a profile name (icon + label).
class ProfileMeta {
  const ProfileMeta(this.icon, this.label);
  final IconData icon;
  final String label;
}

/// A reusable profile banner: portrait over a patterned emerald→navy header,
/// with bilingual name, subtitle, and meta chips. Used by leadership and
/// member profiles.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.initials,
    required this.nameEn,
    this.nameAr = '',
    required this.subtitleEn,
    this.subtitleAr = '',
    this.accent = AppColors.emerald,
    this.meta = const [],
    this.trailing,
    this.leadingIcon,
    this.imagePath,
  });

  /// When set, the avatar shows this icon instead of [initials].
  final IconData? leadingIcon;

  /// Absolute path to a stored profile photo, shown in place of [initials].
  final String? imagePath;

  final String initials;
  final String nameEn;
  final String nameAr;
  final String subtitleEn;
  final String subtitleAr;
  final Color accent;
  final List<ProfileMeta> meta;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.panel,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.navy, AppColors.emerald],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: GeometricPattern(
                  color: Colors.white, opacity: 0.06, tile: 90),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Row(
                children: [
                  if (leadingIcon != null)
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.6),
                            width: 1.5),
                      ),
                      child: Icon(leadingIcon, size: 44, color: AppColors.gold),
                    )
                  else
                    PortraitAvatar(
                        initials: initials,
                        imagePath: imagePath,
                        accent: AppColors.gold,
                        size: 96),
                  const SizedBox(width: AppSpacing.xl),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          nameEn,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(color: AppColors.onEmerald),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitleEn,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.gold),
                        ),
                        if (meta.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: [
                              for (final m in meta) _MetaChip(meta: m),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  ?trailing,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.meta});
  final ProfileMeta meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(meta.icon, size: 14, color: Colors.white.withValues(alpha: 0.85)),
          const SizedBox(width: AppSpacing.xs),
          Text(
            meta.label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
          ),
        ],
      ),
    );
  }
}
