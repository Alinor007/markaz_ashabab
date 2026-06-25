import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A placeholder portrait: initials on an accent-tinted disc with a subtle
/// gold ring. Swappable for a real photo later via [imageAsset].
class PortraitAvatar extends StatelessWidget {
  const PortraitAvatar({
    super.key,
    required this.initials,
    this.size = 72,
    this.accent = AppColors.emerald,
    this.imageAsset,
    this.ring = true,
  });

  final String initials;
  final double size;
  final Color accent;
  final String? imageAsset;
  final bool ring;

  @override
  Widget build(BuildContext context) {
    final inner = ClipOval(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: 0.16),
              accent.withValues(alpha: 0.30),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: imageAsset != null
            ? Image.asset(imageAsset!, fit: BoxFit.cover,
                width: size, height: size)
            : Text(
                initials,
                style: TextStyle(
                  fontFamily: 'Cormorant Garamond',
                  fontSize: size * 0.36,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
      ),
    );
    if (!ring) return inner;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.6), width: 1.5),
      ),
      child: inner,
    );
  }
}
