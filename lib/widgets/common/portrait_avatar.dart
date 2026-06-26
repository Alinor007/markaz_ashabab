import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A portrait avatar: a stored photo when available, otherwise initials on an
/// accent-tinted disc with a subtle gold ring. Pass [imagePath] for a photo
/// picked/stored on the device, or [imageAsset] for a bundled asset.
class PortraitAvatar extends StatelessWidget {
  const PortraitAvatar({
    super.key,
    required this.initials,
    this.size = 72,
    this.accent = AppColors.emerald,
    this.imageAsset,
    this.imagePath,
    this.ring = true,
  });

  final String initials;
  final double size;
  final Color accent;
  final String? imageAsset;

  /// Absolute path to a stored photo file. Takes precedence over [imageAsset]
  /// and [initials] when the file exists.
  final String? imagePath;
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
        child: _portrait(),
      ),
    );
    if (!ring) return inner;
    return _ringed(inner);
  }

  Widget _portrait() {
    if (imagePath != null &&
        imagePath!.trim().isNotEmpty &&
        File(imagePath!).existsSync()) {
      return Image.file(File(imagePath!),
          fit: BoxFit.cover, width: size, height: size);
    }
    if (imageAsset != null) {
      return Image.asset(imageAsset!, fit: BoxFit.cover, width: size, height: size);
    }
    return Text(
      initials,
      style: TextStyle(
        fontFamily: 'Cormorant Garamond',
        fontSize: size * 0.36,
        fontWeight: FontWeight.w700,
        color: accent,
      ),
    );
  }

  Widget _ringed(Widget inner) {
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
