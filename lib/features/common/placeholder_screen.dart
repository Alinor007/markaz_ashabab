import 'package:flutter/material.dart';

import '../../core/i18n/strings.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/common/bilingual_title.dart';
import '../../widgets/feedback/empty_state.dart';

/// A standard scaffold for modules not yet built in this pass: a bilingual
/// page header plus a branded "coming soon" empty state.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.english,
    required this.arabic,
    required this.icon,
  });

  final String english;
  final String arabic;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BilingualTitle(english: english, arabic: arabic, accentRule: true),
          const SizedBox(height: AppSpacing.xxl),
          Expanded(
            child: EmptyState(
              icon: icon,
              title: s.comingSoon,
              message: s.comingSoonBody,
            ),
          ),
        ],
      ),
    );
  }
}
