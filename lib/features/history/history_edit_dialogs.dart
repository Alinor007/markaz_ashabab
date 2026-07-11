import 'package:flutter/material.dart';

import '../../core/repositories/history_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/util/icon_catalog.dart';

/// The theme accents offered in history pickers.
const List<int> kHistoryAccents = [
  0xFF0B5D3B, // emerald
  0xFF16243D, // navy
  0xFFA8862F, // gold deep
  0xFF9B2C2C, // error/red
];

/// Result of a milestone form.
typedef MilestoneResult = ({
  String year,
  String title,
  String description,
  String iconKey,
  int accent,
});

/// A text editor dialog. Returns `(text, '')` or null on cancel. (The second
/// tuple slot is retained for call-site compatibility; the app is English-only.)
Future<(String, String)?> editBilingualText(
  BuildContext context, {
  required String title,
  required String enLabel,
  String arLabel = '',
  String initialEn = '',
  String initialAr = '',
  bool multiline = true,
}) async {
  final en = TextEditingController(text: initialEn);
  final result = await showDialog<(String, String)>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(title),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: en,
                minLines: multiline ? 3 : 1,
                maxLines: multiline ? 8 : 1,
                decoration: InputDecoration(
                    labelText: enLabel, alignLabelWithHint: true),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel')),
        FilledButton(
            onPressed: () => Navigator.pop(ctx, (en.text.trim(), '')),
            child: Text('Save')),
      ],
    ),
  );
  en.dispose();
  return result;
}

/// Editor for the History stat cards (add / edit / remove rows).
Future<List<HistoryFact>?> editFacts(
    BuildContext context, List<HistoryFact> initial) {
  return showDialog<List<HistoryFact>>(
    context: context,
    builder: (_) => _FactsEditor(initial: initial),
  );
}

/// Editor for the "Our Story" narrative paragraphs (add / edit / remove).
Future<List<HistoryParagraph>?> editNarrative(
    BuildContext context, List<HistoryParagraph> initial) {
  return showDialog<List<HistoryParagraph>>(
    context: context,
    builder: (_) => _NarrativeEditor(initial: initial),
  );
}

/// Add / edit a single milestone.
Future<MilestoneResult?> editMilestone(
  BuildContext context, {
  MilestoneResult? existing,
}) {
  return showDialog<MilestoneResult>(
    context: context,
    builder: (_) => _MilestoneForm(existing: existing),
  );
}

// ════════════════════════════ Shared pickers ════════════════════════════

class _IconPicker extends StatelessWidget {
  const _IconPicker({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final key in kIconKeys)
          InkWell(
            onTap: () => onChanged(key),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: value == key
                    ? AppColors.emerald.withValues(alpha: 0.15)
                    : AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                    color:
                        value == key ? AppColors.emerald : AppColors.border),
              ),
              child: Icon(iconForKey(key),
                  size: 20,
                  color:
                      value == key ? AppColors.emerald : AppColors.textMuted),
            ),
          ),
      ],
    );
  }
}

