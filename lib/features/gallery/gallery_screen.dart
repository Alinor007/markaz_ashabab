import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/patterns/geometric_pattern.dart';
import '../../core/repositories/gallery_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/util/icon_catalog.dart';
import '../../core/util/photo_service.dart';
import '../../widgets/cards/gallery_card.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import '../tarbiya/widgets/confirm_dialog.dart';

/// Gallery archive: year-filtered, Pinterest-style masonry grid with a lightbox
/// viewer and (for editors) add/delete.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int? _yearFilter;

  void _openLightbox(GalleryPhoto photo, bool canManage) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => _Lightbox(
        photo: photo,
        canManage: canManage,
        onDelete: () async {
          Navigator.of(context).pop();
          await context.read<GalleryRepository>().delete(photo.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<GalleryRepository>();
    final can = context.read<SessionController>().can;
    // Uploading is open to every role; deleting stays executive-only.
    final canUpload = can?.uploadGallery ?? false;
    final canManage = can?.manageContent ?? false;

    return ModulePage(
      english: 'Gallery',
      arabic: 'المعرض',
      actions: [
        if (canUpload)
          FilledButton.icon(
            onPressed: () => _addPhoto(context, repo),
            icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
            label: Text(context.tr('Add Photo', 'إضافة صورة')),
          ),
      ],
      child: StreamBuilder<List<GalleryPhoto>>(
        stream: repo.watchAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LoadingState();
          final all = snapshot.data!;
          if (all.isEmpty) {
            return EmptyState(
              icon: Icons.photo_library_outlined,
              title: context.tr('No photos yet', 'لا توجد صور بعد'),
              message: canUpload
                  ? context.tr('Add the first photo.', 'أضف أول صورة.')
                  : null,
            );
          }
          final years = (all.map((p) => p.year).where((y) => y > 0).toSet()
                .toList()
                ..sort((a, b) => b - a));
          final filtered = _yearFilter == null
              ? all
              : all.where((p) => p.year == _yearFilter).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterBar(
                options: [
                  context.tr('All Years', 'كل السنوات'),
                  for (final y in years) '$y',
                ],
                selectedIndex:
                    _yearFilter == null ? 0 : years.indexOf(_yearFilter!) + 1,
                onSelected: (i) => setState(
                    () => _yearFilter = i == 0 ? null : years[i - 1]),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: _Masonry(
                    photos: filtered,
                    onTap: (p) => _openLightbox(p, canManage),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addPhoto(BuildContext context, GalleryRepository repo) async {
    final r = await showDialog<_PhotoFormResult>(
      context: context,
      builder: (_) => const _PhotoFormDialog(),
    );
    if (r == null) return;
    await repo.add(
      title: r.title,
      titleAr: r.titleAr,
      year: r.year,
      event: r.event,
      eventAr: r.eventAr,
      iconKey: r.iconKey,
      imagePath: r.imagePath,
      heightHint: 200 + (r.title.length % 5) * 24,
    );
  }
}

class _Masonry extends StatelessWidget {
  const _Masonry({required this.photos, required this.onTap});
  final List<GalleryPhoto> photos;
  final ValueChanged<GalleryPhoto> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = AppSpacing.lg;
        final columns = AppLayout.gridColumns(constraints.maxWidth);
        final colItems = List.generate(columns, (_) => <GalleryPhoto>[]);
        final colHeights = List.filled(columns, 0.0);
        for (final photo in photos) {
          var shortest = 0;
          for (var c = 1; c < columns; c++) {
            if (colHeights[c] < colHeights[shortest]) shortest = c;
          }
          colItems[shortest].add(photo);
          colHeights[shortest] += photo.heightHint + spacing;
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var c = 0; c < columns; c++) ...[
              if (c > 0) const SizedBox(width: spacing),
              Expanded(
                child: Column(
                  children: [
                    for (final photo in colItems[c]) ...[
                      GalleryCard(photo: photo, onTap: () => onTap(photo)),
                      const SizedBox(height: spacing),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _Lightbox extends StatelessWidget {
  const _Lightbox(
      {required this.photo, required this.canManage, required this.onDelete});
  final GalleryPhoto photo;
  final bool canManage;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final hasImage =
        photo.imagePath.isNotEmpty && File(photo.imagePath).existsSync();
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.panel),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 620),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.lg)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (hasImage)
                      Image.file(File(photo.imagePath), fit: BoxFit.cover)
                    else ...[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              photo.accentColor,
                              Color.alphaBlend(
                                  Colors.black.withValues(alpha: 0.3),
                                  photo.accentColor),
                            ],
                          ),
                        ),
                      ),
                      const GeometricPattern(
                          color: Colors.white, opacity: 0.10, tile: 90),
                      Center(
                        child: Icon(photo.icon,
                            size: 96,
                            color: Colors.white.withValues(alpha: 0.6)),
                      ),
                    ],
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.md,
                      child: Row(
                        children: [
                          if (canManage)
                            Material(
                              color: Colors.black.withValues(alpha: 0.35),
                              shape: const CircleBorder(),
                              child: IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.white),
                                tooltip:
                                    context.tr('Delete photo', 'حذف الصورة'),
                                onPressed: () async {
                                  final ok = await confirmDialog(context,
                                      title: context.trRead(
                                          'Delete photo?', 'حذف الصورة؟'),
                                      message: photo.title);
                                  if (ok) onDelete();
                                },
                              ),
                            ),
                          const SizedBox(width: AppSpacing.sm),
                          Material(
                            color: Colors.black.withValues(alpha: 0.35),
                            shape: const CircleBorder(),
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              tooltip: context.tr('Close', 'إغلاق'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic && photo.titleAr.isNotEmpty
                        ? photo.titleAr
                        : photo.title,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: isArabic
                        ? AppTypography.arabic(
                            fontSize: 22, fontWeight: FontWeight.w700)
                        : Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(Icons.event_outlined,
                          size: 16, color: AppColors.textMuted),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                          '${isArabic && photo.eventAr.isNotEmpty ? photo.eventAr : photo.event} · ${photo.year}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoFormResult {
  _PhotoFormResult(this.title, this.titleAr, this.year, this.event,
      this.eventAr, this.iconKey, this.imagePath);
  final String title;
  final String titleAr;
  final int year;
  final String event;
  final String eventAr;
  final String iconKey;
  final String imagePath;
}

class _PhotoFormDialog extends StatefulWidget {
  const _PhotoFormDialog();

  @override
  State<_PhotoFormDialog> createState() => _PhotoFormDialogState();
}

class _PhotoFormDialogState extends State<_PhotoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _titleAr = TextEditingController();
  final _event = TextEditingController();
  final _eventAr = TextEditingController();
  final _year = TextEditingController(text: '${DateTime.now().year}');
  String _iconKey = 'photo';
  String _imagePath = '';

  @override
  void dispose() {
    _title.dispose();
    _titleAr.dispose();
    _event.dispose();
    _eventAr.dispose();
    _year.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(context.tr('Add Photo', 'إضافة صورة')),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Column(
                    children: [
                      if (_imagePath.isNotEmpty && File(_imagePath).existsSync())
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          child: Image.file(File(_imagePath),
                              width: 120, height: 90, fit: BoxFit.cover),
                        )
                      else
                        Container(
                          width: 120,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceAlt,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.image_outlined,
                              color: AppColors.textFaint),
                        ),
                      TextButton.icon(
                        onPressed: () async {
                          final path = await const PhotoService()
                              .pickAndStore(subfolder: 'gallery_photos');
                          if (path != null && mounted) {
                            setState(() => _imagePath = path);
                          }
                        },
                        icon: const Icon(Icons.upload_outlined, size: 18),
                        label: Text(context.tr('Choose Image', 'اختر صورة')),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _title,
                  decoration:
                      InputDecoration(labelText: context.tr('Title', 'العنوان')),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? context.trRead('Required', 'مطلوب')
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _event,
                        decoration: InputDecoration(
                            labelText: context.tr('Event', 'المناسبة')),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _year,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: context.tr('Year', 'السنة')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    for (final key in kIconKeys)
                      InkWell(
                        onTap: () => setState(() => _iconKey = key),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: _iconKey == key
                                ? AppColors.emerald.withValues(alpha: 0.15)
                                : AppColors.surfaceAlt,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(
                                color: _iconKey == key
                                    ? AppColors.emerald
                                    : AppColors.border),
                          ),
                          child: Icon(iconForKey(key),
                              size: 18,
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
              _PhotoFormResult(
                _title.text.trim(),
                _titleAr.text.trim(),
                int.tryParse(_year.text.trim()) ?? DateTime.now().year,
                _event.text.trim(),
                _eventAr.text.trim(),
                _iconKey,
                _imagePath,
              ),
            );
          },
          child: Text(context.tr('Save', 'حفظ')),
        ),
      ],
    );
  }
}
