import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class ReportFormResult {
  ReportFormResult({
    required this.departmentId,
    required this.title,
    required this.titleAr,
    required this.summary,
    required this.summaryAr,
    required this.date,
    required this.year,
    required this.type,
    required this.pages,
  });
  final String departmentId;
  final String title;
  final String titleAr;
  final String summary;
  final String summaryAr;
  final String date;
  final int year;
  final String type;
  final int pages;
}

/// Shows the report form. [departments] are the selectable owners; pass
/// [lockedDepartmentId] to fix the department (e.g. from a department's tab or
/// for a department head restricted to their own department).
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
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _titleAr =
      TextEditingController(text: widget.existing?.titleAr ?? '');
  late final _summary =
      TextEditingController(text: widget.existing?.summary ?? '');
  late final _summaryAr =
      TextEditingController(text: widget.existing?.summaryAr ?? '');
  late final _pages = TextEditingController(
      text: (widget.existing?.pages ?? 1).toString());
  late String _deptId = widget.lockedDepartmentId ??
      widget.existing?.departmentId ??
      (widget.departments.isNotEmpty ? widget.departments.first.id : '');
  late String _date = widget.existing?.date ?? '';
  late int _year = widget.existing?.year ??
      (widget.existing?.date.isNotEmpty == true
          ? int.tryParse(widget.existing!.date.split('-').first) ??
              DateTime.now().year
          : DateTime.now().year);
  late ReportType _type =
      widget.existing != null ? widget.existing!.typeEnum : ReportType.minutes;

  @override
  void dispose() {
    for (final c in [_title, _titleAr, _summary, _summaryAr, _pages]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_date) ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        _date = picked.toIso8601String().split('T').first;
        _year = picked.year;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locked = widget.lockedDepartmentId != null;
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(widget.existing == null
          ? context.tr('Add Report', 'إضافة تقرير')
          : context.tr('Edit Report', 'تعديل التقرير')),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _title,
                  decoration:
                      InputDecoration(labelText: context.tr('Title', 'العنوان')),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? context.trRead('Required', 'مطلوب')
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _titleAr,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                      labelText: context.tr('Title (Arabic)', 'العنوان بالعربية')),
                ),
                const SizedBox(height: AppSpacing.md),
                if (!locked)
                  DropdownButtonFormField<String>(
                    initialValue: _deptId.isEmpty ? null : _deptId,
                    isExpanded: true,
                    decoration: InputDecoration(
                        labelText: context.tr('Department', 'القسم')),
                    items: [
                      for (final d in widget.departments)
                        DropdownMenuItem(
                            value: d.id,
                            child: Text(d.displayName(context.isArabic))),
                    ],
                    onChanged: (v) => setState(() => _deptId = v ?? _deptId),
                  ),
                if (!locked) const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<ReportType>(
                  initialValue: _type,
                  decoration: InputDecoration(
                      labelText: context.tr('Report Type', 'نوع التقرير')),
                  items: [
                    for (final t in ReportType.values)
                      DropdownMenuItem(
                          value: t, child: Text(t.label(context.isArabic))),
                  ],
                  onChanged: (v) => setState(() => _type = v ?? _type),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: context.tr('Date', 'التاريخ'),
                            suffixIcon: const Icon(
                                Icons.calendar_today_outlined, size: 18),
                          ),
                          child: Text(_date.isEmpty ? '—' : _date),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        controller: _pages,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: context.tr('Pages', 'الصفحات')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _summary,
                  maxLines: 3,
                  decoration: InputDecoration(
                      labelText: context.tr('Summary', 'الملخص')),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _summaryAr,
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                      labelText: context.tr('Summary (Arabic)', 'الملخص بالعربية')),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('Cancel', 'إلغاء'))),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            if (_deptId.isEmpty) return;
            Navigator.pop(
              context,
              ReportFormResult(
                departmentId: _deptId,
                title: _title.text.trim(),
                titleAr: _titleAr.text.trim(),
                summary: _summary.text.trim(),
                summaryAr: _summaryAr.text.trim(),
                date: _date,
                year: _year,
                type: _type.code,
                pages: int.tryParse(_pages.text.trim()) ?? 1,
              ),
            );
          },
          child: Text(context.tr('Save', 'حفظ')),
        ),
      ],
    );
  }
}
