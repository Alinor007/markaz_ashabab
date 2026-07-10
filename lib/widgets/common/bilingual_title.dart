import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// A page title (Cormorant serif). Used as the standard header on every major
/// page. The [arabic] argument is ignored (the app is English-only) and kept
/// only so existing call sites continue to compile.
class BilingualTitle extends StatelessWidget {
  const BilingualTitle({
    super.key,
    required this.english,
    this.arabic = '',
    this.englishStyle,
    this.arabicFontSize = 22,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.accentRule = false,
  });

  final String english;
  final String arabic;
  final TextStyle? englishStyle;
  final double arabicFontSize;
  final CrossAxisAlignment crossAxisAlignment;

  /// When true, draws a short gold rule under the title (hero contexts).
  final bool accentRule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Semantics(
          header: true,
          child:
              Text(english, style: englishStyle ?? theme.textTheme.headlineMedium),
        ),
        if (accentRule) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            width: 56,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ],
    );
  }
}
