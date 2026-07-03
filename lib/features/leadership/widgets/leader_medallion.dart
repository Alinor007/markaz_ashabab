import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';

/// The full-bleed leadership portrait that fills a card's upper section and
/// **fades smoothly into the white body** via a gradient. Shows the office
/// holder's photo when available; otherwise a serif monogram on a soft accent
/// wash. Vacant offices render a muted placeholder. The bottom always melts into
/// [AppColors.surface] so it blends seamlessly into the card body below.
class LeaderCover extends StatelessWidget {
  const LeaderCover({
    super.key,
    required this.assigned,
    this.initials = '',
    this.imagePath,
    this.accent = AppColors.emerald,
  });

  final bool assigned;
  final String initials;
  final String? imagePath;
  final Color accent;

  bool get _hasPhoto =>
      imagePath != null &&
      imagePath!.trim().isNotEmpty &&
      File(imagePath!).existsSync();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _base(),
        // The fade — transparent over the top, melting into solid white at the
        // bottom so the photo dissolves into the card body.
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Color(0x00FFFFFF), AppColors.surface],
              stops: [0.45, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _base() {
    if (_hasPhoto) {
      return Image.file(File(imagePath!), fit: BoxFit.cover);
    }
    // No photo: a soft vertical wash that already fades toward white, with a
    // large serif monogram (or a placeholder glyph for a vacant office).
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: assigned
              ? [accent.withValues(alpha: 0.22), AppColors.surface]
              : [AppColors.surfaceAlt, AppColors.surface],
        ),
      ),
      child: Align(
        alignment: const Alignment(0, -0.15),
        child: assigned
            ? Text(
                initials,
                style: TextStyle(
                  fontFamily: AppTypography.serif,
                  fontSize: 64,
                  fontWeight: FontWeight.w700,
                  color: AppColors.emeraldDark.withValues(alpha: 0.85),
                ),
              )
            : Icon(Icons.person_outline,
                size: 64, color: AppColors.textFaint),
      ),
    );
  }
}

/// A compact leadership portrait — a soft **rounded square** tile (never a
/// circle), with a serif monogram on a warm parchment fill, or the member's
/// photo. For inline use (e.g. list rows and pickers). Vacant entries show a
/// muted placeholder glyph.
class LeaderMedallion extends StatelessWidget {
  const LeaderMedallion({
    super.key,
    required this.size,
    required this.assigned,
    this.initials = '',
    this.imagePath,
    this.accent = AppColors.emerald,
  });

  final double size;
  final bool assigned;
  final String initials;
  final String? imagePath;
  final Color accent;

  bool get _hasPhoto =>
      imagePath != null &&
      imagePath!.trim().isNotEmpty &&
      File(imagePath!).existsSync();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.24),
        gradient: assigned && !_hasPhoto
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.16),
                  accent.withValues(alpha: 0.30),
                ],
              )
            : null,
        color: !assigned ? AppColors.surfaceAlt : null,
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: _content(),
    );
  }

  Widget _content() {
    if (_hasPhoto) {
      return Image.file(File(imagePath!),
          width: size, height: size, fit: BoxFit.cover);
    }
    if (assigned) {
      return Text(
        initials,
        style: TextStyle(
          fontFamily: AppTypography.serif,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
          color: accent,
          height: 1.0,
        ),
      );
    }
    return Icon(Icons.person_outline,
        size: size * 0.42, color: AppColors.textFaint);
  }
}

/// A small gold tag (e.g. an office abbreviation) shown on a card's cover.
class LeaderTag extends StatelessWidget {
  const LeaderTag({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.goldDeep,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.onGold,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}
