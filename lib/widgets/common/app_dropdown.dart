import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// The single, app-wide filter dropdown. Replaces the per-screen dropdown
/// implementations (Reports' `_Dropdown`, ad-hoc `DropdownButton`s) so every
/// inline filter looks and behaves identically.
///
/// [value] is the current selection (may be null for an "All …" entry), and
/// [items] maps each selectable value to its display label.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  /// Shown as the hint when nothing is selected.
  final String label;
  final T value;
  final Map<T, String> items;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        color: AppColors.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          borderRadius: AppRadius.card,
          icon: const Icon(Icons.arrow_drop_down, size: AppIconSize.lg),
          hint: Text(label),
          items: [
            for (final entry in items.entries)
              DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          ],
          onChanged: (v) => onChanged(v as T),
        ),
      ),
    );
  }
}
