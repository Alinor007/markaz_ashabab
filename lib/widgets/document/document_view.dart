import 'package:flutter/material.dart';

import '../../core/i18n/localized.dart';
import '../../core/patterns/geometric_pattern.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// ════════════════════════════════════════════════════════════════════════
/// Document view kit — an "official archival dossier" component set for the
/// read-only Program Proposal (P-1) and Program Completion Report (P-2) screens.
///
/// Deliberately NOT the person-profile look (`ProfileHeader` / `InfoPanel`):
/// a parchment masthead with a form stamp and gold double-rules, white section
/// cards with lettered index markers, definition fields, and diamond bullets —
/// all from the existing theme tokens. Use these instead of profile widgets so a
/// report reads like a formal document, not a member page.
/// ════════════════════════════════════════════════════════════════════════

/// A single key fact in the masthead's meta strip.
class DocMeta {
  const DocMeta(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;
}

/// The formal document header: parchment panel, emerald top bar, faint star
/// watermark, an eyebrow + "FORM …" stamp, a serif title, a gold double rule,
/// and a meta strip of key facts. Replaces `ProfileHeader` for documents.
class DocMasthead extends StatelessWidget {
  const DocMasthead({
    super.key,
    required this.formCode,
    required this.eyebrowEn,
    required this.eyebrowAr,
    required this.title,
    required this.meta,
    this.accent = AppColors.emerald,
  });

  final String formCode;
  final String eyebrowEn;
  final String eyebrowAr;
  final String title;
  final List<DocMeta> meta;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return ClipRRect(
      borderRadius: AppRadius.panel,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: AppRadius.panel,
          border: Border.all(color: AppColors.borderStrong),
        ),
        child: Stack(
          children: [
            // Thin structural accent along the top edge.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(height: 4, color: accent),
            ),
            // Faint geometric watermark in the top-trailing corner.
            PositionedDirectional(
              top: -24,
              end: -24,
              child: SizedBox(
                width: 200,
                height: 160,
                child: GeometricPattern(
                    color: accent, opacity: 0.05, tile: 64),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl,
                  AppSpacing.xl, AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          (isArabic ? eyebrowAr : eyebrowEn).toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: AppColors.goldDeep,
                                letterSpacing: 1.4,
                              ),
                        ),
                      ),
                      _FormStamp(code: formCode),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    title,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: isArabic
                        ? AppTypography.arabic(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.charcoal)
                        : Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const _GoldDoubleRule(),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.xxl,
                    runSpacing: AppSpacing.md,
                    children: [for (final m in meta) _MetaItem(meta: m)],
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

class _FormStamp extends StatelessWidget {
  const _FormStamp({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.gold, width: 1.4),
        color: AppColors.goldTint.withValues(alpha: 0.5),
      ),
      child: Text(
        '${context.tr('FORM', 'نموذج')} $code',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.goldDeep,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.meta});
  final DocMeta meta;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(meta.icon, size: AppIconSize.sm, color: AppColors.goldDeep),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meta.label.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.textFaint),
            ),
            const SizedBox(height: 1),
            Text(
              meta.value.trim().isEmpty ? '—' : meta.value,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ],
    );
  }
}

/// Two stacked hairlines (gold) — the document's signature divider.
class _GoldDoubleRule extends StatelessWidget {
  const _GoldDoubleRule();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 1, color: AppColors.gold),
        const SizedBox(height: 2),
        Container(height: 1, color: AppColors.gold.withValues(alpha: 0.4)),
      ],
    );
  }
}

/// A document section: white card with a lettered index marker (A, B, C…) and an
/// uppercase title over a hairline rule. Replaces `InfoPanel` for documents.
class DocSection extends StatelessWidget {
  const DocSection({
    super.key,
    required this.letter,
    required this.title,
    required this.child,
  });

  final String letter;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.panel,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.emeraldTint,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  letter,
                  style: TextStyle(
                    fontFamily: AppTypography.serif,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.emerald,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.charcoal,
                        letterSpacing: 1.0,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

/// A labelled value cell: uppercase small-caps label over a serif value.
/// Empty values render an em dash. Replaces the screens' local `_Field`.
class DocField extends StatelessWidget {
  const DocField(this.label, this.value, {super.key, this.width = 240});
  final String label;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final empty = value.trim().isEmpty;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.textFaint),
          ),
          const SizedBox(height: 3),
          Text(
            empty ? '—' : value,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: empty
                ? Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.textFaint)
                : TextStyle(
                    fontFamily: AppTypography.serif,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                    height: 1.3,
                  ),
          ),
        ],
      ),
    );
  }
}

/// A free-text paragraph block (sans, comfortable height, RTL-aware).
class DocProse extends StatelessWidget {
  const DocProse(this.text, {super.key, this.label});
  final String text;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.textFaint),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Text(
          text.trim().isEmpty ? '—' : text,
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          style: isArabic
              ? AppTypography.arabic(fontSize: 16, height: 1.9)
              : Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

/// A bulleted list with small gold diamond markers (echoing the geometric
/// motif). Renders Amiri RTL for Arabic. Replaces `BulletList` for documents.
class DocBullets extends StatelessWidget {
  const DocBullets({super.key, required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Transform.rotate(
                    angle: 0.785398, // 45° — a small diamond.
                    child: Container(
                      width: 6,
                      height: 6,
                      color: AppColors.gold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    item,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: isArabic
                        ? AppTypography.arabic(fontSize: 16, height: 1.8)
                        : Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// A colored status pill (caller supplies the label and semantic color).
class DocStatusPill extends StatelessWidget {
  const DocStatusPill({super.key, required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// A bordered stat cell: a large serif number over a small-caps caption.
class DocMetric extends StatelessWidget {
  const DocMetric({
    super.key,
    required this.value,
    required this.caption,
    this.accent = AppColors.emerald,
  });
  final String value;
  final String caption;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.trim().isEmpty ? '—' : value,
            style: TextStyle(
              fontFamily: AppTypography.serif,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: accent,
              height: 1.0,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            caption.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

/// Fades + translates a child up once on mount, after [delayMs]. Used to stagger
/// a document's sections into a single orchestrated page-load.
class DocReveal extends StatefulWidget {
  const DocReveal({super.key, required this.child, this.delayMs = 0});
  final Widget child;
  final int delayMs;

  @override
  State<DocReveal> createState() => _DocRevealState();
}

class _DocRevealState extends State<DocReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 420));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.04),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
