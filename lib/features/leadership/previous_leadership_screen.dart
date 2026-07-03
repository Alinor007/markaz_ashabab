import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/leader_repository.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/member_picker.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import '../history/history_edit_dialogs.dart' show kHistoryAccents;
import '../tarbiya/widgets/confirm_dialog.dart';
import 'widgets/leader_medallion.dart';

/// One biography section entered in the form (e.g. "Early Life",
/// "Achievements"), bilingual title + body.
typedef _SectionResult = ({
  String title,
  String titleAr,
  String body,
  String bodyAr,
});

/// Result of the Previous Leadership form.
typedef _PrevResult = ({
  Member member,
  String position,
  String positionAr,
  String termYears,
  String note,
  String noteAr,
  int accent,
  List<_SectionResult> sections,
});

/// A group of former leaders sharing the same term/year label.
typedef _TermGroup = ({String label, List<PreviousLeaderView> entries});

/// The first four-digit year in a term string (for sorting), or -1.
int _termYearKey(String term) {
  final m = RegExp(r'(\d{4})').firstMatch(term);
  return m == null ? -1 : int.parse(m.group(1)!);
}

/// Groups entries by their term, newest term first; the undated group last.
List<_TermGroup> _groupByTerm(List<PreviousLeaderView> items, String undated) {
  final map = <String, List<PreviousLeaderView>>{};
  for (final v in items) {
    final key =
        v.entry.termYears.trim().isEmpty ? undated : v.entry.termYears.trim();
    map.putIfAbsent(key, () => []).add(v);
  }
  final groups = [
    for (final e in map.entries) (label: e.key, entries: e.value)
  ];
  groups.sort((a, b) {
    if (a.label == undated) return 1;
    if (b.label == undated) return -1;
    return _termYearKey(b.label).compareTo(_termYearKey(a.label));
  });
  return groups;
}

/// A section header for a term group (e.g. "1998 – 2010").
class _TermHeader extends StatelessWidget {
  const _TermHeader({required this.label, required this.count});
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.event_outlined, size: 18, color: AppColors.goldDeep),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Container(height: 1, color: AppColors.border)),
        const SizedBox(width: AppSpacing.sm),
        Text('$count',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: AppColors.textFaint)),
      ],
    );
  }
}

/// A registry of former leadership office-holders, each linked to an existing
/// member. Executives add / edit / remove entries; others view only.
class PreviousLeadershipScreen extends StatelessWidget {
  const PreviousLeadershipScreen({super.key});

  Future<void> _add(BuildContext context, LeaderRepository repo) async {
    final r = await _showForm(context);
    if (r == null) return;
    final id = await repo.addPreviousLeader(
      memberId: r.member.id,
      position: r.position,
      positionAr: r.positionAr,
      termYears: r.termYears,
      note: r.note,
      noteAr: r.noteAr,
      accent: r.accent,
    );
    for (var i = 0; i < r.sections.length; i++) {
      final s = r.sections[i];
      await repo.addSection(
        previousLeaderId: id,
        title: s.title,
        titleAr: s.titleAr,
        body: s.body,
        bodyAr: s.bodyAr,
        sortOrder: i,
      );
    }
  }

  Future<void> _edit(
      BuildContext context, LeaderRepository repo, PreviousLeaderView v) async {
    final r = await _showForm(context, existing: v);
    if (r == null) return;
    await repo.updatePreviousLeader(
      v.entry.id,
      memberId: r.member.id,
      position: r.position,
      positionAr: r.positionAr,
      termYears: r.termYears,
      note: r.note,
      noteAr: r.noteAr,
      accent: r.accent,
    );
    // Reconcile sections: delete existing rows, then re-add from the form.
    for (final s in await repo.watchSections(v.entry.id).first) {
      await repo.deleteSection(s.id);
    }
    for (var i = 0; i < r.sections.length; i++) {
      final s = r.sections[i];
      await repo.addSection(
        previousLeaderId: v.entry.id,
        title: s.title,
        titleAr: s.titleAr,
        body: s.body,
        bodyAr: s.bodyAr,
        sortOrder: i,
      );
    }
  }

