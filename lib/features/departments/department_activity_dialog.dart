import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// One Timeline row in the proposal: an activity with a date and a responsible
/// person.
class TimelineItem {
  TimelineItem({this.name = '', this.date = '', this.responsible = ''});
  String name;
  String date;
  String responsible;

  Map<String, dynamic> toJson() =>
      {'name': name, 'date': date, 'responsible': responsible};
  factory TimelineItem.fromJson(Map<String, dynamic> j) => TimelineItem(
        name: j['name'] ?? '',
        date: j['date'] ?? '',
        responsible: j['responsible'] ?? '',
      );
}

/// Structured Program Proposal (Form P-1) payload. Serialized to JSON and stored
/// in `dept_activities.formData`.
class ProgramProposal {
  ProgramProposal({
    this.programTitle = '',
    this.proposedDate = '',
    this.venue = '',
    this.targetParticipants = '',
    this.expectedParticipants = '',
    List<String>? objectives,
    this.problem = '',
    this.relevance = '',
    this.programDescription = '',
    List<String>? keyActivities,
    Set<String>? coordination,
    this.selfReliance = '',
    this.adminAssistance = '',
    List<String>? equipment,
    List<TimelineItem>? timeline,
    this.output = '',
    this.outcome = '',
  })  : objectives = objectives ?? [],
        keyActivities = keyActivities ?? [],
        coordination = coordination ?? {},
        equipment = equipment ?? [],
        timeline = timeline ?? [];

  // A. Basic Information
  String programTitle;
  String proposedDate;
  String venue;
  String targetParticipants;
  String expectedParticipants;

  // B. Objectives
  List<String> objectives;

  // C. Justification
  String problem;
  String relevance;

  // D. Program Details
  String programDescription;
  List<String> keyActivities;

  // E. Coordination Requirement (department keys)
  Set<String> coordination;

  // F. Resources
  String selfReliance;
  String adminAssistance;
  List<String> equipment;

  // G. Timeline
  List<TimelineItem> timeline;

  // H. Expected
  String output;
  String outcome;

  /// The standing coordination departments: (key, English, Arabic).
  static const coordinationOptions = [
    ('dawah', 'Dawah Department', 'قسم الدعوة'),
    ('women', "Women's Department", 'قسم المرأة'),
    ('economic', 'Economic Department', 'القسم الاقتصادي'),
    ('education', 'Education Department', 'قسم التعليم'),
    ('student', 'Student Department', 'قسم الطلاب'),
    ('social', 'Social Work', 'العمل الاجتماعي'),
    ('human', 'Human Capital', 'رأس المال البشري'),
  ];

  /// Equipment seeded into a brand-new proposal.
  static const defaultEquipment = ['Car', 'Sound System'];

  Map<String, dynamic> toJson() => {
        'programTitle': programTitle,
        'proposedDate': proposedDate,
        'venue': venue,
        'targetParticipants': targetParticipants,
        'expectedParticipants': expectedParticipants,
        'objectives': objectives,
        'problem': problem,
        'relevance': relevance,
        'programDescription': programDescription,
        'keyActivities': keyActivities,
        'coordination': coordination.toList(),
        'selfReliance': selfReliance,
        'adminAssistance': adminAssistance,
        'equipment': equipment,
        'timeline': timeline.map((t) => t.toJson()).toList(),
        'output': output,
        'outcome': outcome,
      };

  factory ProgramProposal.fromJson(Map<String, dynamic> j) {
    List<String> list(String k) =>
        (j[k] as List?)?.map((e) => '$e').toList() ?? [];
    return ProgramProposal(
      programTitle: j['programTitle'] ?? '',
      proposedDate: j['proposedDate'] ?? '',
      venue: j['venue'] ?? '',
      targetParticipants: j['targetParticipants'] ?? '',
      expectedParticipants: j['expectedParticipants'] ?? '',
      objectives: list('objectives'),
      problem: j['problem'] ?? '',
      relevance: j['relevance'] ?? '',
      programDescription: j['programDescription'] ?? '',
      keyActivities: list('keyActivities'),
      coordination: list('coordination').toSet(),
      selfReliance: j['selfReliance'] ?? '',
      adminAssistance: j['adminAssistance'] ?? '',
      equipment: list('equipment'),
      timeline: (j['timeline'] as List?)
              ?.map((e) => TimelineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      output: j['output'] ?? '',
      outcome: j['outcome'] ?? '',
    );
  }
}

/// Result of the activity form — the P-1 data plus the header fields the
/// `dept_activities` row stores.
class ActivityFormResult {
  ActivityFormResult({required this.data});
  final ProgramProposal data;

