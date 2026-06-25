import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/patterns/geometric_pattern.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// A masonry gallery tile (placeholder = patterned accent panel, or the photo
/// when [GalleryPhoto.imagePath] is set) with a caption overlay.
class GalleryCard extends StatelessWidget {
  const GalleryCard({super.key, required this.photo, required this.onTap});

  final GalleryPhoto photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final hasImage =
        photo.imagePath.isNotEmpty && File(photo.imagePath).existsSync();
    return Material(
      borderRadius: AppRadius.card,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: photo.heightHint.toDouble(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasImage)
                Image.file(File(photo.imagePath), fit: BoxFit.cover)
              else ...[
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        photo.accentColor,
                        Color.alphaBlend(Colors.black.withValues(alpha: 0.3),
                            photo.accentColor),
                      ],
                    ),
                  ),
                ),
                const GeometricPattern(
                    color: Colors.white, opacity: 0.10, tile: 70),
                Center(
                  child: Icon(photo.icon,
                      size: 44, color: Colors.white.withValues(alpha: 0.6)),
                ),
              ],
              // Caption scrim
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.55),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isArabic ? photo.titleAr : photo.title,
                        textDirection:
                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: isArabic
                            ? AppTypography.arabic(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)
                            : Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                      Text(
                        '${isArabic ? photo.eventAr : photo.event} · ${photo.year}',
                        textDirection:
                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
