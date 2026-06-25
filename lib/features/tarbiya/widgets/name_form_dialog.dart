import 'package:flutter/material.dart';

import '../../../core/i18n/localized.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';

/// Result of [NameFormDialog].
typedef NameFormResult = ({String name, String nameAr});

/// A small dialog to create/edit a bilingual name (used for Areas and Shu'bas).
class NameFormDialog extends StatefulWidget {
  const NameFormDialog({
    super.key,
    required this.title,
    this.initialName = '',
    this.initialNameAr = '',
  });

  final String title;
  final String initialName;
  final String initialNameAr;

  static Future<NameFormResult?> show(
    BuildContext context, {
    required String title,
    String name = '',
    String nameAr = '',
  }) {
    return showDialog<NameFormResult>(
      context: context,
      builder: (_) => NameFormDialog(
        title: title,
        initialName: name,
        initialNameAr: nameAr,
      ),
    );
  }

  @override
  State<NameFormDialog> createState() => _NameFormDialogState();
}

class _NameFormDialogState extends State<NameFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initialName);
  late final _nameAr = TextEditingController(text: widget.initialNameAr);

  @override
  void dispose() {
    _name.dispose();
    _nameAr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(widget.title),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: context.tr('Name (English)', 'الاسم (إنجليزي)')),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? context.trRead('Required', 'مطلوب')
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _nameAr,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                    labelText: context.tr('Name (Arabic)', 'الاسم (عربي)')),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('Cancel', 'إلغاء')),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(context,
                (name: _name.text.trim(), nameAr: _nameAr.text.trim()));
          },
          child: Text(context.tr('Save', 'حفظ')),
        ),
      ],
    );
  }
}
