import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The organization seal. Tries to render `assets/images/logo.png`; if it is
/// not present (placeholder phase), falls back to a drawn emblem so the UI
/// still looks intentional. Drop the real `logo.png` into assets to swap it in.
class BrandEmblem extends StatelessWidget {
  const BrandEmblem({super.key, this.size = 96, this.onLight = true});

  final double size;

  /// When placed on a dark/emerald panel, set false for a light fallback ring.
  final bool onLight;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _FallbackEmblem(size: size, onLight: onLight),
      ),
    );
  }
}

class _FallbackEmblem extends StatelessWidget {
  const _FallbackEmblem({required this.size, required this.onLight});

  final double size;
  final bool onLight;

  @override
  Widget build(BuildContext context) {
    final ring = onLight ? AppColors.emerald : AppColors.gold;
    final fill = onLight ? AppColors.emeraldTint : AppColors.surface;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: ring, width: size * 0.04),
      ),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: size * 0.42,
          color: AppColors.emerald,
        ),
      ),
    );
  }
}
