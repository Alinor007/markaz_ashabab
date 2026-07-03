import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/i18n/localized.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/util/icon_catalog.dart';

/// Captured values from the department form.
class DepartmentFormResult {
  DepartmentFormResult({
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.iconKey,
  });
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String iconKey;
}

Future<DepartmentFormResult?> showDepartmentForm(
  BuildContext context, {
  Department? existing,
}) {
  return showDialog<DepartmentFormResult>(
    context: context,
    builder: (_) => _DepartmentFormDialog(existing: existing),
  );
}

class _DepartmentFormDialog extends StatefulWidget {
  const _DepartmentFormDialog({this.existing});
  final Department? existing;

  @override
  State<_DepartmentFormDialog> createState() => _DepartmentFormDialogState();
}

class _DepartmentFormDialogState extends State<_DepartmentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _nameAr =
      TextEditingController(text: widget.existing?.nameAr ?? '');
  late final _desc =
      TextEditingController(text: widget.existing?.description ?? '');
  late final _descAr =
      TextEditingController(text: widget.existing?.descriptionAr ?? '');
  late String _iconKey = widget.existing?.iconKey ?? 'group';

  @override
  void dispose() {
    for (final c in [_name, _nameAr, _desc, _descAr]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(editing
          ? context.tr('Edit Department', 'تعديل القسم')
          : context.tr('Add Department', 'إضافة قسم')),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                      labelText: context.tr('Name', 'الاسم')),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? context.trRead('Required', 'مطلوب')
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _nameAr,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                      labelText: context.tr('Name (Arabic)', 'الاسم بالعربية')),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _desc,
                  maxLines: 2,
                  decoration: InputDecoration(
                      labelText: context.tr('Description', 'الوصف')),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _descAr,
                  maxLines: 2,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                      labelText:
                          context.tr('Description (Arabic)', 'الوصف بالعربية')),
                ),
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(context.tr('Icon', 'الأيقونة'),
                      style: Theme.of(context).textTheme.labelMedium),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final key in kIconKeys)
                      InkWell(
                        onTap: () => setState(() => _iconKey = key),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _iconKey == key
                                ? AppColors.emerald.withValues(alpha: 0.15)
                                : AppColors.surfaceAlt,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(
                              color: _iconKey == key
                                  ? AppColors.emerald
                                  : AppColors.border,
                            ),
                          ),
                          child: Icon(iconForKey(key),
                              size: 20,
                              color: _iconKey == key
                                  ? AppColors.emerald
                                  : AppColors.textMuted),
                        ),
                      ),
                  ],
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
            Navigator.pop(
              context,
              DepartmentFormResult(
                name: _name.text.trim(),
                nameAr: _nameAr.text.trim(),
                description: _desc.text.trim(),
                descriptionAr: _descAr.text.trim(),
                iconKey: _iconKey,
              ),
            );
          },
          child: Text(context.tr('Save', 'حفظ')),
        ),
      ],
    );
  }
}

/// Converts a form result into an update companion (for editing).
DepartmentsCompanion departmentUpdateCompanion(DepartmentFormResult r) {
  return DepartmentsCompanion(
    name: Value(r.name),
    nameAr: Value(r.nameAr.isEmpty ? r.name : r.nameAr),
    description: Value(r.description),
    descriptionAr: Value(r.descriptionAr),
    iconKey: Value(r.iconKey),
  );
}
