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
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.tr('Cancel', 'إلغاء')),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.pop(context, true),
          child: Text(context.tr('Delete', 'حذف')),
        ),
      ],
    ),
  );
  return result ?? false;
}
