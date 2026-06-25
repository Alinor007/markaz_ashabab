import 'package:flutter/material.dart';

import '../../core/i18n/localized.dart';
import '../../core/content/history_content.dart';
import '../../core/patterns/geometric_pattern.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/cards/timeline_item.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/layout/module_page.dart';

/// History module: founding hero, key facts, and a milestones timeline.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return ModulePage(
      english: 'History',
      arabic: 'التاريخ',
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FoundingHero(isArabic: isArabic),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _FactCard(
                  value: '1978',
                  unit: context.tr('Founded', 'التأسيس'),
                  icon: Icons.flag_outlined,
                  color: AppColors.emerald,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _FactCard(
                  value: '64',
                  unit: context.tr('Branches', 'الفروع'),
                  icon: Icons.account_tree_outlined,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _FactCard(
                  value: '40+',
                  unit: context.tr('Years of Service', 'عامًا من الخدمة'),
                  icon: Icons.timelapse_outlined,
                  color: AppColors.goldDeep,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          InfoPanel(
            icon: Icons.menu_book_outlined,
            title: context.tr('Our Story', 'قصتنا'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final para in kHistoryNarrative)
                  _StoryParagraph(text: para, isArabic: isArabic),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _StatementPanel(
                    icon: Icons.track_changes_outlined,
                    title: context.tr('Mission', 'الرسالة'),
                    text: kMission,
                    isArabic: isArabic,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: _StatementPanel(
                    icon: Icons.visibility_outlined,
                    title: context.tr('Vision', 'الرؤية'),
                    text: kVision,
                    isArabic: isArabic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          InfoPanel(
            icon: Icons.history_edu_outlined,
            title: context.tr('Milestones', 'المحطات'),
            child: Column(
              children: [
                for (var i = 0; i < kMilestones.length; i++)
                  _MilestoneRow(
                    milestone: kMilestones[i],
                    isArabic: isArabic,
                    isFirst: i == 0,
                    isLast: i == kMilestones.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FoundingHero extends StatelessWidget {
  const _FoundingHero({required this.isArabic});
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.panel,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.navy, AppColors.emerald],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: GeometricPattern(
                  color: Colors.white, opacity: 0.06, tile: 96),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('Our Story', 'قصتنا'),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.gold,
                          letterSpacing: 1.4,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: Text(
                      isArabic ? kFoundingAr : kFoundingEn,
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      style: isArabic
                          ? AppTypography.arabic(
                              fontSize: 22,
                              color: AppColors.onEmerald,
                              height: 1.9)
                          : Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.onEmerald,
                                height: 1.5,
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                Text(unit, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryParagraph extends StatelessWidget {
  const _StoryParagraph({required this.text, required this.isArabic});
  final Bilingual text;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Text(
        isArabic ? text.ar : text.en,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        style: isArabic
            ? AppTypography.arabic(
                fontSize: 17,
                color: AppColors.charcoal,
                height: 1.9,
              )
            : Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7),
      ),
    );
  }
}

class _StatementPanel extends StatelessWidget {
  const _StatementPanel({
    required this.icon,
    required this.title,
    required this.text,
    required this.isArabic,
  });
  final IconData icon;
  final String title;
  final Bilingual text;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return InfoPanel(
      icon: icon,
      title: title,
      child: Text(
        isArabic ? text.ar : text.en,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        style: isArabic
            ? AppTypography.arabic(
                fontSize: 18,
                color: AppColors.charcoal,
                height: 1.9,
              )
            : Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
      ),
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({
    required this.milestone,
    required this.isArabic,
    required this.isFirst,
    required this.isLast,
  });
  final Milestone milestone;
  final bool isArabic;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return TimelineItem(
      icon: milestone.icon,
      accent: milestone.color,
      isFirst: isFirst,
      isLast: isLast,
      timestamp: milestone.year,
      title: isArabic ? milestone.titleAr : milestone.title,
      subtitle: isArabic ? milestone.descriptionAr : milestone.description,
    );
  }
}
