import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/i18n/localized.dart';
import '../../core/repositories/history_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/util/icon_catalog.dart';
import '../../core/util/photo_service.dart';

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

/// One biography section entered in the Leadership Legacy form (title + body).
typedef LegacySectionResult = ({String title, String body});

/// Result of the hand-curated Leadership Legacy form: a free-text name and an
/// attached photo (no linked member), the office and term shown on the card,
/// and any biography sections.
typedef LegacyLeaderResult = ({
  String name,
  String position,
  String termYears,
  String photoPath,
  int accent,
  List<LegacySectionResult> sections,
});

/// A text editor dialog. Returns `(text, '')` or null on cancel. (The second
/// tuple element is retained as an empty string for call-site compatibility;
/// the app is English-only.)
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
            child: Text(context.tr('Cancel', 'إلغاء'))),
        FilledButton(
            onPressed: () => Navigator.pop(ctx, (en.text.trim(), '')),
            child: Text(context.tr('Save', 'حفظ'))),
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

/// Add / edit a hand-curated Leadership Legacy leader (name + photo + office).
Future<LegacyLeaderResult?> editLegacyLeader(
  BuildContext context, {
  LegacyLeaderResult? existing,
}) {
  return showDialog<LegacyLeaderResult>(
    context: context,
    builder: (_) => _LegacyLeaderForm(existing: existing),
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
      title: Text(context.tr('Edit Stat Cards', 'تعديل البطاقات الإحصائية')),
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
                            labelText: context.tr('Value', 'القيمة')),
                      ),
                    ),
                    IconButton(
                      tooltip: context.tr('Remove', 'إزالة'),
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _rows[i].en,
                        decoration: InputDecoration(
                            labelText: context.tr('Label', 'التسمية')),
                      ),
                    ),
                  ],
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
                  label: Text(context.tr('Add Card', 'إضافة بطاقة')),
                ),
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
          onPressed: () => Navigator.pop(context, [
            for (final r in _rows)
              if (r.value.text.trim().isNotEmpty || r.en.text.trim().isNotEmpty)
                r.toFact()
          ]),
          child: Text(context.tr('Save', 'حفظ')),
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
      title: Text(context.tr('Edit Our Story', 'تعديل قصتنا')),
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
                    Text('${context.tr('Paragraph', 'فقرة')} ${i + 1}',
                        style: Theme.of(context).textTheme.labelMedium),
                    const Spacer(),
                    IconButton(
                      tooltip: context.tr('Remove', 'إزالة'),
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
                      labelText: context.tr('Paragraph', 'الفقرة'),
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
                  label: Text(context.tr('Add Paragraph', 'إضافة فقرة')),
                ),
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
          onPressed: () => Navigator.pop(context, <HistoryParagraph>[
            for (final r in _rows)
              if (r.en.text.trim().isNotEmpty) (en: r.en.text.trim())
          ]),
          child: Text(context.tr('Save', 'حفظ')),
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
          ? context.tr('Add Milestone', 'إضافة محطة')
          : context.tr('Edit Milestone', 'تعديل المحطة')),
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
                    labelText: context.tr('Year / Label', 'السنة / التسمية')),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _title,
                decoration:
                    InputDecoration(labelText: context.tr('Title', 'العنوان')),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _desc,
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                    labelText: context.tr('Description', 'الوصف'),
                    alignLabelWithHint: true),
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(context.tr('Accent', 'اللون'),
                    style: Theme.of(context).textTheme.labelMedium),
              ),
              const SizedBox(height: AppSpacing.sm),
              _AccentPicker(
                  value: _accent, onChanged: (a) => setState(() => _accent = a)),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(context.tr('Icon', 'الأيقونة'),
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
            child: Text(context.tr('Cancel', 'إلغاء'))),
        FilledButton(
          onPressed: () => Navigator.pop(context, (
            year: _year.text.trim(),
            title: _title.text.trim(),
            description: _desc.text.trim(),
            iconKey: _iconKey,
            accent: _accent,
          )),
          child: Text(context.tr('Save', 'حفظ')),
        ),
      ],
    );
  }
}

