import 'package:flutter/material.dart';

import '../../../core/i18n/localized.dart';
import '../../../core/repositories/tarbiya_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';

/// Opens a search-and-multi-select dialog over Shu'bas that belong to areas
/// other than [targetAreaId], and returns the ids the user ticked — or null
/// if cancelled. This is the app's first multi-select dialog; modeled on
/// `pickMember` (member_picker.dart) for the overall shell/search shape, with
/// `CheckboxListTile` rows instead of tap-to-return.
///
/// The repository is passed in because dialogs in this app are shown on the
/// root navigator and don't read providers themselves — capture it in the
/// caller (where the provider is in scope) and hand it over.
Future<List<String>?> pickShubasToMove(
  BuildContext context,
  TarbiyaRepository repo, {
  required String targetAreaId,
  required String targetAreaName,
}) {
  return showDialog<List<String>>(
    context: context,
    builder: (_) => _ShubaPickerDialog(
      repo: repo,
      targetAreaId: targetAreaId,
      targetAreaName: targetAreaName,
    ),
  );
}

class _ShubaPickerDialog extends StatefulWidget {
  const _ShubaPickerDialog({
    required this.repo,
    required this.targetAreaId,
    required this.targetAreaName,
  });

  final TarbiyaRepository repo;
  final String targetAreaId;
  final String targetAreaName;

  @override
  State<_ShubaPickerDialog> createState() => _ShubaPickerDialogState();
}

class _ShubaPickerDialogState extends State<_ShubaPickerDialog> {
  final _searchCtrl = TextEditingController();
  List<MovableShuba> _all = const [];
  List<MovableShuba> _results = const [];
  final Set<String> _selected = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final all = await widget.repo.getMovableShubas(widget.targetAreaId);
      if (!mounted) return;
      setState(() {
        _all = all;
        _results = all;
        _loading = false;
      });
    } catch (_) {
      // Surface as "no results" rather than hanging on the spinner forever.
      if (!mounted) return;
      setState(() {
        _all = const [];
        _results = const [];
        _loading = false;
      });
    }
  }

  void _search(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _results = q.isEmpty
          ? _all
          : _all.where((m) => m.shuba.name.toLowerCase().contains(q)).toList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(context.tr("Add Existing Shu'ba", 'إضافة شُعبة موجودة')),
      content: SizedBox(
        width: 440,
        height: 460,
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              autofocus: true,
              onChanged: _search,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Icon(Icons.search),
                labelText: context.tr("Search Shu'ba name", 'ابحث باسم الشُّعبة'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? Center(
                          child: Text(
                            _all.isEmpty
                                ? context.tr(
                                    'No Shu\'bas available to move.',
                                    'لا توجد شُعب متاحة للنقل.',
                                  )
                                : context.tr('No matches', 'لا توجد نتائج'),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      : ListView.separated(
                          itemCount: _results.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final m = _results[i];
                            final areaName = m.area?.name;
                            return CheckboxListTile(
                              dense: true,
                              activeColor: AppColors.emerald,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _selected.contains(m.shuba.id),
                              onChanged: (checked) => setState(() {
                                if (checked ?? false) {
                                  _selected.add(m.shuba.id);
                                } else {
                                  _selected.remove(m.shuba.id);
                                }
                              }),
                              title: Text(m.shuba.name),
                              subtitle: Text(
                                areaName == null
                                    ? context.tr(
                                        'No area (orphaned)', 'بدون منطقة (معزولة)')
                                    : context.tr(
                                        'Currently in: $areaName',
                                        'حاليًا في: $areaName',
                                      ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('Cancel', 'إلغاء')),
        ),
        FilledButton(
          onPressed: _selected.isEmpty
              ? null
              : () => Navigator.pop(context, _selected.toList()),
          child: Text(context.tr(
              'Move ${_selected.length}', 'نقل ${_selected.length}')),
        ),
      ],
    );
  }
}
