import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/common/member_picker.dart';
import '../../widgets/common/portrait_avatar.dart';

/// Opens the Add Class form for one shu'ba level. A class is not a record of
/// its own — saving batch-updates each selected student's row (Naqib +
/// Section / School Year / Class Schedule), silently reassigning students who
/// already belonged to another class. The repository is captured by the
/// caller because dialogs in this app don't read providers themselves.
Future<void> showAddClassDialog(
  BuildContext context, {
  required MemberRepository memberRepo,
  required String shubaId,
  required int level,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _AddClassDialog(
      repo: memberRepo,
      shubaId: shubaId,
      level: level,
    ),
  );
}

class _AddClassDialog extends StatefulWidget {
  const _AddClassDialog({
    required this.repo,
    required this.shubaId,
    required this.level,
  });

  final MemberRepository repo;
  final String shubaId;
  final int level;

  @override
  State<_AddClassDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<_AddClassDialog> {
  final _section = TextEditingController();
  final _year = TextEditingController();
  final _schedule = TextEditingController();

  Member? _teacher;
  final List<Member> _students = [];
  bool _saving = false;

  @override
  void dispose() {
    _section.dispose();
    _year.dispose();
    _schedule.dispose();
    super.dispose();
  }

  Future<void> _pickTeacher() async {
    final picked = await pickMember(
      context,
      widget.repo,
      title: context.trRead('Select Teacher', 'اختيار النقيب'),
      excludeIds: _students.map((m) => m.id).toSet(),
    );
    if (picked != null && mounted) setState(() => _teacher = picked);
  }

  Future<void> _addStudent() async {
    // Students come from this shu'ba level only, so the class stays visible
    // in this level's class list.
    final picked = await pickMember(
      context,
      widget.repo,
      title: context.trRead('Select Student', 'اختيار طالب'),
      shubaId: widget.shubaId,
      level: widget.level,
      excludeIds: {
        if (_teacher != null) _teacher!.id,
        ..._students.map((m) => m.id),
      },
    );
    if (picked != null && mounted) {
      setState(() {
        if (!_students.any((m) => m.id == picked.id)) _students.add(picked);
      });
    }
  }

  Future<void> _save() async {
    if (_teacher == null) {
      _toast(context.trRead('Select a Teacher first.', 'اختر النقيب أولاً.'));
      return;
    }
    if (_students.isEmpty) {
      _toast(context.trRead(
          'Add at least one student.', 'أضف طالباً واحداً على الأقل.'));
      return;
    }
    setState(() => _saving = true);
    for (final s in _students) {
      await widget.repo.updateMember(
        s.id,
        MembersCompanion(
          naqibMemberId: Value(_teacher!.id),
          usraName: Value(_section.text.trim()),
          usraEstablishedYear: Value(_year.text.trim()),
          usraMeetingSchedule: Value(_schedule.text.trim()),
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      scrollable: true,
      backgroundColor: AppColors.surface,
      title: Text(context.tr('Add Class', 'إضافة فصل')),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _section,
              decoration: InputDecoration(
                  labelText: context.tr('Class Section', 'قسم الفصل'),
                  isDense: true),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _year,
              decoration: InputDecoration(
                  labelText: context.tr('School Year', 'السنة الدراسية'),
                  isDense: true),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _schedule,
              decoration: InputDecoration(
                  labelText: context.tr('Class Schedule', 'موعد الفصل'),
                  isDense: true),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: context.tr('Teacher', 'النقيب'),
                      isDense: true,
                    ),
                    child: Text(
                      _teacher == null
                          ? context.tr('Not selected', 'غير محدد')
                          : _teacher!.displayName(context.isArabic),
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                TextButton.icon(
                  onPressed: _saving ? null : _pickTeacher,
                  icon: const Icon(Icons.person_search_outlined, size: 18),
                  label: Text(_teacher == null
                      ? context.tr('Select', 'تحديد')
                      : context.tr('Change', 'تغيير')),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(context.tr('Students', 'الطلاب'),
                      style: theme.textTheme.titleSmall),
                ),
                TextButton.icon(
                  onPressed: _saving ? null : _addStudent,
                  icon: const Icon(Icons.person_add_alt_1_outlined, size: 18),
                  label: Text(context.tr('Add Student', 'إضافة طالب')),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            if (_students.isEmpty)
              Text(context.tr('No students added', 'لم تتم إضافة طلاب'),
                  style: theme.textTheme.bodySmall)
            else
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final m in _students)
                    InputChip(
                      avatar: PortraitAvatar(
                          initials: m.initials, size: 24, ring: false),
                      label: Text(m.displayName(context.isArabic)),
                      onDeleted: _saving
                          ? null
                          : () => setState(() =>
                              _students.removeWhere((x) => x.id == m.id)),
                    ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: Text(context.tr('Cancel', 'إلغاء')),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Text(context.tr('Save', 'حفظ')),
        ),
      ],
    );
  }
}
