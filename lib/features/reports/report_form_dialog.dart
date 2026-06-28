import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// Structured Program Completion Report (Form P-2) payload. Serialized to JSON
/// and stored in `reports.formData`.
class ProgramReport {
  ProgramReport({
    this.programTitle = '',
    this.leadOffice = '',
    this.supportOffices = '',
    this.dateConducted = '',
    this.venue = '',
    this.programHead = '',
    this.objective = '',
    this.objectiveStatus = 'achieved',
    List<String>? remarks,
    this.briefDescription = '',
    List<String>? keyActivities,
    this.eventFlow = 'good',
    this.targetParticipants = '',
    this.actualParticipants = '',
    this.youth = '',
    this.women = '',
    this.men = '',
    this.communityLeaders = '',
    this.approvedBudget = '',
    this.actualExpenses = '',
    List<String>? outputs,
    this.behavioralImpact = '',
    this.communityResponse = '',
    this.followUpInterest = '',
    List<String>? challenges,
    List<String>? solutions,
  })  : remarks = remarks ?? [],
        keyActivities = keyActivities ?? [],
        outputs = outputs ?? [],
        challenges = challenges ?? [],
        solutions = solutions ?? [];

  // A. Basic Information
  String programTitle;
  String leadOffice;
  String supportOffices;
  String dateConducted;
  String venue;
  String programHead;

  // B. Objectives Review
  String objective;
  String objectiveStatus; // achieved | partial | not
  List<String> remarks;

  // C. Program Implementation Summary
  String briefDescription;
  List<String> keyActivities;
  String eventFlow; // best | good | needs

  // D. Participation Data
  String targetParticipants;
  String actualParticipants;
  String youth;
  String women;
  String men;
  String communityLeaders;

  // E. Resource Utilization — Budget
  String approvedBudget;
  String actualExpenses;

  // F. Outputs & Results
  List<String> outputs;

  // G. Outcomes / Impact
  String behavioralImpact;
  String communityResponse;
  String followUpInterest;

  // H. Challenges Encountered
  List<String> challenges;

  // I. Solutions Applied
  List<String> solutions;

  Map<String, dynamic> toJson() => {
        'programTitle': programTitle,
        'leadOffice': leadOffice,
        'supportOffices': supportOffices,
        'dateConducted': dateConducted,
        'venue': venue,
        'programHead': programHead,
        'objective': objective,
        'objectiveStatus': objectiveStatus,
        'remarks': remarks,
        'briefDescription': briefDescription,
        'keyActivities': keyActivities,
        'eventFlow': eventFlow,
        'targetParticipants': targetParticipants,
        'actualParticipants': actualParticipants,
        'youth': youth,
        'women': women,
        'men': men,
        'communityLeaders': communityLeaders,
        'approvedBudget': approvedBudget,
        'actualExpenses': actualExpenses,
        'outputs': outputs,
        'behavioralImpact': behavioralImpact,
        'communityResponse': communityResponse,
        'followUpInterest': followUpInterest,
        'challenges': challenges,
        'solutions': solutions,
      };

  factory ProgramReport.fromJson(Map<String, dynamic> j) {
    List<String> list(String k) =>
        (j[k] as List?)?.map((e) => '$e').toList() ?? [];
    return ProgramReport(
      programTitle: j['programTitle'] ?? '',
      leadOffice: j['leadOffice'] ?? '',
      supportOffices: j['supportOffices'] ?? '',
      dateConducted: j['dateConducted'] ?? '',
      venue: j['venue'] ?? '',
      programHead: j['programHead'] ?? '',
      objective: j['objective'] ?? '',
      objectiveStatus: j['objectiveStatus'] ?? 'achieved',
      remarks: list('remarks'),
      briefDescription: j['briefDescription'] ?? '',
      keyActivities: list('keyActivities'),
      eventFlow: j['eventFlow'] ?? 'good',
      targetParticipants: j['targetParticipants'] ?? '',
      actualParticipants: j['actualParticipants'] ?? '',
      youth: j['youth'] ?? '',
      women: j['women'] ?? '',
      men: j['men'] ?? '',
      communityLeaders: j['communityLeaders'] ?? '',
      approvedBudget: j['approvedBudget'] ?? '',
      actualExpenses: j['actualExpenses'] ?? '',
      outputs: list('outputs'),
      behavioralImpact: j['behavioralImpact'] ?? '',
      communityResponse: j['communityResponse'] ?? '',
      followUpInterest: j['followUpInterest'] ?? '',
      challenges: list('challenges'),
      solutions: list('solutions'),
    );
  }
}

