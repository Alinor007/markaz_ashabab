import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/i18n/localized.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/util/photo_service.dart';

/// One biography section entered in the assign form (title + body).
typedef HolderSectionResult = ({String title, String body});

/// Result of filling a leadership position: the holder's typed name, an
/// optional attached photo, and any biography sections.
typedef PositionHolderResult = ({
  String name,
  String photoPath,
  List<HolderSectionResult> sections,
});

/// Fills (or edits) a leadership position by manually entering the holder's
/// name, attaching a photo, and adding biography sections — instead of picking
/// an existing member. [positionTitle] is the office being filled (e.g.
/// "President"), shown in the dialog title.
Future<PositionHolderResult?> showAssignPersonDialog(
  BuildContext context, {
  required String positionTitle,
  PositionHolderResult? existing,
}) {
  return showDialog<PositionHolderResult>(
    context: context,
    builder: (_) =>
        _AssignPersonForm(positionTitle: positionTitle, existing: existing),
  );
}

/// A mutable biography section row (title + body controllers).
class _SectionRow {
  _SectionRow({String title = '', String body = ''})
      : title = TextEditingController(text: title),
        body = TextEditingController(text: body);
  final TextEditingController title;
  final TextEditingController body;

  void dispose() {
    title.dispose();
    body.dispose();
  }
}

class _AssignPersonForm extends StatefulWidget {
  const _AssignPersonForm({required this.positionTitle, this.existing});
  final String positionTitle;
  final PositionHolderResult? existing;

  @override
  State<_AssignPersonForm> createState() => _AssignPersonFormState();
}

class _AssignPersonFormState extends State<_AssignPersonForm> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late String _photoPath = widget.existing?.photoPath ?? '';
  late final List<_SectionRow> _sections = [
    for (final s in widget.existing?.sections ?? const <HolderSectionResult>[])
      _SectionRow(title: s.title, body: s.body),
  ];

  @override
  void dispose() {
    _name.dispose();
    for (final s in _sections) {
      s.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final path =
        await const PhotoService().pickAndStore(subfolder: 'leader_photos');
    if (path != null && mounted) setState(() => _photoPath = path);
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto =
        _photoPath.trim().isNotEmpty && File(_photoPath).existsSync();
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(widget.existing == null
          ? context.tr('Assign ${widget.positionTitle}',
              'تعيين ${widget.positionTitle}')
          : context.tr('Edit ${widget.positionTitle}',
              'تعديل ${widget.positionTitle}')),
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
                          color: AppColors.emerald.withValues(alpha: 0.12),
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
                  onPressed: () => setState(() => _sections.add(_SectionRow())),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(context.tr('Add Section', 'إضافة قسم')),
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
        // Save is enabled only once a name has been entered.
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _name,
          builder: (context, value, _) => FilledButton(
            onPressed: value.text.trim().isEmpty
                ? null
                : () => Navigator.pop(context, (
                      name: _name.text.trim(),
                      photoPath: _photoPath,
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
