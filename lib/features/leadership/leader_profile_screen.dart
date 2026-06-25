import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/leader_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/common/profile_header.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';

/// Full leadership profile (database-backed): header banner plus biography,
/// achievements, contact information, and organizational responsibilities.
class LeaderProfileScreen extends StatelessWidget {
  const LeaderProfileScreen({super.key, required this.leaderId});

  final String leaderId;

  static String categoryRoute(LeadershipCategory category) {
    switch (category) {
      case LeadershipCategory.officePresident:
        return '/leadership/office-president';
      case LeadershipCategory.board:
        return '/leadership/board';
      case LeadershipCategory.assembly:
        return '/leadership/assembly';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Leader?>(
      future: context.read<LeaderRepository>().getById(leaderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingState();
        }
        final leader = snapshot.data;
        if (leader == null) {
          return EmptyState(
            icon: Icons.person_off_outlined,
            title: context.tr('Leader not found', 'القائد غير موجود'),
          );
        }
        return _ProfileBody(leader: leader);
      },
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.leader});
  final Leader leader;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final backRoute = LeaderProfileScreen.categoryRoute(leader.categoryEnum);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.go(backRoute),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back,
                      size: 18, color: AppColors.emerald),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    isArabic ? leader.categoryEnum.ar : leader.categoryEnum.en,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: AppColors.emerald),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileHeader(
            initials: leader.initials,
            nameEn: leader.name,
            nameAr: leader.nameAr,
            subtitleEn: leader.position,
            subtitleAr: leader.positionAr,
            accent: leader.accentColor,
            meta: [
              if (leader.serviceYears.isNotEmpty)
                ProfileMeta(Icons.schedule, leader.serviceYears),
              if (leader.email.isNotEmpty)
                ProfileMeta(Icons.email_outlined, leader.email),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      InfoPanel(
                        icon: Icons.menu_book_outlined,
                        title: context.tr('Biography', 'السيرة الذاتية'),
                        child: Text(
                          (isArabic ? leader.bioAr : leader.bio).isEmpty
                              ? context.tr('No biography provided.',
                                  'لا توجد سيرة.')
                              : (isArabic ? leader.bioAr : leader.bio),
                          textDirection: isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: isArabic
                              ? AppTypography.arabic(fontSize: 16, height: 1.9)
                              : Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      InfoPanel(
                        icon: Icons.emoji_events_outlined,
                        title: context.tr('Achievements', 'الإنجازات'),
                        child: BulletList(
                          items: isArabic
                              ? leader.achievementsArList
                              : leader.achievementsList,
                          arabic: isArabic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      InfoPanel(
                        icon: Icons.contact_mail_outlined,
                        title: context.tr(
                            'Contact Information', 'معلومات التواصل'),
                        child: Column(
                          children: [
                            _ContactRow(
                                icon: Icons.email_outlined,
                                value: leader.email.isEmpty
                                    ? '—'
                                    : leader.email),
                            const SizedBox(height: AppSpacing.md),
                            _ContactRow(
                                icon: Icons.phone_outlined,
                                value: leader.phone.isEmpty
                                    ? '—'
                                    : leader.phone),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      InfoPanel(
                        icon: Icons.assignment_outlined,
                        title: context.tr('Organizational Responsibilities',
                            'المسؤوليات التنظيمية'),
                        child: BulletList(
                          items: isArabic
                              ? leader.responsibilitiesArList
                              : leader.responsibilitiesList,
                          arabic: isArabic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.value});
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.emeraldTint,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 18, color: AppColors.emerald),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