/// Result of the report form — carries the chosen department plus the P-2 data,
/// and exposes the header fields the `reports` row stores.
class ReportFormResult {
  ReportFormResult({required this.departmentId, required this.data});

  final String departmentId;
  final ProgramReport data;

  String get title => data.programTitle;
  String get titleAr => '';
  String get summary => data.briefDescription;
  String get summaryAr => '';
  String get date => data.dateConducted;
  int get year =>
      int.tryParse(data.dateConducted.split('-').first) ?? DateTime.now().year;
  String get type => ReportType.programCompletion.code;
  int get pages => 1;
  String get formData => jsonEncode(data.toJson());
}

/// Shows the Program Completion Report (Form P-2). [departments] are the
/// selectable owners; pass [lockedDepartmentId] to fix the department.
Future<ReportFormResult?> showReportForm(
  BuildContext context, {
  required List<Department> departments,
  Report? existing,
  String? lockedDepartmentId,
}) {
  return showDialog<ReportFormResult>(
    context: context,
    builder: (_) => _ReportFormDialog(
      departments: departments,
      existing: existing,
      lockedDepartmentId: lockedDepartmentId,
    ),
  );
}

class _ReportFormDialog extends StatefulWidget {
  const _ReportFormDialog({
    required this.departments,
    this.existing,
    this.lockedDepartmentId,
  });
  final List<Department> departments;
  final Report? existing;
  final String? lockedDepartmentId;

  @override
  State<_ReportFormDialog> createState() => _ReportFormDialogState();
}