class _AccentPicker extends StatelessWidget {
  const _AccentPicker({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final accent in kHistoryAccents)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: InkWell(
              onTap: () => onChanged(accent),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(accent),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: value == accent
                        ? AppColors.charcoal
                        : AppColors.border,
                    width: value == accent ? 2.5 : 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ════════════════════════════ Facts editor ════════════════════════════

class _FactsRow {
  _FactsRow(HistoryFact f)
      : value = TextEditingController(text: f.value),
        en = TextEditingController(text: f.en),
        iconKey = f.iconKey,
        accent = f.accent;
  final TextEditingController value;
  final TextEditingController en;
  String iconKey;
  int accent;

  void dispose() {
    value.dispose();
    en.dispose();
  }

  HistoryFact toFact() => (
        value: value.text.trim(),
        en: en.text.trim(),
        iconKey: iconKey,
        accent: accent,
      );
}

class _FactsEditor extends StatefulWidget {
  const _FactsEditor({required this.initial});
  final List<HistoryFact> initial;

  @override
  State<_FactsEditor> createState() => _FactsEditorState();
}

class _FactsEditorState extends State<_FactsEditor> {
  late final List<_FactsRow> _rows = [
    for (final f in widget.initial) _FactsRow(f)
  ];

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('Edit Stat Cards'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _rows.length; i++) ...[
                if (i > 0) const Divider(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _rows[i].value,
                        decoration: InputDecoration(
                            labelText: 'Value'),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove',
                      icon: const Icon(Icons.remove_circle_outline,
                          color: AppColors.error),
                      onPressed: () => setState(() {
                        _rows[i].dispose();
                        _rows.removeAt(i);
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _rows[i].en,
                  decoration: InputDecoration(
                      labelText: 'Label'),
                ),
                const SizedBox(height: AppSpacing.sm),
                _AccentPicker(
                  value: _rows[i].accent,
                  onChanged: (a) => setState(() => _rows[i].accent = a),
                ),
                const SizedBox(height: AppSpacing.sm),
                _IconPicker(
                  value: _rows[i].iconKey,
                  onChanged: (k) => setState(() => _rows[i].iconKey = k),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () => setState(() => _rows.add(_FactsRow((
                        value: '',
                        en: '',
                        iconKey: 'flag',
                        accent: AppColors.emerald.toARGB32(),
                      )))),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text('Add Card'),
                ),
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
          onPressed: () => Navigator.pop(context, [
            for (final r in _rows)
              if (r.value.text.trim().isNotEmpty || r.en.text.trim().isNotEmpty)
                r.toFact()
          ]),
          child: Text('Save'),
        ),
      ],
    );
  }
}

// ════════════════════════════ Narrative editor ════════════════════════════

class _ParaRow {
  _ParaRow(HistoryParagraph p) : en = TextEditingController(text: p.en);
  final TextEditingController en;

  void dispose() {
    en.dispose();
  }
}

class _NarrativeEditor extends StatefulWidget {
  const _NarrativeEditor({required this.initial});
  final List<HistoryParagraph> initial;

  @override
  State<_NarrativeEditor> createState() => _NarrativeEditorState();
}

class _NarrativeEditorState extends State<_NarrativeEditor> {
  late final List<_ParaRow> _rows = [
    for (final p in widget.initial) _ParaRow(p)
  ];

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('Edit Our Story'),
      content: SizedBox(
        width: 540,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _rows.length; i++) ...[
                if (i > 0) const Divider(height: AppSpacing.xl),
                Row(
                  children: [
                    Text('${'Paragraph'} ${i + 1}',
                        style: Theme.of(context).textTheme.labelMedium),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Remove',
                      icon: const Icon(Icons.remove_circle_outline,
                          color: AppColors.error),
                      onPressed: () => setState(() {
                        _rows[i].dispose();
                        _rows.removeAt(i);
                      }),
                    ),
                  ],
                ),
                TextField(
                  controller: _rows[i].en,
                  minLines: 2,
                  maxLines: 6,
                  decoration: InputDecoration(
                      labelText: 'Text',
                      alignLabelWithHint: true),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () =>
                      setState(() => _rows.add(_ParaRow((en: '')))),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text('Add Paragraph'),
                ),
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
          onPressed: () => Navigator.pop(context, <HistoryParagraph>[
            for (final r in _rows)
              if (r.en.text.trim().isNotEmpty)
                (en: r.en.text.trim())
          ]),
          child: Text('Save'),
        ),
      ],
    );
  }
}

// ════════════════════════════ Milestone form ════════════════════════════

class _MilestoneForm extends StatefulWidget {
  const _MilestoneForm({this.existing});
  final MilestoneResult? existing;

  @override
  State<_MilestoneForm> createState() => _MilestoneFormState();
}

class _MilestoneFormState extends State<_MilestoneForm> {
  late final _year = TextEditingController(text: widget.existing?.year ?? '');
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _desc =
      TextEditingController(text: widget.existing?.description ?? '');
  late String _iconKey = widget.existing?.iconKey ?? 'flag';
  late int _accent = widget.existing?.accent ?? AppColors.emerald.toARGB32();

  @override
  void dispose() {
    for (final c in [_year, _title, _desc]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(widget.existing == null
          ? 'Add Milestone'
          : 'Edit Milestone'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _year,
                decoration: InputDecoration(
                    labelText: 'Year / Label'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _title,
                decoration:
                    InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _desc,
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true),
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('Accent',
                    style: Theme.of(context).textTheme.labelMedium),
              ),
              const SizedBox(height: AppSpacing.sm),
              _AccentPicker(
                  value: _accent, onChanged: (a) => setState(() => _accent = a)),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('Icon',
                    style: Theme.of(context).textTheme.labelMedium),
              ),
              const SizedBox(height: AppSpacing.sm),
              _IconPicker(
                  value: _iconKey, onChanged: (k) => setState(() => _iconKey = k)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.pop(context, (
            year: _year.text.trim(),
            title: _title.text.trim(),
            titleAr: '',
            description: _desc.text.trim(),
            descriptionAr: '',
            iconKey: _iconKey,
            accent: _accent,
          )),
          child: Text('Save'),
        ),
      ],
    );
  }
}
