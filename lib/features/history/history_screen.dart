import 'dart:io';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/i18n/localized.dart';
import '../../core/patterns/geometric_pattern.dart';
import '../../core/repositories/history_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/util/icon_catalog.dart';
import '../../widgets/document/document_view.dart';
import '../../widgets/layout/module_page.dart';
import '../tarbiya/widgets/confirm_dialog.dart';
import 'history_edit_dialogs.dart';

/// History module — a premium organizational timeline: founding hero, quick
/// facts, the narrative, mission/vision, a visual milestones timeline, and a
/// "Leadership Legacy" showcase. All content is DB-backed, live, and editable by
/// executives. This is a presentation-only design over the existing
/// repositories, streams, edit dialogs, permissions, and routes.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final repo = context.read<HistoryRepository>();
    final canManage =
        context.watch<SessionController>().can?.manageContent ?? false;

    return ModulePage(
      english: 'History',
      arabic: 'التاريخ',
      scrollable: true,
      child: StreamBuilder<HistoryContent?>(
        stream: repo.watchContent(),
        builder: (context, snap) {
          // Show a loader until the first emission arrives
          if (snap.connectionState == ConnectionState.waiting &&
              !snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final content = snap.data;
          final facts = HistoryRepository.factsOf(content);
          final paragraphs = HistoryRepository.paragraphsOf(content);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DocReveal(
                child: _FoundingHero(
                  isArabic: isArabic,
                  content: content,
                  canManage: canManage,
                  onEdit: () => _editFounding(context, repo, content),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              DocReveal(
                delayMs: 80,
                child: _FactsSection(
                  facts: facts,
                  isArabic: isArabic,
                  canManage: canManage,
                  onEdit: () => _editFacts(context, repo, facts),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              DocReveal(
                delayMs: 160,
                child: _NarrativeSection(
                  paragraphs: paragraphs,
                  isArabic: isArabic,
                  canManage: canManage,
                  onEdit: () => _editNarrative(context, repo, paragraphs),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              DocReveal(
                delayMs: 240,
                child: _MissionVisionSection(
                  canManage: canManage,
                  missionEn: content?.missionEn ?? '',
                  visionEn: content?.visionEn ?? '',
                  onEditMission: () => _editStatement(
                    context,
                    repo,
                    title: context.trRead('Edit Mission', 'تعديل الرسالة'),
                    en: content?.missionEn ?? '',
                    apply: (e) => HistoryContentsCompanion(missionEn: Value(e)),
                  ),
                  onEditVision: () => _editStatement(
                    context,
                    repo,
                    title: context.trRead('Edit Vision', 'تعديل الرؤية'),
                    en: content?.visionEn ?? '',
                    apply: (e) => HistoryContentsCompanion(visionEn: Value(e)),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              DocReveal(
                delayMs: 320,
                child: _MilestonesTimeline(
                    isArabic: isArabic, canManage: canManage),
              ),
              const SizedBox(height: AppSpacing.xxl),
              DocReveal(
                delayMs: 400,
                child: _PreviousLeadershipSection(canManage: canManage),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }

  // ── Edit handlers (unchanged data flow) ────────────────────────────────────
  Future<void> _editFounding(BuildContext context, HistoryRepository repo,
      HistoryContent? content) async {
    final r = await editBilingualText(
      context,
      title: context.trRead('Edit Founding Statement', 'تعديل بيان التأسيس'),
      enLabel: context.trRead('English', 'الإنجليزية'),
      initialEn: content?.foundingEn ?? '',
    );
    if (r == null) return;
    await repo
        .updateContent(HistoryContentsCompanion(foundingEn: Value(r.$1)));
  }

  Future<void> _editFacts(BuildContext context, HistoryRepository repo,
      List<HistoryFact> facts) async {
    final r = await editFacts(context, facts);
    if (r == null) return;
    await repo.setFacts(r);
  }

  Future<void> _editNarrative(BuildContext context, HistoryRepository repo,
      List<HistoryParagraph> paragraphs) async {
    final r = await editNarrative(context, paragraphs);
    if (r == null) return;
    await repo.setNarrative(r);
  }

  Future<void> _editStatement(
    BuildContext context,
    HistoryRepository repo, {
    required String title,
    required String en,
    required HistoryContentsCompanion Function(String) apply,
  }) async {
    final r = await editBilingualText(
      context,
      title: title,
      enLabel: context.trRead('English', 'الإنجليزية'),
      initialEn: en,
    );
    if (r == null) return;
    await repo.updateContent(apply(r.$1));
  }
}

// ════════════════════════════ Shared building blocks ════════════════════════

/// A small pencil edit button (shown only when [show]).
class _EditButton extends StatelessWidget {
  const _EditButton({required this.show, required this.onTap, this.light = false});
  final bool show;
  final VoidCallback onTap;
  final bool light;

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();
    return IconButton(
      tooltip: context.tr('Edit', 'تعديل'),
      visualDensity: VisualDensity.compact,
      icon: Icon(Icons.edit_outlined,
          size: 18, color: light ? AppColors.onEmerald : AppColors.emerald),
      onPressed: onTap,
    );
  }
}

/// A consistent section header: an emerald icon chip, a serif title, an optional
/// subtitle, an optional trailing action, and an emerald/gold decorative rule.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.emeraldTint,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: AppColors.emerald, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            ?action,
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 52),
            child: Text(
              subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textMuted),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Container(
              width: 44,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.emerald,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 18,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Container(height: 1, color: AppColors.border)),
          ],
        ),
      ],
    );
  }
}

/// Gently lifts its [child] with a softer/stronger shadow on pointer hover
/// (desktop/web). On touch it simply renders a resting shadow.
class _HoverLift extends StatefulWidget {
  const _HoverLift({required this.child, required this.radius});
  final Widget child;
  final BorderRadius radius;

  @override
  State<_HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<_HoverLift> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: widget.radius,
          boxShadow: [
            BoxShadow(
              color: AppColors.charcoal.withValues(alpha: _hover ? 0.13 : 0.05),
              blurRadius: _hover ? 20 : 10,
              offset: Offset(0, _hover ? 8 : 4),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

// ════════════════════════════ Hero ════════════════════════════

class _FoundingHero extends StatelessWidget {
  const _FoundingHero({
    required this.isArabic,
    required this.content,
    required this.canManage,
    required this.onEdit,
  });
  final bool isArabic;
  final HistoryContent? content;
  final bool canManage;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final text = content?.foundingEn ?? '';
    return ClipRRect(
      borderRadius: AppRadius.panel,
      child: Container(
        constraints: const BoxConstraints(minHeight: 240),
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
                  color: Colors.white, opacity: 0.06, tile: 96),
            ),
            // A soft inner glow toward the trailing edge for depth.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      AppColors.navy.withValues(alpha: 0.0),
                      AppColors.emerald.withValues(alpha: 0.15),
                    ],
                  ),
                ),
              ),
            ),
            if (canManage)
              PositionedDirectional(
                top: AppSpacing.sm,
                end: AppSpacing.sm,
                child: _EditButton(show: true, onTap: onEdit, light: true),
              ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.tr('OUR STORY', 'قصتنا'),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: AppColors.gold, letterSpacing: 1.8),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(width: 32, height: 1.5, color: AppColors.gold),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        context.tr('EST. 1978', '١٩٧٨'),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: AppColors.gold, letterSpacing: 1.8),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: Text(
                      text,
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      style: isArabic
                          ? AppTypography.arabic(
                              fontSize: 24,
                              color: AppColors.onEmerald,
                              height: 1.9)
                          : Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  color: AppColors.onEmerald, height: 1.4),
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

// ════════════════════════════ Quick Facts ════════════════════════════

class _FactsSection extends StatelessWidget {
  const _FactsSection({
    required this.facts,
    required this.isArabic,
    required this.canManage,
    required this.onEdit,
  });
  final List<HistoryFact> facts;
  final bool isArabic;
  final bool canManage;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.insights_outlined,
          title: context.tr('Quick Facts', 'حقائق سريعة'),
          action: _EditButton(show: canManage, onTap: onEdit),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (facts.isEmpty)
          _PlaceholderText(
              text: context.tr('No facts yet.', 'لا توجد حقائق بعد.'))
        else
          LayoutBuilder(
            builder: (context, box) {
              final w = box.maxWidth;
              final columns = w >= 820
                  ? facts.length.clamp(1, 4)
                  : w >= 520
                      ? 2
                      : 1;
              const spacing = AppSpacing.lg;
              final itemW = (w - spacing * (columns - 1)) / columns;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final f in facts)
                    SizedBox(
                      width: itemW,
                      height: 132,
                      child: _HoverLift(
                        radius: AppRadius.card,
                        child: _FactCard(fact: f, isArabic: isArabic),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({required this.fact, required this.isArabic});
  final HistoryFact fact;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final color = Color(fact.accent);
    return ClipRRect(
      borderRadius: AppRadius.card,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 3, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child:
                          Icon(iconForKey(fact.iconKey), color: color, size: 26),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fact.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppTypography.serif,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: AppColors.charcoal,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            fact.en.toUpperCase(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════ Our Story (narrative) ════════════════════════

class _NarrativeSection extends StatelessWidget {
  const _NarrativeSection({
    required this.paragraphs,
    required this.isArabic,
    required this.canManage,
    required this.onEdit,
  });
  final List<HistoryParagraph> paragraphs;
  final bool isArabic;
  final bool canManage;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.menu_book_outlined,
          title: context.tr('Our Story', 'قصتنا'),
          action: _EditButton(show: canManage, onTap: onEdit),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.panel,
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.charcoal.withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: paragraphs.isEmpty
                  ? _PlaceholderText(
                      text: context.tr('No content yet.', 'لا يوجد محتوى بعد.'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < paragraphs.length; i++)
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: i == paragraphs.length - 1
                                    ? 0
                                    : AppSpacing.xl),
                            child: Text(
                              paragraphs[i].en,
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              textAlign:
                                  isArabic ? TextAlign.right : TextAlign.left,
                              style: isArabic
                                  ? AppTypography.arabic(
                                      fontSize: 18,
                                      color: AppColors.charcoal,
                                      height: 2.0)
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(height: 1.9, fontSize: 16.5),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════ Mission & Vision ════════════════════════

class _MissionVisionSection extends StatelessWidget {
  const _MissionVisionSection({
    required this.canManage,
    required this.missionEn,
    required this.visionEn,
    required this.onEditMission,
    required this.onEditVision,
  });
  final bool canManage;
  final String missionEn;
  final String visionEn;
  final VoidCallback onEditMission;
  final VoidCallback onEditVision;

  @override
  Widget build(BuildContext context) {
    final mission = _FeatureCard(
      icon: Icons.track_changes_outlined,
      accent: AppColors.emerald,
      title: context.tr('Mission', 'الرسالة'),
      text: missionEn,
      canManage: canManage,
      onEdit: onEditMission,
    );
    final vision = _FeatureCard(
      icon: Icons.visibility_outlined,
      accent: AppColors.goldDeep,
      title: context.tr('Vision', 'الرؤية'),
      text: visionEn,
      canManage: canManage,
      onEdit: onEditVision,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.explore_outlined,
          title: context.tr('Mission & Vision', 'الرسالة والرؤية'),
        ),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, box) {
            if (box.maxWidth < 720) {
              return Column(
                children: [
                  mission,
                  const SizedBox(height: AppSpacing.lg),
                  vision,
                ],
              );
            }
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: mission),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(child: vision),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.accent,
    required this.title,
    required this.text,
    required this.canManage,
    required this.onEdit,
  });
  final IconData icon;
  final Color accent;
  final String title;
  final String text;
  final bool canManage;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return _HoverLift(
      radius: AppRadius.panel,
      child: ClipRRect(
        borderRadius: AppRadius.panel,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.panel,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Container(height: 4, color: accent),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    if (canManage)
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: _EditButton(show: true, onTap: onEdit),
                      ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: accent, size: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      text.trim().isEmpty ? '—' : text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════ Milestones timeline ════════════════════════

/// The Milestones section — a visual historical timeline with add/edit/delete
/// for executives. Alternating cards on wide screens; single column on mobile.
class _MilestonesTimeline extends StatelessWidget {
  const _MilestonesTimeline({required this.isArabic, required this.canManage});
  final bool isArabic;
  final bool canManage;

  Future<void> _add(BuildContext context, HistoryRepository repo) async {
    final r = await editMilestone(context);
    if (r == null) return;
    await repo.addMilestone(
      year: r.year,
      title: r.title,
      description: r.description,
      iconKey: r.iconKey,
      accent: r.accent,
    );
  }

  Future<void> _edit(
      BuildContext context, HistoryRepository repo, HistoryMilestone m) async {
    final r = await editMilestone(context, existing: (
      year: m.year,
      title: m.title,
      description: m.description,
      iconKey: m.iconKey,
      accent: m.accent,
    ));
    if (r == null) return;
    await repo.updateMilestone(
      m.id,
      year: r.year,
      title: r.title,
      description: r.description,
      iconKey: r.iconKey,
      accent: r.accent,
    );
  }

  Future<void> _delete(
      BuildContext context, HistoryRepository repo, HistoryMilestone m) async {
    final ok = await confirmDialog(context,
        title: context.trRead('Delete milestone?', 'حذف المحطة؟'),
        message: m.title);
    if (ok) await repo.deleteMilestone(m.id);
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<HistoryRepository>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.history_edu_outlined,
          title: context.tr('Milestones', 'المحطات'),
          subtitle: context.tr('Key moments along the journey.',
              'لحظات فارقة على امتداد المسيرة.'),
          action: canManage
              ? FilledButton.icon(
                  onPressed: () => _add(context, repo),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(context.tr('Add', 'إضافة')),
                )
              : null,
        ),
        const SizedBox(height: AppSpacing.xl),
        StreamBuilder<List<HistoryMilestone>>(
          stream: repo.watchMilestones(),
          builder: (context, snap) {
            final items = snap.data ?? const <HistoryMilestone>[];
            if (items.isEmpty) {
              return _PlaceholderText(
                  text: context.tr(
                      'No milestones yet.', 'لا توجد محطات بعد.'));
            }
            return LayoutBuilder(
              builder: (context, box) {
                final wide = box.maxWidth >= 820;
                return Column(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      DocReveal(
                        delayMs: 60 * i,
                        child: _TimelineEntry(
                          milestone: items[i],
                          isArabic: isArabic,
                          canManage: canManage,
                          wide: wide,
                          cardOnStart: i.isEven,
                          isFirst: i == 0,
                          isLast: i == items.length - 1,
                          onEdit: () => _edit(context, repo, items[i]),
                          onDelete: () => _delete(context, repo, items[i]),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

/// A single timeline entry: a centered (wide) or leading (narrow) rail with a
/// circular node, and a milestone card that alternates sides on wide screens.
class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.milestone,
    required this.isArabic,
    required this.canManage,
    required this.wide,
    required this.cardOnStart,
    required this.isFirst,
    required this.isLast,
    required this.onEdit,
    required this.onDelete,
  });
  final HistoryMilestone milestone;
  final bool isArabic;
  final bool canManage;
  final bool wide;
  final bool cardOnStart;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final accent = Color(milestone.accent);
    final card = _MilestoneCard(
      milestone: milestone,
      isArabic: isArabic,
      canManage: canManage,
      accent: accent,
      onEdit: onEdit,
      onDelete: onDelete,
    );
    final rail = _TimelineRail(
        accent: accent,
        icon: iconForKey(milestone.iconKey),
        isFirst: isFirst,
        isLast: isLast);

    if (!wide) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            rail,
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: card,
              ),
            ),
          ],
        ),
      );
    }

    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: cardOnStart ? card : const SizedBox()),
            const SizedBox(width: AppSpacing.lg),
            rail,
            const SizedBox(width: AppSpacing.lg),
            Expanded(child: cardOnStart ? const SizedBox() : card),
          ],
        ),
      ),
    );
  }
}

class _TimelineRail extends StatelessWidget {
  const _TimelineRail({
    required this.accent,
    required this.icon,
    required this.isFirst,
    required this.isLast,
  });
  final Color accent;
  final IconData icon;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      child: Column(
        children: [
          Container(
            width: 2,
            height: 18,
            color: isFirst ? Colors.transparent : AppColors.border,
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: accent, width: 2),
            ),
            child: Icon(icon, size: 22, color: accent),
          ),
          Expanded(
            child: Container(
              width: 2,
              color: isLast ? Colors.transparent : AppColors.border,
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({
    required this.milestone,
    required this.isArabic,
    required this.canManage,
    required this.accent,
    required this.onEdit,
    required this.onDelete,
  });
  final HistoryMilestone milestone;
  final bool isArabic;
  final bool canManage;
  final Color accent;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final title = milestone.title;
    final desc = milestone.description;
    return _HoverLift(
      radius: AppRadius.card,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: 3),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    milestone.year,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const Spacer(),
                if (canManage)
                  SizedBox(
                    height: 22,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.more_vert,
                          size: 18, color: AppColors.textMuted),
                      onSelected: (v) {
                        if (v == 'edit') onEdit();
                        if (v == 'delete') onDelete();
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                            value: 'edit',
                            child: Text(context.trRead('Edit', 'تعديل'))),
                        PopupMenuItem(
                            value: 'delete',
                            child: Text(context.trRead('Delete', 'حذف'))),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              style: isArabic
                  ? AppTypography.arabic(
                      fontSize: 18, fontWeight: FontWeight.w700)
                  : Theme.of(context).textTheme.titleMedium,
            ),
            if (desc.trim().isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                desc,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                style: isArabic
                    ? AppTypography.arabic(
                        fontSize: 15, color: AppColors.textMuted, height: 1.7)
                    : Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════ Leadership Legacy ════════════════════════

/// "Leadership Legacy" — a hand-curated showcase of former leaders. Each entry
/// is entered directly (a typed name + attached photo, no member link), so past
/// leaders who were never in the member registry can still be honored.
/// Executives (manageContent) add / edit / remove; everyone reads.
class _PreviousLeadershipSection extends StatelessWidget {
  const _PreviousLeadershipSection({required this.canManage});
  final bool canManage;

  Future<void> _add(BuildContext context, HistoryRepository repo) async {
    final r = await editLegacyLeader(context);
    if (r == null) return;
    final id = await repo.addLegacyLeader(
      name: r.name,
      position: r.position,
      termYears: r.termYears,
      photoPath: r.photoPath,
      accent: r.accent,
    );
    for (var i = 0; i < r.sections.length; i++) {
      await repo.addLegacySection(
        legacyLeaderId: id,
        title: r.sections[i].title,
        body: r.sections[i].body,
        sortOrder: i,
      );
    }
  }

  Future<void> _edit(BuildContext context, HistoryRepository repo,
      HistoryLegacyLeader leader) async {
    final existingSections = await repo.watchLegacySections(leader.id).first;
    if (!context.mounted) return;
    final r = await editLegacyLeader(context,
        existing: (
          name: leader.name,
          position: leader.position,
          termYears: leader.termYears,
          photoPath: leader.photoPath,
          accent: leader.accent,
          sections: [
            for (final s in existingSections)
              (title: s.title, body: s.body),
          ],
        ));
    if (r == null) return;
    await repo.updateLegacyLeader(
      leader.id,
      name: r.name,
      position: r.position,
      termYears: r.termYears,
      accent: r.accent,
      photoPath: r.photoPath,
    );
    // Reconcile sections: drop the old rows, then re-insert from the form.
    for (final s in await repo.watchLegacySections(leader.id).first) {
      await repo.deleteLegacySection(s.id);
    }
    for (var i = 0; i < r.sections.length; i++) {
      await repo.addLegacySection(
        legacyLeaderId: leader.id,
        title: r.sections[i].title,
        body: r.sections[i].body,
        sortOrder: i,
      );
    }
  }

  Future<void> _delete(BuildContext context, HistoryRepository repo,
      HistoryLegacyLeader leader) async {
    final ok = await confirmDialog(context,
        title: context.trRead('Remove entry?', 'إزالة المُدخل؟'),
        message: leader.name);
    if (ok) await repo.deleteLegacyLeader(leader.id);
  }

  void _openDetail(BuildContext context, HistoryLegacyLeader leader) {
    context.push('/history/legacy/${leader.id}');
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<HistoryRepository>();
    return StreamBuilder<List<HistoryLegacyLeader>>(
      stream: repo.watchLegacyLeaders(),
      builder: (context, snap) {
        final leaders = snap.data ?? const <HistoryLegacyLeader>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.workspace_premium_outlined,
              title: context.tr('Leadership Legacy', 'إرث القيادة'),
              subtitle: context.tr(
                  'Honoring the leaders who guided the organization throughout its history.',
                  'تكريمًا للقادة الذين قادوا المنظمة عبر تاريخها.'),
              action: canManage
                  ? FilledButton.icon(
                      onPressed: () => _add(context, repo),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(context.tr(
                          'Add Former Leader', 'إضافة قائد سابق')),
                    )
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (leaders.isEmpty)
              _PlaceholderText(
                  text: context.tr('No previous leaders recorded yet.',
                      'لم يُسجَّل قادة سابقون بعد.'))
            else
              LayoutBuilder(
                builder: (context, box) {
                  final wide = box.maxWidth >= 820;
                  if (wide) {
                    const spacing = AppSpacing.lg;
                    const cols = 4;
                    final itemW = (box.maxWidth - spacing * (cols - 1)) / cols;

                    // The first card sits alone on the top row; the rest fill
                    // right-aligned rows of four. For seven cards this yields
                    // the 1 / 4 / 2 stagger.
                    final rows = <List<HistoryLegacyLeader>>[
                      [leaders.first],
                      for (var i = 1; i < leaders.length; i += cols)
                        leaders.sublist(i, (i + cols).clamp(0, leaders.length)),
                    ];

                    Widget cardFor(HistoryLegacyLeader l) => SizedBox(
                          width: itemW,
                          child: _HoverLift(
                            radius: AppRadius.panel,
                            child: _LegacyCard(
                              leader: l,
                              canManage: canManage,
                              onTap: () => _openDetail(context, l),
                              onEdit: () => _edit(context, repo, l),
                              onDelete: () => _delete(context, repo, l),
                            ),
                          ),
                        );

                    return Column(
                      children: [
                        for (var r = 0; r < rows.length; r++) ...[
                          if (r > 0) const SizedBox(height: spacing),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var c = 0; c < rows[r].length; c++) ...[
                                if (c > 0) const SizedBox(width: spacing),
                                cardFor(rows[r][c]),
                              ],
                            ],
                          ),
                        ],
                      ],
                    );
                  }
                  // Mobile / tablet: a horizontally scrollable carousel.
                  return SizedBox(
                    height: 320,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: leaders.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.lg),
                      itemBuilder: (context, i) => SizedBox(
                        width: 240,
                        child: _LegacyCard(
                          leader: leaders[i],
                          canManage: canManage,
                          onTap: () => _openDetail(context, leaders[i]),
                          onEdit: () => _edit(context, repo, leaders[i]),
                          onDelete: () => _delete(context, repo, leaders[i]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: AppSpacing.xl),
          ],
        );
      },
    );
  }
}

class _LegacyCard extends StatelessWidget {
  const _LegacyCard({
    required this.leader,
    required this.canManage,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });
  final HistoryLegacyLeader leader;
  final bool canManage;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  /// Initials derived from the free-text name (first + last word, or the first
  /// two letters of a single word).
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _cover(context),
            _body(context),
          ],
        ),
      ),
    );
  }

  /// The portrait cover with an accent wash, an optional manage menu, and the
  /// name overlaid along the bottom.
  Widget _cover(BuildContext context) {
    final color = Color(leader.accent);
    final hasPhoto = leader.photoPath.trim().isNotEmpty &&
        File(leader.photoPath).existsSync();

    final base = hasPhoto
        ? Image.file(File(leader.photoPath), fit: BoxFit.cover)
        : DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withValues(alpha: 0.22),
                  color.withValues(alpha: 0.45),
                ],
              ),
            ),
            child: Align(
              alignment: const Alignment(0, -0.35),
              child: Text(
                _initials,
                style: TextStyle(
                  fontFamily: AppTypography.serif,
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  color: AppColors.surface.withValues(alpha: 0.9),
                ),
              ),
            ),
          );

    return AspectRatio(
      aspectRatio: 1.15,
      child: Stack(
        fit: StackFit.expand,
        children: [
          base,
          // Accent wash + a darker foot so the overlaid name stays legible.
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.10),
                    color.withValues(alpha: 0.30),
                    color.withValues(alpha: 0.92),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          if (canManage)
            PositionedDirectional(
              top: AppSpacing.sm,
              start: AppSpacing.sm,
              child: _manageMenu(context),
            ),
          PositionedDirectional(
            start: AppSpacing.lg,
            end: AppSpacing.lg,
            bottom: AppSpacing.md,
            child: Text(
              leader.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppTypography.serif,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.onEmerald,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The white body: office (small-caps) and term/year, both centered.
  Widget _body(BuildContext context) {
    final hasPosition = leader.position.trim().isNotEmpty;
    final hasTerm = leader.termYears.trim().isNotEmpty;
    // Nothing to show below the portrait — skip the body entirely.
    if (!hasPosition && !hasTerm) return const SizedBox(height: AppSpacing.lg);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasPosition)
            Text(
              leader.position.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textMuted,
                    letterSpacing: 0.8,
                  ),
            ),
          if (hasTerm) ...[
            if (hasPosition) const SizedBox(height: AppSpacing.xs),
            Text(
              leader.termYears,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.emeraldDark,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _manageMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        shape: BoxShape.circle,
      ),
      child: PopupMenuButton<String>(
        tooltip: context.trRead('Manage', 'إدارة'),
        icon: const Icon(Icons.more_vert, size: 18, color: AppColors.charcoal),
        onSelected: (v) {
          if (v == 'edit') onEdit();
          if (v == 'delete') onDelete();
        },
        itemBuilder: (_) => [
          PopupMenuItem(
              value: 'edit', child: Text(context.trRead('Edit', 'تعديل'))),
          PopupMenuItem(
              value: 'delete', child: Text(context.trRead('Delete', 'حذف'))),
        ],
      ),
    );
  }
}

/// A muted placeholder line used by empty sections.
class _PlaceholderText extends StatelessWidget {
  const _PlaceholderText({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: AppColors.textMuted),
    );
  }
}