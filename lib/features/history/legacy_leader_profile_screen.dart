import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/history_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';

/// View-only profile for a hand-curated Leadership Legacy leader (a typed name
/// and photo, not a member). Mirrors [LeaderProfileScreen]: a portrait profile
/// card with the office and term on the left, and the biography sections on the
/// wider right column. Columns collapse into a single stack on narrow screens.
class LegacyLeaderProfileScreen extends StatelessWidget {
  const LegacyLeaderProfileScreen({super.key, required this.legacyLeaderId});

  final String legacyLeaderId;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<HistoryRepository>();
    return StreamBuilder<HistoryLegacyLeader?>(
      stream: repo.watchLegacyLeader(legacyLeaderId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting && !snap.hasData) {
          return const Padding(
              padding: EdgeInsets.all(AppSpacing.xxl), child: LoadingState());
        }
        final leader = snap.data;
        if (leader == null) {
          return EmptyState(
            icon: Icons.person_off_outlined,
            title: context.tr('Leader not found', 'القائد غير موجود'),
          );
        }
        return _Body(leader: leader);
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.leader});
  final HistoryLegacyLeader leader;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final repo = context.read<HistoryRepository>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () =>
                context.canPop() ? context.pop() : context.go('/history'),
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
                  Text(context.tr('Back', 'رجوع'),
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: AppColors.emerald)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          StreamBuilder<List<HistoryLegacyLeaderSection>>(
            stream: repo.watchLegacySections(leader.id),
            builder: (context, snap) {
              final sections =
                  snap.data ?? const <HistoryLegacyLeaderSection>[];
              final biography = <Widget>[
                for (final s in sections)
                  if (s.title.trim().isNotEmpty || s.body.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.lg),
                      child: _BiographyCard(
                        title: s.title.trim().isEmpty
                            ? context.tr('Biography', 'نبذة')
                            : s.title,
                        body: s.body,
                      ),
                    ),
              ];
              final biographyOrEmpty = biography.isEmpty
                  ? <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.lg),
                        child: Text(
                          context.tr('No biography recorded yet.',
                              'لا توجد سيرة ذاتية بعد.'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textMuted),
                        ),
                      ),
                    ]
                  : biography;

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Two columns once there is room; otherwise a single stack.
                  if (constraints.maxWidth <= 720) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _LegacyProfileCard(leader: leader),
                        ...biographyOrEmpty,
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: _LegacyProfileCard(leader: leader),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: biographyOrEmpty,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// The portrait profile card: a large rounded photo (or accent-tinted initials)
/// with the leader's name, office, and term of service beneath it.
class _LegacyProfileCard extends StatelessWidget {
  const _LegacyProfileCard({required this.leader});
  final HistoryLegacyLeader leader;

  String get _initials {
    final parts = leader.name.replaceAll('.', '').trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final office = leader.position.trim();
    final term = leader.termYears.trim();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.panel,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.charcoal.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _portrait(context),
          const SizedBox(height: AppSpacing.lg),
          Text(
            leader.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTypography.serif,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
              height: 1.2,
            ),
          ),
          if (office.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              office,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.emerald,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
          if (term.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              term,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }

  Widget _portrait(BuildContext context) {
    final color = Color(leader.accent);
    final hasPhoto = leader.photoPath.trim().isNotEmpty &&
        File(leader.photoPath).existsSync();
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: AspectRatio(
        aspectRatio: 0.86,
        child: hasPhoto
            ? Image.file(File(leader.photoPath), fit: BoxFit.cover)
            : DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.18),
                      color.withValues(alpha: 0.40),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    _initials,
                    style: TextStyle(
                      fontFamily: AppTypography.serif,
                      fontSize: 64,
                      fontWeight: FontWeight.w700,
                      color: AppColors.surface.withValues(alpha: 0.95),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

/// A single biography section as a titled panel with a flowing paragraph body.
class _BiographyCard extends StatelessWidget {
  const _BiographyCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return InfoPanel(
      icon: Icons.menu_book_outlined,
      title: title,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          body.trim().isEmpty ? '—' : body,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(height: 1.7, color: AppColors.charcoal),
        ),
      ),
    );
  }
}
