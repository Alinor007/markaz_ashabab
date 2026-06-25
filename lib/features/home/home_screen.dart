import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/content/app_content.dart';
import '../../core/data/models.dart';
import '../../core/i18n/locale_controller.dart';
import '../../core/i18n/strings.dart';
import '../../core/patterns/geometric_pattern.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/brand_emblem.dart';

/// The Home landing page: a single brand-forward hero — large emblem, bilingual
/// identity, a gold rule, a personalized greeting with the date, and an
/// inspirational verse.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: ConstrainedBox(
            // Fill the viewport so the hero can sit centered, but still scroll
            // if it ever exceeds the available height.
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - AppSpacing.xxl * 2,
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

/// The centered brand hero: emblem, org identity (EN + AR), gold rule, a
/// personalized greeting with the date, and the inspirational verse — all over
/// a navy→emerald gradient with the Islamic geometric pattern.
class _BrandHero extends StatelessWidget {
  const _BrandHero();

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final isArabic = context.watch<LocaleController>().isArabic;
    final user = context.watch<SessionController>().user;
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: AppRadius.panel,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.navy, AppColors.emerald],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: GeometricPattern(
                color: Colors.white,
                opacity: 0.06,
                tile: 110,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.xxxl,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const BrandEmblem(size: 200, onLight: false),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    s.orgNameArabic,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: AppTypography.arabic(
                      fontSize: 26,
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    s.orgName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.onEmerald,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(width: 56, height: 3, color: AppColors.gold),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${s.welcome}, ${user?.displayName(isArabic) ?? ''}',
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: isArabic
                        ? AppTypography.arabic(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.92),
                            fontWeight: FontWeight.w700,
                          )
                        : theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontWeight: FontWeight.w600,
                          ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _formattedDate(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.gold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const _QuoteCard(),
                ],
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

class _QuoteCard extends StatelessWidget {
  const _QuoteCard();

  @override
  Widget build(BuildContext context) {
    const quote = kDashboardQuote;
    return Container(
      constraints: const BoxConstraints(maxWidth: 720),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: const Border(
          left: BorderSide(color: AppColors.gold, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quote.arabic,
            textDirection: TextDirection.rtl,
            style: AppTypography.arabic(
              fontSize: 24,
              color: AppColors.onEmerald,
              fontWeight: FontWeight.w700,
              height: 1.8,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '“${quote.translation}”',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            quote.source,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.gold,
                ),
          ),
        ],
      ),
    );
  }
}
