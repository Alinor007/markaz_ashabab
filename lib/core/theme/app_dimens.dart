import 'package:flutter/widgets.dart';

/// Spacing, radius, elevation and fixed-layout dimension tokens.
///
/// Spacing follows a 4-point scale. The app targets Android tablets in
/// landscape at 1280×800, so a few structural dimensions are fixed.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;

  static const BorderRadius card = BorderRadius.all(Radius.circular(md));
  static const BorderRadius panel = BorderRadius.all(Radius.circular(lg));
}

abstract final class AppElevation {
  static const double none = 0;
  static const double low = 1;
  static const double medium = 3;
  static const double high = 8;
}

/// Coherent icon-size scale. Replaces ad-hoc 14/18/40/44 values scattered
/// across cards and rows.
abstract final class AppIconSize {
  /// Inline / decorative chevrons & accents.
  static const double sm = 16;

  /// Default UI icons (nav, buttons, list rows).
  static const double md = 20;

  /// Emphasis icons (card headers, primary actions).
  static const double lg = 24;

  /// Square icon-chip container (tinted background behind an [lg] icon).
  static const double chip = 44;
}

abstract final class AppLayout {
  /// Permanent left sidebar (expanded) width.
  static const double sidebarWidth = 280;

  /// Collapsed sidebar width — an icon-only rail.
  static const double sidebarCollapsedWidth = 72;

  /// Top navigation bar height.
  static const double topBarHeight = 72;

  /// Reference design canvas — Android tablet, landscape.
  static const Size referenceCanvas = Size(1280, 800);

  /// Wrap-grid breakpoint used across module screens. Centralizes the
  /// previously duplicated `width > 1100 ? 3 : 2` logic so every grid agrees.
  static int gridColumns(double width) {
    if (width > 1100) return 3;
    if (width > 640) return 2;
    return 1;
  }
}
