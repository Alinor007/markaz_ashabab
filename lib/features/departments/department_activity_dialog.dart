import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class ActivityFormResult {
  ActivityFormResult({
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.attendance,
  });
  final String title;
  final String description;
  final String date;
  final String status;
  final int attendance;
}

Future<ActivityFormResult?> showActivityForm(
  BuildContext context, {
  DeptActivity? existing,
}) {
  return showDialog<ActivityFormResult>(
    context: context,
    builder: (_) => _ActivityFormDialog(existing: existing),
  );
}

class _ActivityFormDialog extends StatefulWidget {
  const _ActivityFormDialog({this.existing});
  final DeptActivity? existing;

  @override
  State<_ActivityFormDialog> createState() => _ActivityFormDialogState();
}

class _ActivityFormDialogState extends State<_ActivityFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _desc =
      TextEditingController(text: widget.existing?.description ?? '');
  late final _attendance = TextEditingController(
      text: (widget.existing?.attendance ?? 0).toString());
  late String _date = widget.existing?.date ?? '';
  late ActivityStatus _status =
      widget.existing != null ? widget.existing!.statusEnum : ActivityStatus.planned;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _attendance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(widget.existing == null
          ? context.tr('Add Activity', 'إضافة نشاط')
          : context.tr('Edit Activity', 'تعديل النشاط')),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(child: Column(
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
                controller: _desc,
                maxLines: 2,
                decoration: InputDecoration(
                    labelText: context.tr('Description', 'الوصف')),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.tryParse(_date) ?? now,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(now.year + 2),
                        );
                        if (picked != null) {
                          setState(() =>
                              _date = picked.toIso8601String().split('T').first);
                        }
                      },
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
                    width: 110,
                    child: TextFormField(
                      controller: _attendance,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: context.tr('Attendance', 'الحضور')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<ActivityStatus>(
                initialValue: _status,
                decoration:
                    InputDecoration(labelText: context.tr('Status', 'الحالة')),
                items: [
                  for (final s in ActivityStatus.values)
                    DropdownMenuItem(
                        value: s, child: Text(s.label(context.isArabic))),
                ],
                onChanged: (v) => setState(() => _status = v ?? _status),
              ),
            ],
          )),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('Cancel', 'إلغاء'))),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(
              context,
              ActivityFormResult(
                title: _title.text.trim(),
                description: _desc.text.trim(),
                date: _date,
                status: _status.code,
                attendance: int.tryParse(_attendance.text.trim()) ?? 0,
              ),
            );
          },
          child: Text(context.tr('Save', 'حفظ')),
        ),
      ],
    );
  }
}
