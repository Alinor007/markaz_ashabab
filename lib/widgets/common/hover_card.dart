import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// Wraps a card-like child and adds a subtle pointer-hover affordance: a soft
/// lift (shadow) and a fractional scale-up. Purely presentational — the child
/// keeps its own `InkWell`/`onTap`. On touch devices (no pointer) it simply
/// renders the child at rest, so it is safe to use on the tablet build.
class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.borderRadius = AppRadius.card,
  });

  final Widget child;
  final BorderRadius borderRadius;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.012 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.navy.withValues(alpha: 0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : const [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