  String get title => data.programTitle;
  String get description => data.programDescription;
  String get date => data.proposedDate;
  String get status => 'planned';
  int get attendance => 0;
  String get formData => jsonEncode(data.toJson());
}

/// Shows the Program Proposal (Form P-1). [department] is auto-filled (not
/// user-entered); pass [existing] to edit.
Future<ActivityFormResult?> showActivityForm(
  BuildContext context, {
  required Department department,
  DeptActivity? existing,
}) {
  return showDialog<ActivityFormResult>(
    context: context,
    builder: (_) => _ActivityFormDialog(department: department, existing: existing),
  );
}

class _ActivityFormDialog extends StatefulWidget {
  const _ActivityFormDialog({required this.department, this.existing});
  final Department department;
  final DeptActivity? existing;

  @override
  State<_ActivityFormDialog> createState() => _ActivityFormDialogState();
}

class _ActivityFormDialogState extends State<_ActivityFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _programTitle = _c();
  late final _venue = _c();
  late final _target = _c();
  late final _expected = _c();
  late final _problem = _c();
  late final _relevance = _c();
  late final _description = _c();
  late final _selfReliance = _c();
  late final _adminAssistance = _c();
  late final _output = _c();
  late final _outcome = _c();

  final _objectives = <TextEditingController>[];
  final _keyActivities = <TextEditingController>[];
  final _equipment = <TextEditingController>[];
  final _timeline = <_TimelineRow>[];
  final _coordination = <String>{};

  String _proposedDate = '';

  TextEditingController _c([String v = '']) => TextEditingController(text: v);

  @override
  void initState() {
    super.initState();
    final raw = widget.existing?.formData ?? '';
    final p = raw.isNotEmpty
        ? ProgramProposal.fromJson(jsonDecode(raw) as Map<String, dynamic>)
        : ProgramProposal(
            programTitle: widget.existing?.title ?? '',
            programDescription: widget.existing?.description ?? '',
            proposedDate: widget.existing?.date ?? '',
            // Pre-seed equipment only for a brand-new proposal.
            equipment: widget.existing == null
                ? List.of(ProgramProposal.defaultEquipment)
                : [],
          );
    _programTitle.text = p.programTitle;
    _venue.text = p.venue;
    _target.text = p.targetParticipants;
    _expected.text = p.expectedParticipants;
    _problem.text = p.problem;
    _relevance.text = p.relevance;
    _description.text = p.programDescription;
    _selfReliance.text = p.selfReliance;
    _adminAssistance.text = p.adminAssistance;
    _output.text = p.output;
    _outcome.text = p.outcome;
    _proposedDate = p.proposedDate;
    _coordination.addAll(p.coordination);
    for (final v in p.objectives) {
      _objectives.add(_c(v));
    }
    for (final v in p.keyActivities) {
      _keyActivities.add(_c(v));
    }
    for (final v in p.equipment) {
      _equipment.add(_c(v));
    }
    for (final t in p.timeline) {
      _timeline.add(_TimelineRow(
          name: t.name, date: t.date, responsible: t.responsible));
    }
  }

  @override
  void dispose() {
    for (final c in [
      _programTitle, _venue, _target, _expected, _problem, _relevance,
      _description, _selfReliance, _adminAssistance, _output, _outcome,
    ]) {
      c.dispose();
    }
    for (final list in [_objectives, _keyActivities, _equipment]) {
      for (final c in list) {
        c.dispose();
      }
    }
    for (final t in _timeline) {
      t.dispose();
    }
    super.dispose();
  }

