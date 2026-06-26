import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/models.dart';
import '../../core/i18n/locale_controller.dart';
import '../../core/i18n/strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/brand_emblem.dart';

/// The Home landing page: a single brand-forward hero — emblem, bilingual
/// identity, a gold rule, and a personalized greeting with the date.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: ConstrainedBox(
            // Fill the viewport so the hero can sit centered, but clamp to a
            // non-negative value — subtracting the padding can otherwise go
            // negative on a very short area and trip a BoxConstraints assertion.
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - AppSpacing.xxl * 2)
                  .clamp(0.0, double.infinity),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_BrandHero()],
            ),
          ),
        );
      },
    );
  }
}

/// The centered brand hero: a bordered white card — emblem, org identity
/// (EN + AR), a gold rule, and a personalized greeting with the date — that
/// reads clearly against the ivory page instead of blending into it.
class _BrandHero extends StatelessWidget {
  const _BrandHero();

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final isArabic = context.watch<LocaleController>().isArabic;
    final user = context.watch<SessionController>().user;
    final theme = Theme.of(context);

    return ConstrainedBox(
      // Keep the hero a centered card rather than a full-bleed band on wide
      // tablet layouts.
      constraints: const BoxConstraints(maxWidth: 640),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.panel,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.xxxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const BrandEmblem(size: 160, onLight: true),
            const SizedBox(height: AppSpacing.lg),
            Text(
              s.orgNameArabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: AppTypography.arabic(
                fontSize: 26,
                color: AppColors.navy,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              s.orgName,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(width: 56, height: 3, color: AppColors.gold),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${s.welcome}, ${user?.displayName(isArabic) ?? ''}',
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              textAlign: TextAlign.center,
              style: isArabic
                  ? AppTypography.arabic(
                      fontSize: 14,
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                    )
                  : theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _formattedDate(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.navy.withValues(alpha: 0.6),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formattedDate() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final now = DateTime.now();
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}
