import 'package:flutter/material.dart';

import '../../core/theme/app_dimens.dart';
import '../common/bilingual_title.dart';

/// Standard scaffolding for a module screen: a bilingual page title with an
/// optional trailing actions row, then the page body.
class ModulePage extends StatelessWidget {
  const ModulePage({
    super.key,
    required this.english,
    this.arabic = '',
    required this.child,
    this.actions = const [],
    this.scrollable = false,
    this.breadcrumb,
  });

  final String english;

  /// Ignored (the app is English-only); kept so call sites still compile.
  final String arabic;
  final Widget child;
  final List<Widget> actions;

  /// Optional breadcrumb trail rendered above the title (hierarchy screens).
  final Widget? breadcrumb;

  /// When true, the body is wrapped in a scroll view (for content that grows).
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: BilingualTitle(
            english: english,
            arabic: arabic,
            accentRule: true,
          ),
        ),
        if (actions.isNotEmpty)
          Wrap(spacing: AppSpacing.md, children: actions),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (breadcrumb != null) ...[
            breadcrumb!,
            const SizedBox(height: AppSpacing.md),
          ],
          header,
          const SizedBox(height: AppSpacing.xl),
          if (scrollable)
            Expanded(
              child: SingleChildScrollView(
                // Headroom so a focused field can scroll clear of the keyboard.
                padding: EdgeInsets.only(
                  bottom: MediaQuery.viewInsetsOf(context).bottom,
                ),
                child: child,
              ),
            )
          else
            Expanded(child: child),
        ],
      ),
    );
  }
}