class _ReportFormDialogState extends State<_ReportFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // Single-value controllers.
  late final _programTitle = _c();
  late final _leadOffice = _c();
  late final _supportOffices = _c();
  late final _venue = _c();
  late final _programHead = _c();
  late final _objective = _c();
  late final _brief = _c();
  late final _target = _c();
  late final _actual = _c();
  late final _youth = _c();
  late final _women = _c();
  late final _men = _c();
  late final _communityLeaders = _c();
  late final _approved = _c();
  late final _expenses = _c();
  late final _behavioral = _c();
  late final _response = _c();
  late final _followUp = _c();

  // Dynamic lists.
  final _remarks = <TextEditingController>[];
  final _keyActivities = <TextEditingController>[];
  final _outputs = <TextEditingController>[];
  final _challenges = <TextEditingController>[];
  final _solutions = <TextEditingController>[];

  String _dateConducted = '';
  String _objectiveStatus = 'achieved';
  String _eventFlow = 'good';
  late String _deptId = widget.lockedDepartmentId ??
      widget.existing?.departmentId ??
      (widget.departments.isNotEmpty ? widget.departments.first.id : '');

  TextEditingController _c([String v = '']) => TextEditingController(text: v);

  @override
  void initState() {
    super.initState();
    final raw = widget.existing?.formData ?? '';
    final data = raw.isNotEmpty
        ? ProgramReport.fromJson(jsonDecode(raw) as Map<String, dynamic>)
        : ProgramReport(
            // Seed from a legacy report's header fields when there's no payload.
            programTitle: widget.existing?.title ?? '',
            briefDescription: widget.existing?.summary ?? '',
            dateConducted: widget.existing?.date ?? '',
          );
    _programTitle.text = data.programTitle;
    _leadOffice.text = data.leadOffice;
    _supportOffices.text = data.supportOffices;
    _venue.text = data.venue;
    _programHead.text = data.programHead;
    _objective.text = data.objective;
    _brief.text = data.briefDescription;
    _target.text = data.targetParticipants;
    _actual.text = data.actualParticipants;
    _youth.text = data.youth;
    _women.text = data.women;
    _men.text = data.men;
    _communityLeaders.text = data.communityLeaders;
    _approved.text = data.approvedBudget;
    _expenses.text = data.actualExpenses;
    _behavioral.text = data.behavioralImpact;
    _response.text = data.communityResponse;
    _followUp.text = data.followUpInterest;
    _dateConducted = data.dateConducted;
    _objectiveStatus = data.objectiveStatus;
    _eventFlow = data.eventFlow;
    _fill(_remarks, data.remarks);
    _fill(_keyActivities, data.keyActivities);
    _fill(_outputs, data.outputs);
    _fill(_challenges, data.challenges);
    _fill(_solutions, data.solutions);
  }

  void _fill(List<TextEditingController> list, List<String> values) {
    for (final v in values) {
      list.add(_c(v));
    }
  }

  @override
  void dispose() {
    for (final c in [
      _programTitle, _leadOffice, _supportOffices, _venue, _programHead,
      _objective, _brief, _target, _actual, _youth, _women, _men,
      _communityLeaders, _approved, _expenses, _behavioral, _response,
      _followUp,
    ]) {
      c.dispose();
    }
    for (final list in [
      _remarks, _keyActivities, _outputs, _challenges, _solutions
    ]) {
      for (final c in list) {
        c.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dateConducted) ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() => _dateConducted = picked.toIso8601String().split('T').first);
    }
  }

  double get _variance =>
      (double.tryParse(_approved.text.trim()) ?? 0) -
      (double.tryParse(_expenses.text.trim()) ?? 0);

  List<String> _values(List<TextEditingController> list) => list
      .map((c) => c.text.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  void _save() {
    if (!_formKey.currentState!.validate() || _deptId.isEmpty) return;
    final data = ProgramReport(
      programTitle: _programTitle.text.trim(),
      leadOffice: _leadOffice.text.trim(),
      supportOffices: _supportOffices.text.trim(),
      dateConducted: _dateConducted,
      venue: _venue.text.trim(),
      programHead: _programHead.text.trim(),
      objective: _objective.text.trim(),
      objectiveStatus: _objectiveStatus,
      remarks: _values(_remarks),
      briefDescription: _brief.text.trim(),
      keyActivities: _values(_keyActivities),
      eventFlow: _eventFlow,
      targetParticipants: _target.text.trim(),
      actualParticipants: _actual.text.trim(),
      youth: _youth.text.trim(),
      women: _women.text.trim(),
      men: _men.text.trim(),
      communityLeaders: _communityLeaders.text.trim(),
      approvedBudget: _approved.text.trim(),
      actualExpenses: _expenses.text.trim(),
      outputs: _values(_outputs),
      behavioralImpact: _behavioral.text.trim(),
      communityResponse: _response.text.trim(),
      followUpInterest: _followUp.text.trim(),
      challenges: _values(_challenges),
      solutions: _values(_solutions),
    );
    Navigator.pop(context, ReportFormResult(departmentId: _deptId, data: data));
  }

  @override
  Widget build(BuildContext context) {
    final locked = widget.lockedDepartmentId != null;
    final media = MediaQuery.of(context);
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 680,
          maxHeight: media.size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg,
                  AppSpacing.xl, AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr('Program Completion Report (Form P-2)',
                          'تقرير إنجاز برنامج (نموذج P-2)'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  // Keyboard headroom so focused fields clear the keyboard.
                  padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg,
                      AppSpacing.xl, AppSpacing.lg + media.viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _sections(context, locked),
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
                    label: Text(context.tr('Save Report', 'حفظ التقرير')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _sections(BuildContext context, bool locked) {
    return [
      _section('A', context.tr('Basic Information', 'المعلومات الأساسية')),
      if (!locked) ...[
        DropdownButtonFormField<String>(
          initialValue: _deptId.isEmpty ? null : _deptId,
          isExpanded: true,
          decoration: _dec(context.tr('Department', 'القسم')),
          items: [
            for (final d in widget.departments)
              DropdownMenuItem(
                  value: d.id, child: Text(d.displayName(context.isArabic))),
          ],
          onChanged: (v) => setState(() => _deptId = v ?? _deptId),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
      _field(_programTitle, context.tr('Program Title', 'عنوان البرنامج'),
          required: true),
      _row2(
        _field(_leadOffice, context.tr('Lead Office', 'المكتب الرئيسي')),
        _field(_supportOffices,
            context.tr('Support Offices', 'المكاتب المساندة')),
      ),
      _row2(
        _dateField(context),
        _field(_venue, context.tr('Venue / Location', 'المكان / الموقع')),
      ),
      _field(_programHead,
          context.tr('Program Head / Project Leader', 'رئيس البرنامج / قائد المشروع')),

      _section('B', context.tr('Objectives Review', 'مراجعة الأهداف')),
      _field(_objective, context.tr('Objective', 'الهدف'), lines: 2),
      _choice(
        context.tr('Status', 'الحالة'),
        {
          'achieved': context.tr('Achieved', 'تحقق'),
          'partial': context.tr('Partially Achieved', 'تحقق جزئيًا'),
          'not': context.tr('Not Achieved', 'لم يتحقق'),
        },
        _objectiveStatus,
        (v) => setState(() => _objectiveStatus = v),
      ),
      _list(context, context.tr('Remarks', 'ملاحظات'), _remarks),

      _section('C',
          context.tr('Program Implementation Summary', 'ملخص تنفيذ البرنامج')),
      _field(
          _brief,
          context.tr('Brief description of what actually happened',
              'وصف موجز لما حدث فعليًا'),
          lines: 3),
      _list(context, context.tr('Key Activities Conducted', 'الأنشطة الرئيسية'),
          _keyActivities),
      _choice(
        context.tr('Flow of the Event', 'سير الفعالية'),
        {
          'best': context.tr('Best', 'ممتاز'),
          'good': context.tr('Good', 'جيد'),
          'needs': context.tr('Needs Improvement', 'يحتاج إلى تحسين'),
        },
        _eventFlow,
        (v) => setState(() => _eventFlow = v),
      ),

      _section('D', context.tr('Participation Data', 'بيانات المشاركة')),
      _row2(
        _field(_target,
            context.tr('Target Participants', 'المشاركون المستهدفون'),
            keyboard: TextInputType.number),
        _field(_actual,
            context.tr('Actual Participants', 'المشاركون الفعليون'),
            keyboard: TextInputType.number),
      ),
      Text(context.tr('Breakdown (optional)', 'التفصيل (اختياري)'),
          style: Theme.of(context).textTheme.labelMedium),
      const SizedBox(height: AppSpacing.sm),
      _row2(
        _field(_youth, context.tr('Youth', 'الشباب'),
            keyboard: TextInputType.number),
        _field(_women, context.tr('Women', 'النساء'),
            keyboard: TextInputType.number),
      ),
      _row2(
        _field(_men, context.tr('Men', 'الرجال'),
            keyboard: TextInputType.number),
        _field(_communityLeaders,
            context.tr('Community Leaders', 'قادة المجتمع'),
            keyboard: TextInputType.number),
      ),

      _section('E',
          context.tr('Resource Utilization — Budget', 'استخدام الموارد — الميزانية')),
      _row2(
        _field(_approved, context.tr('Approved Budget', 'الميزانية المعتمدة'),
            keyboard: TextInputType.number, onChanged: () => setState(() {})),
        _field(_expenses, context.tr('Actual Expenses', 'المصروفات الفعلية'),
            keyboard: TextInputType.number, onChanged: () => setState(() {})),
      ),
      InputDecorator(
        decoration: _dec(context.tr('Variance (Approved − Actual)',
            'الفرق (المعتمدة − الفعلية)')),
        child: Text(
          _variance.toStringAsFixed(2),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _variance < 0 ? AppColors.error : AppColors.emerald,
              ),
        ),
      ),

      _section('F', context.tr('Outputs & Results', 'المخرجات والنتائج')),
      _list(context, context.tr('Direct Outputs', 'المخرجات المباشرة'),
          _outputs),

      _section('G', context.tr('Outcomes / Impact', 'النتائج / الأثر')),
      _field(_behavioral, context.tr('Behavioral Impact', 'الأثر السلوكي'),
          lines: 2),
      _field(_response, context.tr('Community Response', 'استجابة المجتمع'),
          lines: 2),
      _field(_followUp,
          context.tr('Follow-up Interest', 'الاهتمام بالمتابعة'), lines: 2),

      _section('H', context.tr('Challenges Encountered', 'التحديات المواجهة')),
      _list(context, context.tr('Challenges', 'التحديات'), _challenges),

      _section('I', context.tr('Solutions Applied', 'الحلول المطبقة')),
      _list(context, context.tr('Solutions', 'الحلول'), _solutions),
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
    VoidCallback? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        minLines: lines,
        maxLines: lines == 1 ? 1 : lines + 2,
        keyboardType: keyboard ?? (lines > 1 ? TextInputType.multiline : null),
        decoration: _dec(label),
        onChanged: onChanged == null ? null : (_) => onChanged(),
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
        onTap: _pickDate,
        child: InputDecorator(
          decoration: _dec(context.tr('Date Conducted', 'تاريخ التنفيذ'))
              .copyWith(
                  suffixIcon:
                      const Icon(Icons.calendar_today_outlined, size: 18)),
          child: Text(_dateConducted.isEmpty ? '—' : _dateConducted),
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

  Widget _choice(String label, Map<String, String> options, String value,
      ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final e in options.entries)
                ChoiceChip(
                  label: Text(e.value),
                  selected: value == e.key,
                  onSelected: (_) => onChanged(e.key),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// A dynamic list field with per-item Add/Remove.
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
                      controller: list[i],
                      decoration: _dec('$label ${i + 1}'),
                    ),
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
