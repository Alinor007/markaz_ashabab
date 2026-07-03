import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/minutes_report_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/util/photo_service.dart';

class MinutesReportResult {
  MinutesReportResult({
    required this.title,
    required this.year,
    required this.type,
    required this.imagePaths,
  });
  final String title;
  final int year;
  final String type;
  final List<String> imagePaths;
}

Future<MinutesReportResult?> showMinutesReportForm(
  BuildContext context, {
  MinutesReport? existing,
}) {
  return showDialog<MinutesReportResult>(
    context: context,
    builder: (_) => _MinutesReportForm(existing: existing),
  );
}

class _MinutesReportForm extends StatefulWidget {
  const _MinutesReportForm({this.existing});
  final MinutesReport? existing;

  @override
  State<_MinutesReportForm> createState() => _MinutesReportFormState();
}

class _MinutesReportFormState extends State<_MinutesReportForm> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _year = TextEditingController(
      text: (widget.existing?.year ?? DateTime.now().year).toString());
  late String _type = widget.existing?.type ?? 'minutes';
  late final List<String> _images = widget.existing != null
      ? MinutesReportRepository.imagesOf(widget.existing!)
      : <String>[];

  @override
  void dispose() {
    _title.dispose();
    _year.dispose();
    super.dispose();
  }

  Future<void> _addImage() async {
    final path =
        await const PhotoService().pickAndStore(subfolder: 'minutes_reports');
    if (path != null && mounted) setState(() => _images.add(path));
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      MinutesReportResult(
        title: _title.text.trim(),
        year: int.tryParse(_year.text.trim()) ?? DateTime.now().year,
        type: _type,
        imagePaths: List.of(_images),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: 560, maxHeight: media.size.height * 0.9),
        child: Form(
          key: _formKey,
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
                        widget.existing == null
                            ? context.tr('Add Report', 'إضافة تقرير')
                            : context.tr('Edit Report', 'تعديل التقرير'),
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
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg,
                      AppSpacing.xl, AppSpacing.lg + media.viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _title,
                        decoration: InputDecoration(
                            labelText: context.tr('Title', 'العنوان')),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? context.trRead('Required', 'مطلوب')
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 120,
                            child: TextFormField(
                              controller: _year,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: context.tr('Year', 'السنة')),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(child: _typeSelector(context)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _imagesSection(context),
                    ],
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
                      label: Text(context.tr('Save', 'حفظ')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeSelector(BuildContext context) {
    // A dropdown scales to the full set of report types (Minutes, Resolution,
    // and the other report kinds) without crowding the row.
    return DropdownButtonFormField<String>(
      initialValue: _type,
      isExpanded: true,
      decoration: InputDecoration(labelText: context.tr('Type', 'النوع')),
      items: [
        for (final t in ReportType.values)
          if (t != ReportType.programCompletion)
            DropdownMenuItem(
                value: t.code, child: Text(t.label(context.isArabic))),
      ],
      onChanged: (v) => setState(() => _type = v ?? _type),
    );
  }

  Widget _imagesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(context.tr('Attached Images', 'الصور المرفقة'),
                  style: Theme.of(context).textTheme.labelMedium),
            ),
            TextButton.icon(
              onPressed: _addImage,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              label: Text(context.tr('Add Image', 'إضافة صورة')),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        if (_images.isEmpty)
          Text(context.tr('No images attached.', 'لا توجد صور مرفقة.'),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted))
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (var i = 0; i < _images.length; i++)
                _Thumb(
                  path: _images[i],
                  onRemove: () => setState(() => _images.removeAt(i)),
                ),
            ],
          ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.path, required this.onRemove});
  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: file.existsSync()
              ? Image.file(file, width: 88, height: 88, fit: BoxFit.cover)
              : Container(
                  width: 88,
                  height: 88,
                  color: AppColors.surfaceAlt,
                  child: const Icon(Icons.broken_image_outlined,
                      color: AppColors.textFaint),
                ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: IconButton(
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            icon: const CircleAvatar(
              radius: 11,
              backgroundColor: AppColors.error,
              child: Icon(Icons.close, size: 13, color: Colors.white),
            ),
            onPressed: onRemove,
          ),
        ),
      ],
    );
  }
}