  Future<void> _delete(
      BuildContext context, LeaderRepository repo, PreviousLeaderView v) async {
    final ok = await confirmDialog(context,
        title: context.trRead('Remove entry?', 'إزالة المُدخل؟'),
        message: v.member.displayName(context.isArabic));
    if (ok) await repo.deletePreviousLeader(v.entry.id);
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<LeaderRepository>();
    final canManage =
        context.watch<SessionController>().can?.manageLeadership ?? false;
    return ModulePage(
      english: 'Previous Leadership',
      arabic: 'القيادة السابقة',
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.tr(
                'Former office-holders who have served the organization.',
                'من تولّوا المناصب وخدموا المنظمة سابقًا.'),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textMuted),
          ),
          if (canManage) ...[
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.icon(
                onPressed: () => _add(context, repo),
                icon: const Icon(Icons.add, size: 18),
                label: Text(context.tr('Add Former Leader', 'إضافة قائد سابق')),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          StreamBuilder<List<PreviousLeaderView>>(
            stream: repo.watchPreviousLeaders(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: LoadingState());
              }
              final items = snap.data!;
              if (items.isEmpty) {
                return EmptyState(
                  icon: Icons.history_toggle_off_outlined,
                  title: context.tr(
                      'No former leaders yet', 'لا يوجد قادة سابقون بعد'),
                  message: canManage
                      ? context.tr('Add the first entry.', 'أضف أول مُدخل.')
                      : null,
                );
              }
              final groups = _groupByTerm(
                  items, context.tr('No term recorded', 'بدون مدة'));
              return LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 1000
                      ? 3
                      : constraints.maxWidth > 640
                          ? 2
                          : 1;
                  const spacing = AppSpacing.lg;
                  final itemWidth =
                      (constraints.maxWidth - spacing * (columns - 1)) /
                          columns;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final g in groups) ...[
                        _TermHeader(label: g.label, count: g.entries.length),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            for (final v in g.entries)
                              SizedBox(
                                width: itemWidth,
                                child: _PreviousLeaderCard(
                                  view: v,
                                  canManage: canManage,
                                  onEdit: () => _edit(context, repo, v),
                                  onDelete: () => _delete(context, repo, v),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
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

  Future<_PrevResult?> _showForm(BuildContext context,
      {PreviousLeaderView? existing}) {
    return showDialog<_PrevResult>(
      context: context,
      builder: (_) => _PreviousLeaderForm(existing: existing),
    );
  }
}

class _PreviousLeaderCard extends StatelessWidget {
  const _PreviousLeaderCard({
    required this.view,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });
  final PreviousLeaderView view;
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _cover(context),
          _body(context),
        ],
      ),
    );
  }

