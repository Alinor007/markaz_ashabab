import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Gently lifts its [child] with a stronger shadow on pointer hover
/// (desktop/web); on touch devices it just renders a resting shadow. A small,
/// reusable micro-interaction for tappable cards.
class HoverLift extends StatefulWidget {
  const HoverLift({super.key, required this.child, required this.radius});
  final Widget child;
  final BorderRadius radius;

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: widget.radius,
          boxShadow: [
            BoxShadow(
              color: AppColors.charcoal.withValues(alpha: _hover ? 0.13 : 0.05),
              blurRadius: _hover ? 20 : 10,
              offset: Offset(0, _hover ? 8 : 4),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
