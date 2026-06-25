import 'package:flutter/material.dart';

/// Centralized color tokens for the Markaz As-Shabab archive system.
///
/// Palette identity: Deep Emerald Green (primary), Deep Navy Blue (secondary),
/// Islamic Gold (accent), Warm Ivory / Parchment (background), Charcoal (text).
/// Kept deliberately muted and institutional — no bright gradients or neon.
abstract final class AppColors {
  // Primary — Deep Emerald Green
  static const Color emerald = Color(0xFF0B5D3B);
  static const Color emeraldDark = Color(0xFF08462C);
  static const Color emeraldTint = Color(0xFFE6EFEA);

  // Secondary — Deep Navy Blue
  static const Color navy = Color(0xFF16243D);
  static const Color navyTint = Color(0xFFE7EAF0);

  // Accent — Islamic Gold
  static const Color gold = Color(0xFFC2A14D);
  static const Color goldDeep = Color(0xFFA8862F);
  static const Color goldTint = Color(0xFFF3ECD8);

  // Background — Warm Ivory / Parchment
  static const Color ivory = Color(0xFFFAF6EC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF4EFE2);

  // Text — Charcoal Black
  static const Color charcoal = Color(0xFF22251F);
  static const Color textMuted = Color(0xFF5C5F58);
  static const Color textFaint = Color(0xFF8A8D85);

  // Lines & dividers — hairline parchment border
  static const Color border = Color(0xFFE3DDCB);
  static const Color borderStrong = Color(0xFFD3C9AE);

  // Semantic
  static const Color success = Color(0xFF0B5D3B);
  static const Color warning = Color(0xFFA8862F);
  static const Color error = Color(0xFF9B2C2C);
  static const Color info = Color(0xFF16243D);

  // On-color text
  static const Color onEmerald = Color(0xFFF7F3E9);
  static const Color onNavy = Color(0xFFF7F3E9);
  static const Color onGold = Color(0xFF22251F);
}
