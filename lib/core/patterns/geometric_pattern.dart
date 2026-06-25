import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A subtle, repeating Islamic geometric pattern drawn in code (no asset).
///
/// Renders a tessellation of eight-pointed stars (khatam / rub el hizb motif)
/// connected by small squares — a classic Islamic ornament. Kept at low
/// opacity for use behind hero sections and brand panels.
class GeometricPattern extends StatelessWidget {
  const GeometricPattern({
    super.key,
    this.color = const Color(0xFFFFFFFF),
    this.opacity = 0.06,
    this.tile = 96,
    this.strokeWidth = 1.2,
  });

  /// Line color of the pattern.
  final Color color;

  /// Overall opacity applied to [color].
  final double opacity;

  /// Size of one repeating tile in logical pixels.
  final double tile;

  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _StarTessellationPainter(
          color: color.withValues(alpha: opacity),
          tile: tile,
          strokeWidth: strokeWidth,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _StarTessellationPainter extends CustomPainter {
  _StarTessellationPainter({
    required this.color,
    required this.tile,
    required this.strokeWidth,
  });

  final Color color;
  final double tile;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round;

    final cols = (size.width / tile).ceil() + 1;
    final rows = (size.height / tile).ceil() + 1;
    final r = tile / 2;

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final cx = col * tile;
        final cy = row * tile;
        canvas.drawPath(_eightPointStar(cx, cy, r * 0.62), paint);
        // Small rotated square linking stars at the tile corners.
        canvas.drawPath(_square(cx + r, cy + r, r * 0.26), paint);
      }
    }
  }

  /// Eight-pointed star centered at (cx, cy) with circumscribed radius [radius].
  Path _eightPointStar(double cx, double cy, double radius) {
    final path = Path();
    const points = 8;
    final inner = radius * 0.62;
    for (var i = 0; i < points * 2; i++) {
      final isOuter = i.isEven;
      final rad = isOuter ? radius : inner;
      final angle = (math.pi / points) * i - math.pi / 2;
      final x = cx + rad * math.cos(angle);
      final y = cy + rad * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  /// A 45°-rotated square (diamond) centered at (cx, cy).
  Path _square(double cx, double cy, double radius) {
    return Path()
      ..moveTo(cx, cy - radius)
      ..lineTo(cx + radius, cy)
      ..lineTo(cx, cy + radius)
      ..lineTo(cx - radius, cy)
      ..close();
  }

  @override
  bool shouldRepaint(_StarTessellationPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.tile != tile ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
