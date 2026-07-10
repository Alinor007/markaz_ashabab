import 'package:flutter/material.dart';

import '../../../core/i18n/localized.dart';
import '../../../core/theme/app_colors.dart';

/// Result of [NameFormDialog].
typedef NameFormResult = ({String name});

/// A small dialog to create/edit a name (used for Areas and Shu'bas).
class NameFormDialog extends StatefulWidget {
  const NameFormDialog({
    super.key,
    required this.title,
    this.initialName = '',
  });

  final String title;
  final String initialName;

  static Future<NameFormResult?> show(
    BuildContext context, {
    required String title,
    String name = '',
  }) {
    return showDialog<NameFormResult>(
      context: context,
      builder: (_) => NameFormDialog(
        title: title,
        initialName: name,
      ),
    );
  }

  @override
  State<NameFormDialog> createState() => _NameFormDialogState();
}

class _NameFormDialogState extends State<NameFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _name.dispose();
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
          child: SingleChildScrollView(child: Column(
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
            ],
          )),
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
            Navigator.pop(context, (name: _name.text.trim()));
          },
          child: Text(context.tr('Save', 'حفظ')),
        ),
      ],
    );
  }
}
