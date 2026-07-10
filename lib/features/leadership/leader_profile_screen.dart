import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/leader_repository.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';

/// View-only profile for a member who holds (or held) a leadership position.
///
/// Laid out as a two-column magazine spread on wide screens: a portrait
/// profile card, Educational Background, and Role in Organization run down the
/// left; Personal Information and the member's biography sections (sourced from
/// the Previous Leadership registry) run down the wider right column. On narrow
/// screens the columns collapse into a single stack. No edit/delete, and none
/// of the member's family / Usra / donation details.
class LeaderProfileScreen extends StatelessWidget {
  const LeaderProfileScreen({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MemberRepository>();
    return FutureBuilder<Member?>(
      future: repo.getMember(memberId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
              padding: EdgeInsets.all(AppSpacing.xxl), child: LoadingState());
        }
        final member = snap.data;
        if (member == null) {
          return EmptyState(
            icon: Icons.person_off_outlined,
            title: 'Member not found',
          );
        }
        return _Body(member: member);
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.member});
  final Member member;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final leaderRepo = context.read<LeaderRepository>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.canPop()
                ? context.pop()
                : context.go('/leadership/office-president'),
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
                  Text('Back',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: AppColors.emerald)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // The former-leadership entries drive both the profile card's
          // office/term and the biography section cards, so the whole spread is
          // built inside a single stream over them.
          StreamBuilder<List<PreviousLeader>>(
            stream: leaderRepo.watchPreviousLeadershipForMember(member.id),
            builder: (context, snap) {
              final entries = snap.data ?? const <PreviousLeader>[];
              final primary = entries.isEmpty ? null : entries.first;

              // Biography entries are async and may render empty, so they own
              // their leading gap (see [_EntryBiography]) rather than being
              // spaced by [_stack] — that keeps empty entries from leaving a
              // stray gap.
              final biography = [
                for (final e in entries) _EntryBiography(entry: e),
              ];

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Two columns once there is room; otherwise a single stack.
                  if (constraints.maxWidth <= 720) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ..._stack([
                          _LeaderProfileCard(member: member, entry: primary),
                          _educationPanel(context),
                          _rolePanel(context),
                        ]),
                        ...biography,
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _stack([
                            _LeaderProfileCard(
                                member: member, entry: primary),
                            _educationPanel(context),
                            _rolePanel(context),
                          ]),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ...biography,
                          ],
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

  /// Stacks a column's always-visible cards with a consistent gap between them.
  List<Widget> _stack(List<Widget> items) => [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.lg),
          items[i],
        ],
      ];



  Widget _educationPanel(BuildContext context) {
    final memberRepo = context.read<MemberRepository>();
    return InfoPanel(
      icon: Icons.school_outlined,
      title: 'Educational Background',
      child: StreamBuilder<List<MemberEducationData>>(
        stream: memberRepo.watchEducation(member.id),
        builder: (context, snap) {
          final rows = snap.data ?? const <MemberEducationData>[];
          if (rows.isEmpty) return _empty(context);
          return Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const Divider(height: AppSpacing.xl),
                _Record(fields: [
                  _Field('Degree / Course',
                      rows[i].degree.isEmpty ? rows[i].program : rows[i].degree),
                  _Field(
                      'School / University',
                      rows[i].schoolName),
                  _Field('Year Graduated',
                      rows[i].yearGraduated),
                ]),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _rolePanel(BuildContext context) {
    final memberRepo = context.read<MemberRepository>();
    return InfoPanel(
      icon: Icons.badge_outlined,
      title: 'Role in Fundation',
      child: StreamBuilder<List<MemberRole>>(
        stream: memberRepo.watchRoles(member.id),
        builder: (context, snap) {
          final roles = snap.data ?? const <MemberRole>[];
          if (roles.isEmpty) return _empty(context);
          return Column(
            children: [
              for (var i = 0; i < roles.length; i++) ...[
                if (i > 0) const Divider(height: AppSpacing.xl),
                _Record(fields: [
                  _Field('Current Position',
                      roles[i].positionTitle),
                  _Field(
                      'Department', roles[i].department),
                  _Field(
                      'Term / Period', _term(roles[i])),
                ]),
              ],
            ],
          );
        },
      ),
    );
  }

  String _term(MemberRole r) {
    if (r.startDate.isEmpty && r.endDate.isEmpty) return '';
    final end = r.endDate.isEmpty ? '—' : r.endDate;
    return '${r.startDate} – $end';
  }

  Widget _empty(BuildContext context) => Text(
        'No records.',
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.textMuted),
      );
}

/// The portrait profile card: a large rounded photo with the member's name,
/// their leadership office (from [entry] when set, otherwise their occupation),
/// and the term of service beneath it.
class _LeaderProfileCard extends StatelessWidget {
  const _LeaderProfileCard({required this.member, this.entry});
  final Member member;
  final PreviousLeader? entry;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;

    final office = () {
      final p = entry == null
          ? ''
          : (entry!.position).trim();
      if (p.isNotEmpty) return p;
      return member.occupation.trim().isEmpty
          ? 'Member'
          : member.occupation;
    }();
    final term = entry?.termYears.trim() ?? '';

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
            member.displayName(isArabic),
            textAlign: TextAlign.center,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: isArabic
                ? AppTypography.arabic(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal)
                : TextStyle(
                    fontFamily: AppTypography.serif,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                    height: 1.2,
                  ),
          ),
          // The name in the other language, when both are recorded.
          if ((member.fullName).trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                member.fullName,
                textAlign: TextAlign.center,
                textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
                style: isArabic
                    ? Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textMuted)
                    : AppTypography.arabic(
                        fontSize: 15, color: AppColors.textMuted),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            office,
            textAlign: TextAlign.center,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.emerald,
                  fontWeight: FontWeight.w600,
                ),
          ),
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
    final hasPhoto = member.photoPath.trim().isNotEmpty &&
        File(member.photoPath).existsSync();
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: AspectRatio(
        aspectRatio: 0.86,
        child: hasPhoto
            ? Image.file(File(member.photoPath), fit: BoxFit.cover)
            : DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.emeraldTint, AppColors.goldTint],
                  ),
                ),
                child: Center(
                  child: Text(
                    member.initials,
                    style: TextStyle(
                      fontFamily: AppTypography.serif,
                      fontSize: 64,
                      fontWeight: FontWeight.w700,
                      color: AppColors.emerald,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

/// Renders one former-leadership entry's biography as a series of cards: the
/// preserved note (titled by the office held) followed by one card per
/// biography section. Renders nothing when the entry has no content.
class _EntryBiography extends StatelessWidget {
  const _EntryBiography({required this.entry});
  final PreviousLeader entry;

  @override
  Widget build(BuildContext context) {
    final leaderRepo = context.read<LeaderRepository>();
    final note = (entry.note).trim();
    final office = (entry.position).trim();

    return StreamBuilder<List<PreviousLeaderSection>>(
      stream: leaderRepo.watchSections(entry.id),
      builder: (context, snap) {
        final sections = snap.data ?? const <PreviousLeaderSection>[];
        final cards = <Widget>[
          if (note.isNotEmpty)
            _BiographyCard(
              title: office.isEmpty
                  ? 'Biography'
                  : office,
              body: note,
            ),
          for (final s in sections)
            _BiographyCard(
              title: ( s.title).trim().isEmpty
                  ? 'Biography'
                  : (s.title),
              body: s.body,
            ),
        ];
        if (cards.isEmpty) return const SizedBox.shrink();
        // Each card carries its own leading gap so an empty entry contributes
        // no spacing at all.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final card in cards)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: card,
              ),
          ],
        );
      },
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
    final isArabic = context.isArabic;
    return InfoPanel(
      title: title,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          body.trim().isEmpty ? '—' : body,
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          style: isArabic
              ? AppTypography.arabic(fontSize: 15, height: 1.8)
              : Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.7, color: AppColors.charcoal),
        ),
      ),
    );
  }
}

/// A labelled value cell (label above the value); empty values show an em dash.
class _Field extends StatelessWidget {
  const _Field(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(value.trim().isEmpty ? '—' : value,
              style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

/// A single record (e.g. one degree or one role) as a wrap of [_Field]s.
class _Record extends StatelessWidget {
  const _Record({required this.fields});
  final List<Widget> fields;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xl,
      runSpacing: AppSpacing.lg,
      children: fields,
    );
  }
}
