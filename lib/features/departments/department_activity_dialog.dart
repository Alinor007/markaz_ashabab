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
  // Form P-1 no longer captures a Program Description; show the short-term
  // Output (or the first objective) as the activity's list subtitle.
  String get description => data.output.isNotEmpty
      ? data.output
      : (data.objectives.isNotEmpty ? data.objectives.first : '');
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
  final _scroll = ScrollController();
  final _titleFocus = FocusNode();
  String? _formError;

  late final _programTitle = _c();
  late final _venue = _c();
  late final _target = _c();
  late final _expected = _c();
  late final _output = _c();
  late final _outcome = _c();

  final _objectives = <TextEditingController>[];

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
            proposedDate: widget.existing?.date ?? '',
          );
    _programTitle.text = p.programTitle;
    _venue.text = p.venue;
    _target.text = p.targetParticipants;
    _expected.text = p.expectedParticipants;
    _output.text = p.output;
    _outcome.text = p.outcome;
    _proposedDate = p.proposedDate;
    for (final v in p.objectives) {
      _objectives.add(_c(v));
    }
  }

  @override
  void dispose() {
    for (final c in [
      _programTitle, _venue, _target, _expected, _output, _outcome,
    ]) {
      c.dispose();
    }
    for (final c in _objectives) {
      c.dispose();
    }
    _scroll.dispose();
    _titleFocus.dispose();
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
    if (!_formKey.currentState!.validate()) {
      // Show a visible in-dialog error (a SnackBar would render behind the
      // modal) and scroll the required Program Title (Section A) into view.
      setState(() => _formError = context.trRead(
          'Please enter the Program Title to save.',
          'يرجى إدخال عنوان البرنامج للحفظ.'));
      if (_scroll.hasClients) {
        _scroll.animateTo(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      }
      // Take the user straight to the empty required field.
      _titleFocus.requestFocus();
      return;
    }
    _formError = null;
    final data = ProgramProposal(
      programTitle: _programTitle.text.trim(),
      proposedDate: _proposedDate,
      venue: _venue.text.trim(),
      targetParticipants: _target.text.trim(),
      expectedParticipants: _expected.text.trim(),
      objectives: _values(_objectives),
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  controller: _scroll,
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
            if (_formError != null) _FormErrorBanner(message: _formError!),
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
      _field(_programTitle, '${context.tr('Program Title', 'عنوان البرنامج')} *',
          required: true, focusNode: _titleFocus),
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
    FocusNode? focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
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
          decoration: _dec(context.tr('Proposed Date', 'التاريخ المقترح'))
              .copyWith(
                  suffixIcon:
                      const Icon(Icons.calendar_today_outlined, size: 18)),
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
}

/// An inline, in-dialog validation error shown above the action buttons. Used
/// because a SnackBar would render behind the modal dialog.
class _FormErrorBanner extends StatelessWidget {
  const _FormErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.error.withValues(alpha: 0.08),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: AppColors.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
