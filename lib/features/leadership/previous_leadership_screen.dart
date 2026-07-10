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

/// The row-size pattern for the Previous Leadership grid: 1 card on the first
/// row, 4 on the second, 2 on the third — then repeating for any overflow.
const List<int> _rowPattern = [1, 3, 2];

/// Splits [items] into consecutive rows whose sizes cycle through [pattern]
/// (e.g. 1, 4, 2, 1, 4, 2, …). The final row may be short.
List<List<T>> _chunkByPattern<T>(List<T> items, List<int> pattern) {
  final rows = <List<T>>[];
  var index = 0;
  var rowIndex = 0;
  while (index < items.length) {
    final size = pattern[rowIndex % pattern.length];
    final end =
        (index + size < items.length) ? index + size : items.length;
    rows.add(items.sublist(index, end));
    index = end;
    rowIndex++;
  }
  return rows;
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
        title: 'Remove entry?',
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
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Former office-holders who have served the organization.',
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
                label: Text('Add Former Leader'),
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
                  title: 'No former leaders yet',
                  message: canManage
                      ? 'Add the first entry.'
                      : null,
                );
              }
              // Rank-ordered rows following the 1 → 4 → 2 pattern (repeating),
              // each row centered — mirroring the Leadership screen's pyramid.
              final rows = _chunkByPattern(items, _rowPattern);
              return Column(
                children: [
                  for (var r = 0; r < rows.length; r++) ...[
                    if (r > 0) const SizedBox(height: AppSpacing.xl),
                    _PreviousLeaderRow(
                      entries: rows[r],
                      prominent: rows[r].length == 1,
                      canManage: canManage,
                      onEdit: (v) => _edit(context, repo, v),
                      onDelete: (v) => _delete(context, repo, v),
                    ),
                  ],
                ],
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

/// One centered row of former-leader cards. A single-card row (the lone top
/// entry) gets a wider "prominent" treatment; multi-card rows share the width
/// evenly and wrap gracefully on narrow screens. Mirrors the Leadership
/// screen's `_PyramidRow`.
class _PreviousLeaderRow extends StatelessWidget {
  const _PreviousLeaderRow({
    required this.entries,
    required this.prominent,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });

  final List<PreviousLeaderView> entries;
  final bool prominent;
  final bool canManage;
  final void Function(PreviousLeaderView) onEdit;
  final void Function(PreviousLeaderView) onDelete;

  /// Smallest a card may shrink to before the row is allowed to wrap onto a
  /// second line (narrow / mobile screens).
  static const double _minCardWidth = 220.0;

  @override
  Widget build(BuildContext context) {
    final idealWidth = prominent ? 360.0 : 280.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = entries.length;
        final fitWidth = count > 1
            ? (constraints.maxWidth - AppSpacing.lg * (count - 1)) / count
            : idealWidth;
        final cardWidth = fitWidth >= _minCardWidth
            ? (fitWidth < idealWidth ? fitWidth : idealWidth)
            : idealWidth;
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            for (final v in entries)
              SizedBox(
                width: cardWidth,
                child: _PreviousLeaderCard(
                  view: v,
                  canManage: canManage,
                  onEdit: () => onEdit(v),
                  onDelete: () => onDelete(v),
                ),
              ),
          ],
        );
      },
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
/// The portrait cover with an accent wash, and the name +
  /// Arabic name overlaid along the bottom.
  Widget _cover(BuildContext context) {
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
          // NOTE: term/year pill removed from here — it now lives in the
          // body, centered below the position.
       
        ],
      ),
    );
  }

  /// The white body: office (centered), term/year (centered), the note,
  /// and a centered View profile action.
  Widget _body(BuildContext context) {
    final e = view.entry;
    final note =e.note;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Position — centered.
          Text(
            ( e.position).toUpperCase(),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 0.8,
                ),
          ),
          // Term / Year — centered, directly below the position.
          if (e.termYears.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              e.termYears,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.goldDeep,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
          if (note.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              note,
              textDirection: TextDirection.ltr,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
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
                              s.title,
                              textDirection: TextDirection.ltr,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      color: AppColors.textMuted,
                                      letterSpacing: 0.8),
                            ),
                            Text(
                              s.body,
                              textDirection: TextDirection.ltr,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
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
          // View profile — centered.
          Center(
            child: OutlinedButton(
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
              child: Text('View profile'),
            ),
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
        tooltip: 'Manage',
        icon: const Icon(Icons.more_vert, size: 18, color: AppColors.charcoal),
        onSelected: (v) {
          if (v == 'edit') onEdit();
          if (v == 'delete') onDelete();
        },
        itemBuilder: (_) => [
          PopupMenuItem(
              value: 'edit', child: Text('Edit')),
          PopupMenuItem(
              value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }
}

/// Mutable biography section row in the form (title + body).
class _SectionRow {
  _SectionRow({
    String title = '',
    String body = '',
  })  : title = TextEditingController(text: title),
        body = TextEditingController(text: body);
  final TextEditingController title;
  final TextEditingController body;

  void dispose() {
    title.dispose();
    body.dispose();
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
  late final _term =
      TextEditingController(text: widget.existing?.entry.termYears ?? '');
  // The note field is no longer edited here (the "Early Life" field was
  // removed — the Biography Sections cover it), but the existing English value
  // is preserved unedited through save so nothing is lost.
  late final _note =
      TextEditingController(text: widget.existing?.entry.note ?? '');
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
                  body: s.body,
                )));
          });
        },
      );
    }
  }

  @override
  void dispose() {
    for (final c in [_position, _term, _note]) {
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
        title: 'Choose Member');
    if (picked != null) setState(() => _member = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final member = _member;
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(widget.existing == null
          ? 'Add Former Leader'
          : 'Edit Former Leader'),
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
                              ? 'Choose a member…'
                              : member.displayName(isArabic),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Text(
                        member == null
                            ? 'Select'
                            : 'Change',
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
                    labelText: 'Position'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _term,
                decoration: InputDecoration(
                    labelText: 'Term / Years (e.g. 1983–1990)'),
              ),
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('Biography Sections',
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
                                  labelText: 'Section Title'),
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
                        controller: _sections[i].body,
                        minLines: 2,
                        maxLines: 5,
                        decoration: InputDecoration(
                            labelText: 'Content',
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
                  label: Text('Add Section'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('Accent',
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
            child: Text('Cancel')),
        FilledButton(
          onPressed: member == null
              ? null
              : () => Navigator.pop(context, (
                    member: member,
                    position: _position.text.trim(),
                    positionAr: '',
                    termYears: _term.text.trim(),
                    note: _note.text.trim(),
                    noteAr: '',
                    accent: _accent,
                    sections: [
                      for (final s in _sections)
                        if (s.title.text.trim().isNotEmpty ||
                            s.body.text.trim().isNotEmpty)
                          (
                            title: s.title.text.trim(),
                            titleAr: '',
                            body: s.body.text.trim(),
                            bodyAr: '',
                          ),
                    ],
                  )),
          child: Text('Save'),
        ),
      ],
    );
  }
}