  /// The portrait cover with an accent wash, the term pill, and the name +
  /// Arabic name overlaid along the bottom.
  Widget _cover(BuildContext context) {
    final isArabic = context.isArabic;
    final m = view.member;
    final e = view.entry;
    final color = Color(e.accent);
    final hasPhoto = m.photoPath.trim().isNotEmpty &&
        File(m.photoPath).existsSync();

    final base = hasPhoto
        ? Image.file(File(m.photoPath), fit: BoxFit.cover)
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
                m.initials,
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
          InkWell(
            onTap: () => context.push('/leadership/member/${m.id}'),
            child: base,
          ),
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
          if (e.termYears.trim().isNotEmpty)
            PositionedDirectional(
              top: AppSpacing.md,
              end: AppSpacing.md,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.goldDeep,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(e.termYears,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onGold,
                          fontWeight: FontWeight.w700,
                        )),
              ),
            ),
          PositionedDirectional(
            start: AppSpacing.lg,
            end: AppSpacing.lg,
            bottom: AppSpacing.md,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.displayName(isArabic),
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
                if (m.nameAr.trim().isNotEmpty)
                  Text(
                    m.nameAr,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.arabic(
                        fontSize: 15,
                        color: AppColors.onEmerald.withValues(alpha: 0.9)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The white body: office (small-caps), the note, and a View profile action.
  Widget _body(BuildContext context) {
    final isArabic = context.isArabic;
    final e = view.entry;
    final note = isArabic ? e.noteAr : e.note;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (isArabic ? e.positionAr : e.position).toUpperCase(),
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 0.8,
                ),
          ),
          if (note.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              note,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: isArabic
                  ? AppTypography.arabic(fontSize: 15, height: 1.7)
                  : TextStyle(
                      fontFamily: AppTypography.serif,
                      fontSize: 16,
                      color: AppColors.navy,
                      height: 1.5,
                    ),
            ),
          ],
          StreamBuilder<List<PreviousLeaderSection>>(
            stream:
                context.read<LeaderRepository>().watchSections(e.id),
            builder: (context, snap) {
              final sections = snap.data ?? const [];
              if (sections.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final s in sections)
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? s.titleAr : s.title,
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      color: AppColors.textMuted,
                                      letterSpacing: 0.8),
                            ),
                            Text(
                              isArabic ? s.bodyAr : s.body,
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: isArabic
                                  ? AppTypography.arabic(
                                      fontSize: 15, height: 1.7)
                                  : TextStyle(
                                      fontFamily: AppTypography.serif,
                                      fontSize: 16,
                                      color: AppColors.navy,
                                      height: 1.5,
                                    ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(
            onPressed: () =>
                context.push('/leadership/member/${view.member.id}'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              side: const BorderSide(color: AppColors.charcoal),
              foregroundColor: AppColors.charcoal,
            ),
            child: Text(context.tr('View profile', 'عرض الملف')),
          ),
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

/// Mutable biography section row in the form (title + body, bilingual).
class _SectionRow {
  _SectionRow({
    String title = '',
    String titleAr = '',
    String body = '',
    String bodyAr = '',
  })  : title = TextEditingController(text: title),
        titleAr = TextEditingController(text: titleAr),
        body = TextEditingController(text: body),
        bodyAr = TextEditingController(text: bodyAr);
  final TextEditingController title;
  final TextEditingController titleAr;
  final TextEditingController body;
  final TextEditingController bodyAr;

  void dispose() {
    title.dispose();
    titleAr.dispose();
    body.dispose();
    bodyAr.dispose();
  }
}

class _PreviousLeaderForm extends StatefulWidget {
  const _PreviousLeaderForm({this.existing});
  final PreviousLeaderView? existing;

  @override
  State<_PreviousLeaderForm> createState() => _PreviousLeaderFormState();
}

class _PreviousLeaderFormState extends State<_PreviousLeaderForm> {
  late final _position =
      TextEditingController(text: widget.existing?.entry.position ?? '');
  late final _positionAr =
      TextEditingController(text: widget.existing?.entry.positionAr ?? '');
  late final _term =
      TextEditingController(text: widget.existing?.entry.termYears ?? '');
  // Note / Note (Arabic) are no longer edited here (the "Early Life" field was
  // removed — the Biography Sections cover it), but their existing values are
  // preserved unedited through save so nothing is lost.
  late final _note =
      TextEditingController(text: widget.existing?.entry.note ?? '');
  late final _noteAr =
      TextEditingController(text: widget.existing?.entry.noteAr ?? '');
  late int _accent = widget.existing?.entry.accent ?? kHistoryAccents[1];
  Member? _member;
  final List<_SectionRow> _sections = [];

  @override
  void initState() {
    super.initState();
    _member = widget.existing?.member;
    final existing = widget.existing;
    if (existing != null) {
      context.read<LeaderRepository>().watchSections(existing.entry.id).first.then(
        (rows) {
          if (!mounted) return;
          setState(() {
            _sections.addAll(rows.map((s) => _SectionRow(
                  title: s.title,
                  titleAr: s.titleAr,
                  body: s.body,
                  bodyAr: s.bodyAr,
                )));
          });
        },
      );
    }
  }

  @override
  void dispose() {
    for (final c in [_position, _positionAr, _term, _note, _noteAr]) {
      c.dispose();
    }
    for (final s in _sections) {
      s.dispose();
    }
    super.dispose();
  }

  Future<void> _pickMember() async {
    final repo = context.read<MemberRepository>();
    final picked = await pickMember(context, repo,
        title: context.trRead('Choose Member', 'اختر عضوًا'));
    if (picked != null) setState(() => _member = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final member = _member;
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(widget.existing == null
          ? context.tr('Add Former Leader', 'إضافة قائد سابق')
          : context.tr('Edit Former Leader', 'تعديل قائد سابق')),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Member picker.
              InkWell(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                onTap: _pickMember,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      if (member != null)
                        LeaderMedallion(
                            size: 40,
                            assigned: true,
                            initials: member.initials,
                            imagePath: member.photoPath)
                      else
                        const Icon(Icons.person_search_outlined,
                            color: AppColors.emerald),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          member == null
                              ? context.tr('Choose a member…', 'اختر عضوًا…')
                              : member.displayName(isArabic),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Text(
                        member == null
                            ? context.tr('Select', 'اختيار')
                            : context.tr('Change', 'تغيير'),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: AppColors.emerald),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _position,
                decoration: InputDecoration(
                    labelText: context.tr('Position', 'المنصب')),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _positionAr,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                    labelText:
                        context.tr('Position (Arabic)', 'المنصب بالعربية')),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _term,
                decoration: InputDecoration(
                    labelText: context.tr(
                        'Term / Years (e.g. 1983–1990)', 'المدة / السنوات')),
              ),
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(context.tr('Biography Sections', 'أقسام السيرة الذاتية'),
                    style: Theme.of(context).textTheme.labelMedium),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (var i = 0; i < _sections.length; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _sections[i].title,
                              decoration: InputDecoration(
                                  labelText: context.tr(
                                      'Section Title', 'عنوان القسم')),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                color: AppColors.error),
                            onPressed: () => setState(() {
                              _sections[i].dispose();
                              _sections.removeAt(i);
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _sections[i].titleAr,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                            labelText: context.tr(
                                'Section Title (Arabic)', 'عنوان القسم (عربي)')),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _sections[i].body,
                        minLines: 2,
                        maxLines: 5,
                        decoration: InputDecoration(
                            labelText: context.tr('Content', 'المحتوى'),
                            alignLabelWithHint: true),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _sections[i].bodyAr,
                        minLines: 2,
                        maxLines: 5,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                            labelText:
                                context.tr('Content (Arabic)', 'المحتوى (عربي)'),
                            alignLabelWithHint: true),
                      ),
                    ],
                  ),
                ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () => setState(() => _sections.add(_SectionRow())),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(context.tr('Add Section', 'إضافة قسم')),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(context.tr('Accent', 'اللون'),
                    style: Theme.of(context).textTheme.labelMedium),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  for (final accent in kHistoryAccents)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: InkWell(
                        onTap: () => setState(() => _accent = accent),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Color(accent),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _accent == accent
                                  ? AppColors.charcoal
                                  : AppColors.border,
                              width: _accent == accent ? 2.5 : 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('Cancel', 'إلغاء'))),
        FilledButton(
          onPressed: member == null
              ? null
              : () => Navigator.pop(context, (
                    member: member,
                    position: _position.text.trim(),
                    positionAr: _positionAr.text.trim(),
                    termYears: _term.text.trim(),
                    note: _note.text.trim(),
                    noteAr: _noteAr.text.trim(),
                    accent: _accent,
                    sections: [
                      for (final s in _sections)
                        if (s.title.text.trim().isNotEmpty ||
                            s.body.text.trim().isNotEmpty)
                          (
                            title: s.title.text.trim(),
                            titleAr: s.titleAr.text.trim(),
                            body: s.body.text.trim(),
                            bodyAr: s.bodyAr.text.trim(),
                          ),
                    ],
                  )),
          child: Text(context.tr('Save', 'حفظ')),
        ),
      ],
    );
  }
}
