import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// Outcome tone for a snackbar — drives the leading icon and accent.
enum SnackTone { success, error, info }

/// Shows a consistent, branded snackbar for action outcomes (save / delete /
/// error). Centralizes styling so every confirmation looks the same instead of
/// each screen rolling its own `SnackBar`.
void showAppSnackBar(
  BuildContext context,
  String message, {
  SnackTone tone = SnackTone.success,
}) {
  final (icon, accent) = switch (tone) {
    SnackTone.success => (Icons.check_circle_outline, AppColors.emerald),
    SnackTone.error => (Icons.error_outline, AppColors.error),
    SnackTone.info => (Icons.info_outline, AppColors.navy),
  };

  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        elevation: AppElevation.high,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        content: Row(
          children: [
            Icon(icon, color: accent, size: AppIconSize.md),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: AppColors.onNavy),
              ),
            ),
          ],
        ),
      ),
    );
}