  Future<String?> _pickDate(String current) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(current) ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 3),
    );
    return picked?.toIso8601String().split('T').first;
  }

  List<String> _values(List<TextEditingController> list) =>
      list.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final data = ProgramProposal(
      programTitle: _programTitle.text.trim(),
      proposedDate: _proposedDate,
      venue: _venue.text.trim(),
      targetParticipants: _target.text.trim(),
      expectedParticipants: _expected.text.trim(),
      objectives: _values(_objectives),
      problem: _problem.text.trim(),
      relevance: _relevance.text.trim(),
      programDescription: _description.text.trim(),
      keyActivities: _values(_keyActivities),
      coordination: _coordination,
      selfReliance: _selfReliance.text.trim(),
      adminAssistance: _adminAssistance.text.trim(),
      equipment: _values(_equipment),
      timeline: [
        for (final t in _timeline)
          if (t.name.text.trim().isNotEmpty ||
              t.date.isNotEmpty ||
              t.responsible.text.trim().isNotEmpty)
            TimelineItem(
                name: t.name.text.trim(),
                date: t.date,
                responsible: t.responsible.text.trim()),
      ],
      output: _output.text.trim(),
      outcome: _outcome.text.trim(),
    );
    Navigator.pop(context, ActivityFormResult(data: data));
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: 680, maxHeight: media.size.height * 0.9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr('Program Proposal Form (Form P-1)',
                          'نموذج مقترح برنامج (نموذج P-1)'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg,
                      AppSpacing.xl, AppSpacing.lg + media.viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _sections(context),
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(context.tr('Cancel', 'إلغاء'))),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined, size: 18),
                    label: Text(context.tr('Save Proposal', 'حفظ المقترح')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _sections(BuildContext context) {
    return [
      // Department — auto-filled, read-only.
      InputDecorator(
        decoration: _dec(context.tr('Department', 'القسم')),
        child: Text(widget.department.displayName(context.isArabic),
            style: Theme.of(context).textTheme.bodyLarge),
      ),

      _section('A', context.tr('Basic Information', 'المعلومات الأساسية')),
      _field(_programTitle, context.tr('Program Title', 'عنوان البرنامج'),
          required: true),
      _row2(
        _dateField(context),
        _field(_venue, context.tr('Venue / Location', 'المكان / الموقع')),
      ),
      _row2(
        _field(_target,
            context.tr('Target Participants', 'المشاركون المستهدفون')),
        _field(_expected,
            context.tr('Expected Number of Participants', 'العدد المتوقع للمشاركين'),
            keyboard: TextInputType.number),
      ),

      _section('B', context.tr('Objectives', 'الأهداف')),
      _list(context,
          context.tr('What do you want to achieve?', 'ما الذي تريد تحقيقه؟'),
          _objectives),

      _section('C', context.tr('Justification', 'المبررات')),
      _field(_problem,
          context.tr('Problem Being Addressed', 'المشكلة المراد معالجتها'),
          lines: 2),
      _field(
          _relevance,
          context.tr('Relevance to Markazosshabab Mission',
              'الصلة برسالة مركز الشباب'),
          lines: 2),

      _section('D', context.tr('Program Details', 'تفاصيل البرنامج')),
      _field(_description,
          context.tr('Program Description', 'وصف البرنامج'), lines: 3),
      _list(context, context.tr('Key Activities', 'الأنشطة الرئيسية'),
          _keyActivities),

      _section('E',
          context.tr('Coordination Requirement', 'متطلبات التنسيق')),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: [
          for (final (key, en, ar) in ProgramProposal.coordinationOptions)
            FilterChip(
              label: Text(context.tr(en, ar)),
              selected: _coordination.contains(key),
              onSelected: (sel) => setState(() =>
                  sel ? _coordination.add(key) : _coordination.remove(key)),
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),

      _section('F', context.tr('Resources', 'الموارد')),
      Text(context.tr('Budget Needed', 'الميزانية المطلوبة'),
          style: Theme.of(context).textTheme.labelMedium),
      const SizedBox(height: AppSpacing.sm),
      _row2(
        _field(_selfReliance,
            context.tr('Self-Reliance — Amount', 'الاعتماد الذاتي — المبلغ'),
            keyboard: TextInputType.number),
        _field(
            _adminAssistance,
            context.tr('Assistance from Admin — Amount',
                'مساعدة من الإدارة — المبلغ'),
            keyboard: TextInputType.number),
      ),
      _list(context,
          context.tr('Equipment / Materials Needed', 'المعدات / المواد المطلوبة'),
          _equipment),

      _section('G', context.tr('Timeline', 'الجدول الزمني')),
      _timelineSection(context),

      _section('H', context.tr('Expected', 'المتوقع')),
      _field(_output,
          context.tr('Output (Short-term results)', 'المخرجات (نتائج قصيرة المدى)'),
          lines: 2),
      _field(
          _outcome,
          context.tr('Outcome (Long-term impact / Changes)',
              'النتائج (أثر طويل المدى / تغييرات)'),
          lines: 2),
    ];
  }

  // ── Building blocks ────────────────────────────────────────────────────────
  Widget _section(String letter, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: AppColors.emerald, shape: BoxShape.circle),
            child: Text(letter,
                style: const TextStyle(
                    color: AppColors.onEmerald, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.navy, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  InputDecoration _dec(String label) =>
      InputDecoration(labelText: label, isDense: true);

  Widget _field(
    TextEditingController controller,
    String label, {
    bool required = false,
    int lines = 1,
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        minLines: lines,
        maxLines: lines == 1 ? 1 : lines + 2,
        keyboardType: keyboard ?? (lines > 1 ? TextInputType.multiline : null),
        decoration: _dec(label),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty)
                ? context.trRead('Required', 'مطلوب')
                : null
            : null,
      ),
    );
  }

  Widget _dateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () async {
          final picked = await _pickDate(_proposedDate);
          if (picked != null) setState(() => _proposedDate = picked);
        },
        child: InputDecorator(
          decoration: _dec(context.tr('Proposed Date', 'التاريخ المقترح')).copyWith(
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18)),
          child: Text(_proposedDate.isEmpty ? '—' : _proposedDate),
        ),
      ),
    );
  }

  Widget _row2(Widget a, Widget b) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: b),
      ],
    );
  }

  Widget _list(
      BuildContext context, String label, List<TextEditingController> list) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: AppSpacing.xs),
          for (var i = 0; i < list.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: list[i], decoration: _dec('$label ${i + 1}')),
                  ),
                  IconButton(
                    tooltip: context.tr('Remove', 'إزالة'),
                    icon: const Icon(Icons.remove_circle_outline,
                        size: 20, color: AppColors.error),
                    onPressed: () => setState(() {
                      list[i].dispose();
                      list.removeAt(i);
                    }),
                  ),
                ],
              ),
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => setState(() => list.add(_c())),
              icon: const Icon(Icons.add, size: 18),
              label: Text(context.tr('Add', 'إضافة')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _timeline.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: AppRadius.card,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _timeline[i].name,
                        decoration:
                            _dec(context.tr('Activity Name', 'اسم النشاط')),
                      ),
                    ),
                    IconButton(
                      tooltip: context.tr('Remove', 'إزالة'),
                      icon: const Icon(Icons.remove_circle_outline,
                          size: 20, color: AppColors.error),
                      onPressed: () => setState(() {
                        _timeline[i].dispose();
                        _timeline.removeAt(i);
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _row2(
                  InkWell(
                    onTap: () async {
                      final picked = await _pickDate(_timeline[i].date);
                      if (picked != null) {
                        setState(() => _timeline[i].date = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: _dec(context.tr('Date', 'التاريخ')).copyWith(
                          suffixIcon: const Icon(Icons.calendar_today_outlined,
                              size: 18)),
                      child: Text(
                          _timeline[i].date.isEmpty ? '—' : _timeline[i].date),
                    ),
                  ),
                  TextField(
                    controller: _timeline[i].responsible,
                    decoration: _dec(
                        context.tr('Responsible Person', 'الشخص المسؤول')),
                  ),
                ),
              ],
            ),
          ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => setState(() => _timeline.add(_TimelineRow())),
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.tr('Add Timeline Entry', 'إضافة بند زمني')),
          ),
        ),
      ],
    );
  }
}

/// Mutable timeline row holding controllers + a picked date.
class _TimelineRow {
  _TimelineRow({String name = '', this.date = '', String responsible = ''})
      : name = TextEditingController(text: name),
        responsible = TextEditingController(text: responsible);
  final TextEditingController name;
  String date;
  final TextEditingController responsible;

  void dispose() {
    name.dispose();
    responsible.dispose();
  }
}
