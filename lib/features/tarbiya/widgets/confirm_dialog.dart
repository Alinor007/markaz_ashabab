import 'package:flutter/material.dart';

import '../../../core/i18n/localized.dart';
import '../../../core/theme/app_colors.dart';

/// Confirmation dialog for destructive actions. Returns true if confirmed.
Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    // Pop with the dialog's own context (not the outer one): the dialog is on
    // the root navigator, while the caller may be inside a nested shell
    // navigator — popping the outer context would miss the dialog entirely.
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(dialogContext.tr('Cancel', 'إلغاء')),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(dialogContext.tr('Delete', 'حذف')),
        ),
      ],
    ),
  );
  return result ?? false;
}