// ════════════════════════ Leadership Legacy form ════════════════════════

/// A mutable biography section row in the Leadership Legacy form (title + body).
class _LegacySectionRow {
  _LegacySectionRow({String title = '', String body = ''})
      : title = TextEditingController(text: title),
        body = TextEditingController(text: body);
  final TextEditingController title;
  final TextEditingController body;

  void dispose() {
    title.dispose();
    body.dispose();
  }
}

class _LegacyLeaderForm extends StatefulWidget {
  const _LegacyLeaderForm({this.existing});
  final LegacyLeaderResult? existing;

  @override
  State<_LegacyLeaderForm> createState() => _LegacyLeaderFormState();
}

class _LegacyLeaderFormState extends State<_LegacyLeaderForm> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _position =
      TextEditingController(text: widget.existing?.position ?? '');
  late final _term =
      TextEditingController(text: widget.existing?.termYears ?? '');
  late int _accent = widget.existing?.accent ?? kHistoryAccents[1];
  late String _photoPath = widget.existing?.photoPath ?? '';
  late final List<_LegacySectionRow> _sections = [
    for (final s in widget.existing?.sections ?? const <LegacySectionResult>[])
      _LegacySectionRow(title: s.title, body: s.body),
  ];

  @override
  void dispose() {
    for (final c in [_name, _position, _term]) {
      c.dispose();
    }
    for (final s in _sections) {
      s.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final path =
        await const PhotoService().pickAndStore(subfolder: 'legacy_leaders');
    if (path != null && mounted) setState(() => _photoPath = path);
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto =
        _photoPath.trim().isNotEmpty && File(_photoPath).existsSync();
    final color = Color(_accent);
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
              // Portrait picker.
              Center(
                child: Column(
                  children: [
                    InkWell(
                      onTap: _pickPhoto,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                          image: hasPhoto
                              ? DecorationImage(
                                  image: FileImage(File(_photoPath)),
                                  fit: BoxFit.cover)
                              : null,
                        ),
                        child: hasPhoto
                            ? null
                            : const Icon(Icons.add_a_photo_outlined,
                                color: AppColors.emerald, size: 28),
                      ),
                    ),
                    TextButton(
                      onPressed: _pickPhoto,
                      child: Text(hasPhoto
                          ? context.tr('Change Photo', 'تغيير الصورة')
                          : context.tr('Attach Photo', 'إرفاق صورة')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    labelText: context.tr('Full Name', 'الاسم الكامل')),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _position,
                decoration: InputDecoration(
                    labelText: context.tr('Position', 'المنصب')),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _term,
                decoration: InputDecoration(
                    labelText: context.tr(
                        'Term / Years (e.g. 2023–2024)', 'المدة / السنوات')),
              ),
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                    context.tr('Biography Sections', 'أقسام السيرة الذاتية'),
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
                        controller: _sections[i].body,
                        minLines: 2,
                        maxLines: 5,
                        decoration: InputDecoration(
                            labelText: context.tr('Content', 'المحتوى'),
                            alignLabelWithHint: true),
                      ),
                    ],
                  ),
                ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () =>
                      setState(() => _sections.add(_LegacySectionRow())),
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
              _AccentPicker(
                  value: _accent, onChanged: (a) => setState(() => _accent = a)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('Cancel', 'إلغاء'))),
        // Save is enabled only once a name has been entered.
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _name,
          builder: (context, value, _) => FilledButton(
            onPressed: value.text.trim().isEmpty
                ? null
                : () => Navigator.pop(context, (
                      name: _name.text.trim(),
                      position: _position.text.trim(),
                      termYears: _term.text.trim(),
                      photoPath: _photoPath,
                      accent: _accent,
                      sections: [
                        for (final s in _sections)
                          if (s.title.text.trim().isNotEmpty ||
                              s.body.text.trim().isNotEmpty)
                            (
                              title: s.title.text.trim(),
                              body: s.body.text.trim(),
                            ),
                      ],
                    )),
            child: Text(context.tr('Save', 'حفظ')),
          ),
        ),
      ],
    );
  }
}
