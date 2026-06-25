import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/i18n/localized.dart';
import '../../core/theme/app_dimens.dart';

/// Result of the leader create/edit form. List fields are newline-separated.
class LeaderFormResult {
  LeaderFormResult({
    required this.name,
    required this.nameAr,
    required this.position,
    required this.positionAr,
    required this.serviceYears,
    required this.bio,
    required this.bioAr,
    required this.achievements,
    required this.achievementsAr,
    required this.responsibilities,
    required this.responsibilitiesAr,
    required this.email,
    required this.phone,
  });

  final String name;
  final String nameAr;
  final String position;
  final String positionAr;
  final String serviceYears;
  final String bio;
  final String bioAr;
  final String achievements;
  final String achievementsAr;
  final String responsibilities;
  final String responsibilitiesAr;
  final String email;
  final String phone;
}

Future<LeaderFormResult?> showLeaderForm(
  BuildContext context, {
  required dynamic category,
  Leader? existing,
}) {
  return showDialog<LeaderFormResult>(
    context: context,
    builder: (_) => _LeaderFormDialog(existing: existing),
  );
}

class _LeaderFormDialog extends StatefulWidget {
  const _LeaderFormDialog({this.existing});
  final Leader? existing;

  @override
  State<_LeaderFormDialog> createState() => _LeaderFormDialogState();
}

class _LeaderFormDialogState extends State<_LeaderFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = _c(widget.existing?.name);
  late final _nameAr = _c(widget.existing?.nameAr);
  late final _position = _c(widget.existing?.position);
  late final _positionAr = _c(widget.existing?.positionAr);
  late final _serviceYears = _c(widget.existing?.serviceYears);
  late final _bio = _c(widget.existing?.bio);
  late final _bioAr = _c(widget.existing?.bioAr);
  late final _achievements = _c(widget.existing?.achievements);
  late final _achievementsAr = _c(widget.existing?.achievementsAr);
  late final _responsibilities = _c(widget.existing?.responsibilities);
  late final _responsibilitiesAr = _c(widget.existing?.responsibilitiesAr);
  late final _email = _c(widget.existing?.email);
  late final _phone = _c(widget.existing?.phone);

  TextEditingController _c(String? v) => TextEditingController(text: v ?? '');

  @override
  void dispose() {
    for (final c in [
      _name, _nameAr, _position, _positionAr, _serviceYears, _bio, _bioAr,
      _achievements, _achievementsAr, _responsibilities, _responsibilitiesAr,
      _email, _phone,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty)
      ? context.trRead('Required', 'مطلوب')
      : null;

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      LeaderFormResult(
        name: _name.text.trim(),
        nameAr: _nameAr.text.trim(),
        position: _position.text.trim(),
        positionAr: _positionAr.text.trim(),
        serviceYears: _serviceYears.text.trim(),
        bio: _bio.text.trim(),
        bioAr: _bioAr.text.trim(),
        achievements: _achievements.text.trim(),
        achievementsAr: _achievementsAr.text.trim(),
        responsibilities: _responsibilities.text.trim(),
        responsibilitiesAr: _responsibilitiesAr.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return AlertDialog(
      title: Text(isEditing
          ? context.tr('Edit Leader', 'تعديل القائد')
          : context.tr('Add Leader', 'إضافة قائد')),
      content: SizedBox(
        width: 560,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _row([
                  _field(_name, context.tr('Name', 'الاسم'),
                      validator: _required),
                  _field(_nameAr, context.tr('Name (Arabic)', 'الاسم (عربي)'),
                      rtl: true),
                ]),
                _row([
                  _field(_position, context.tr('Position', 'المنصب'),
                      validator: _required),
                  _field(_positionAr,
                      context.tr('Position (Arabic)', 'المنصب (عربي)'),
                      rtl: true),
                ]),
                _field(_serviceYears,
                    context.tr('Service Years', 'سنوات الخدمة')),
                _field(_bio, context.tr('Biography', 'السيرة'), lines: 2),
                _field(_bioAr, context.tr('Biography (Arabic)', 'السيرة (عربي)'),
                    lines: 2, rtl: true),
                _field(
                    _achievements,
                    context.tr('Achievements (one per line)',
                        'الإنجازات (سطر لكل عنصر)'),
                    lines: 2),
                _field(
                    _achievementsAr,
                    context.tr('Achievements Arabic (one per line)',
                        'الإنجازات بالعربية (سطر لكل عنصر)'),
                    lines: 2,
                    rtl: true),
                _field(
                    _responsibilities,
                    context.tr('Responsibilities (one per line)',
                        'المسؤوليات (سطر لكل عنصر)'),
                    lines: 2),
                _field(
                    _responsibilitiesAr,
                    context.tr('Responsibilities Arabic (one per line)',
                        'المسؤوليات بالعربية (سطر لكل عنصر)'),
                    lines: 2,
                    rtl: true),
                _row([
                  _field(_email, context.tr('Email', 'البريد')),
                  _field(_phone, context.tr('Phone', 'الهاتف')),
                ]),
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
            onPressed: _save, child: Text(context.tr('Save', 'حفظ'))),
      ],
    );
  }

  Widget _row(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          Expanded(child: children[i]),
        ],
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
    int lines = 1,
    bool rtl = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        validator: validator,
        minLines: lines,
        maxLines: lines + 2,
        textDirection: rtl ? TextDirection.rtl : null,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
