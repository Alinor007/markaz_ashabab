import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/repositories/tarbiya_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/common/member_picker.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';

/// Tutorial Class Information — one class (Naqib + section) of a shu'ba
/// level, pushed from the Class Screen. Tarbiya managers see an Edit button
/// that switches the (already read-only-by-default) view into an editable
/// form with Save/Cancel; other roles never see Edit. Nothing is written
/// until Save is confirmed, and Cancel discards in-progress edits in place.
class ClassInfoScreen extends StatefulWidget {
  const ClassInfoScreen({
    super.key,
    required this.areaId,
    required this.shubaId,
    required this.level,
    required this.naqibId,
    required this.section,
  });

  final String areaId;
  final String shubaId;
  final int level;
  final String naqibId;
  final String section;

  @override
  State<ClassInfoScreen> createState() => _ClassInfoScreenState();
}

enum _StatusFilter { all, active, inactive }

class _ClassInfoScreenState extends State<ClassInfoScreen> {
  final _section = TextEditingController();
  final _year = TextEditingController();
  final _schedule = TextEditingController();
  final _studentSearch = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _editing = false;
  Member? _teacher;
  final List<Member> _students = [];
  _StatusFilter _statusFilter = _StatusFilter.all;
  String _query = '';

  /// The class roster as loaded — students removed from [_students] before
  /// Save get their whole class assignment cleared. Also doubles as the
  /// snapshot Cancel restores, alongside [_loadedSection]/[_loadedYear]/
  /// [_loadedSchedule].
  final Set<String> _originalStudentIds = {};
  List<Member> _loadedStudents = [];
  String _loadedSection = '';
  String _loadedYear = '';
  String _loadedSchedule = '';

  @override
  void initState() {
    super.initState();
    _load();
    _studentSearch.addListener(
        () => setState(() => _query = _studentSearch.text.trim().toLowerCase()));
  }

  Future<void> _load() async {
    final repo = context.read<TarbiyaRepository>();
    final classes = await repo.watchClasses(widget.shubaId, widget.level).first;
    final match = classes.where(
        (c) => c.teacher.id == widget.naqibId && c.section == widget.section);
    if (match.isNotEmpty) {
      final cls = match.first;
      _teacher = cls.teacher;
      _students
        ..clear()
        ..addAll(cls.students);
      _originalStudentIds
        ..clear()
        ..addAll(cls.students.map((m) => m.id));
      _loadedStudents = List.of(cls.students);
      _loadedSection = cls.section;
      _loadedYear = cls.year;
      _loadedSchedule = cls.schedule;
      _section.text = cls.section;
      _year.text = cls.year;
      _schedule.text = cls.schedule;
    }
    if (mounted) setState(() => _loading = false);
  }

  void _startEdit() => setState(() => _editing = true);

  /// Discards any in-progress edits and returns to the read-only view,
  /// without leaving this screen.
  void _cancelEdit() {
    setState(() {
      _editing = false;
      _section.text = _loadedSection;
      _year.text = _loadedYear;
      _schedule.text = _loadedSchedule;
      _students
        ..clear()
        ..addAll(_loadedStudents);
    });
  }

  @override
  void dispose() {
    _section.dispose();
    _year.dispose();
    _schedule.dispose();
    _studentSearch.dispose();
    super.dispose();
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(
          '/tarbiya/area/${widget.areaId}/shuba/${widget.shubaId}/level/${widget.level}/classes');
    }
  }

  Future<void> _addStudent() async {
    // Students must be existing members of this shu'ba level.
    final picked = await pickMember(
      context,
      context.read<MemberRepository>(),
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

  /// Confirms before dropping a student from the in-progress roster — removal
  /// is easy to mis-tap, and it silently clears the student's whole class
  /// assignment once Save is pressed, so it deserves a checkpoint.
  Future<void> _removeStudent(Member student) async {
    final name = student.displayName(context.isArabic);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(dialogContext.tr('Remove student?', 'إزالة الطالب؟')),
        content: Text(dialogContext.tr(
            '$name will be removed from this class.',
            'سيتم إزالة $name من هذا الفصل.')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.tr('Cancel', 'إلغاء')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.tr('Remove', 'إزالة')),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() => _students.removeWhere((m) => m.id == student.id));
    }
  }

  Future<void> _save() async {
    final teacher = _teacher;
    if (teacher == null) return;
    if (_students.isEmpty) {
      _toast(context.trRead('A class needs at least one student.',
          'يحتاج الفصل إلى طالب واحد على الأقل.'));
      return;
    }
    setState(() => _saving = true);
    final repo = context.read<MemberRepository>();
    // Remaining/added students carry the (possibly edited) class fields.
    for (final s in _students) {
      await repo.updateMember(
        s.id,
        MembersCompanion(
          naqibMemberId: Value(teacher.id),
          usraName: Value(_section.text.trim()),
          usraEstablishedYear: Value(_year.text.trim()),
          usraMeetingSchedule: Value(_schedule.text.trim()),
        ),
      );
    }
    // Removed students leave the class entirely: no Naqib, no class fields.
    final keptIds = _students.map((m) => m.id).toSet();
    for (final id in _originalStudentIds.difference(keptIds)) {
      await repo.updateMember(
        id,
        const MembersCompanion(
          naqibMemberId: Value(null),
          usraName: Value(''),
          usraEstablishedYear: Value(''),
          usraMeetingSchedule: Value(''),
        ),
      );
    }
    if (!mounted) return;
    _toast(context.trRead('Class updated.', 'تم تحديث الفصل.'));
    // The class identity in this screen's URL (naqib + section) is stale if
    // the section was renamed, so always return to the live Class Screen.
    _back();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  /// The roster narrowed by the status filter and name search — for display
  /// only. Removal always targets the underlying [_students] entry by id, so
  /// a student stays correctly tracked even while a filter hides them.
  List<Member> get _visibleStudents {
    return _students.where((m) {
      final matchesStatus = switch (_statusFilter) {
        _StatusFilter.all => true,
        _StatusFilter.active => m.isActive,
        _StatusFilter.inactive => !m.isActive,
      };
      final matchesQuery =
          _query.isEmpty || m.displayName(context.isArabic).toLowerCase().contains(_query);
      return matchesStatus && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final canManage =
        context.read<SessionController>().can?.manageTarbiya ?? false;
    final editing = canManage && _editing;
    return ModulePage(
      english: 'Tutorial Class Information',
      arabic: 'معلومات الفصل',
      scrollable: true,
      actions: [
        OutlinedButton.icon(
          onPressed: _saving ? null : (editing ? _cancelEdit : _back),
          icon: Icon(editing ? Icons.close : Icons.arrow_back, size: 18),
          label: Text(editing
              ? context.tr('Cancel', 'إلغاء')
              : context.tr('Back to Classes', 'العودة إلى الفصول')),
        ),
        if (canManage && !editing && _teacher != null)
          OutlinedButton.icon(
            onPressed: _startEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: Text(context.tr('Edit', 'تعديل')),
          ),
        if (editing)
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(context.tr('Save', 'حفظ')),
          ),
      ],
      child: _loading
          ? const LoadingState()
          : _teacher == null
              ? EmptyState(
                  icon: Icons.school_outlined,
                  title: context.tr('Class not found', 'الفصل غير موجود'),
                  message: context.tr(
                      'This class no longer has students in this level.',
                      'لم يعد لهذا الفصل طلاب في هذا المستوى.'),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _heroCard(context, editing),
                    const SizedBox(height: AppSpacing.lg),
                    _studentsSection(context, editing),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
    );
  }

  // ── Hero: class facts + teacher spotlight ──────────────────────────────────
  Widget _heroCard(BuildContext context, bool editing) {
    final theme = Theme.of(context);
    final teacher = _teacher!;
    return InfoPanel(
      icon: Icons.groups_2_outlined,
      title: context.tr(
          'Level ${widget.level} • Section ${widget.section.isEmpty ? "—" : widget.section}',
          'المستوى ${widget.level} • القسم ${widget.section}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: editing
                ? Row(
                    key: const ValueKey('edit-fields'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _section,
                          decoration: InputDecoration(
                              labelText: context.tr('Section', 'القسم'),
                              isDense: true),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextField(
                          controller: _year,
                          decoration: InputDecoration(
                              labelText:
                                  context.tr('School Year', 'السنة الدراسية'),
                              isDense: true),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextField(
                          controller: _schedule,
                          decoration: InputDecoration(
                              labelText:
                                  context.tr('Class Schedule', 'موعد الفصل'),
                              isDense: true),
                        ),
                      ),
                    ],
                  )
                : Row(
                    key: const ValueKey('view-chips'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _InfoChip(
                          icon: Icons.badge_outlined,
                          label: context.tr('Section', 'القسم'),
                          value: widget.section.isEmpty
                              ? context.tr('(No section)', '(بدون قسم)')
                              : widget.section,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _InfoChip(
                          icon: Icons.school_outlined,
                          label: context.tr('School Year', 'السنة الدراسية'),
                          value: _year.text.isEmpty ? '—' : _year.text,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _InfoChip(
                          icon: Icons.calendar_today_outlined,
                          label: context.tr('Class Schedule', 'موعد الفصل'),
                          value:
                              _schedule.text.isEmpty ? '—' : _schedule.text,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.lg),
          // Teacher spotlight — larger avatar, name reads first (recognition
          // over recall), a direct link to the full profile.
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            onTap: () => context.go('/tarbiya/member/${teacher.id}'),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  PortraitAvatar(
                      initials: teacher.initials,
                      imagePath: teacher.photoPath,
                      size: 56,
                      ring: false),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('NAQIB', 'النقيب'),
                            style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.textFaint,
                                letterSpacing: 0.6)),
                        Text(teacher.displayName(context.isArabic),
                            style: theme.textTheme.titleLarge),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(context.tr('View Profile', 'عرض الملف'),
                          style: theme.textTheme.labelLarge
                              ?.copyWith(color: AppColors.emerald)),
                      const Icon(Icons.chevron_right,
                          size: 18, color: AppColors.emerald),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Students ─────────────────────────────────────────────────────────────
  Widget _studentsSection(BuildContext context, bool editing) {
    final theme = Theme.of(context);
    final total = _students.length;
    final active = _students.where((m) => m.isActive).length;
    final inactive = total - active;
    final visible = _visibleStudents;

    return InfoPanel(
      icon: Icons.people_outline,
      title: context.tr('Students', 'الطلاب'),
      action: editing
          ? FilledButton.icon(
              onPressed: _saving ? null : _addStudent,
              icon: const Icon(Icons.person_add_alt_1_outlined, size: 18),
              label: Text(context.tr('Add Student', 'إضافة طالب')),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _StatusPill(
                  color: AppColors.emerald,
                  label: context.tr('Active', 'نشط'),
                  value: active),
              _StatusPill(
                  color: AppColors.textFaint,
                  label: context.tr('Inactive', 'غير نشط'),
                  value: inactive),
            ],
          ),
          if (total == 0)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: EmptyState(
                icon: Icons.people_outline,
                title: context.tr(
                    'No students assigned yet', 'لا يوجد طلاب بعد'),
                message: editing
                    ? context.tr('Press "Add Student" above to begin.',
                        'اضغط على "إضافة طالب" أعلاه للبدء.')
                    : context.tr('This class has no students in this level.',
                        'لا طلاب في هذا الفصل ضمن هذا المستوى.'),
              ),
            )
          else ...[
            const SizedBox(height: AppSpacing.lg),
            // Search + status filter only pay for themselves once a roster is
            // long enough to be hard to scan at a glance.
            if (total > 8) ...[
              SearchField(
                hint: context.trRead('Search student...', 'بحث عن طالب...'),
                controller: _studentSearch,
              ),
              const SizedBox(height: AppSpacing.md),
              FilterBar(
                options: [
                  context.tr('All', 'الكل'),
                  context.tr('Active', 'نشط'),
                  context.tr('Inactive', 'غير نشط'),
                ],
                selectedIndex: _statusFilter.index,
                onSelected: (i) =>
                    setState(() => _statusFilter = _StatusFilter.values[i]),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            if (visible.isEmpty)
              Text(
                  context.tr('No students match your search.',
                      'لا يوجد طلاب مطابقون لبحثك.'),
                  style: theme.textTheme.bodySmall)
            else
              Column(
                children: [
                  for (var i = 0; i < visible.length; i++) ...[
                    _studentCard(context, visible[i], editing),
                    if (i < visible.length - 1)
                      const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _studentCard(BuildContext context, Member student, bool editing) {
    final theme = Theme.of(context);
    final active = student.isActive;
    final statusColor = active ? AppColors.emerald : AppColors.textFaint;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () => context.go('/tarbiya/member/${student.id}'),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            children: [
              PortraitAvatar(
                  initials: student.initials,
                  imagePath: student.photoPath,
                  size: 44,
                  ring: false),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.displayName(context.isArabic),
                        style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: statusColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          active
                              ? context.tr('Active', 'نشط')
                              : context.tr('Inactive', 'غير نشط'),
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: statusColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (editing)
                OutlinedButton(
                  onPressed: _saving ? null : () => _removeStudent(student),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(context.tr('Remove', 'إزالة')),
                )
              else
                const Icon(Icons.chevron_right, color: AppColors.textFaint),
            ],
          ),
        ),
      ),
    );
  }
}

/// A small labeled fact card (icon + label + value) — used in the hero for
/// Section / School Year / Class Schedule so the page can be scanned rather
/// than read line by line.
class _InfoChip extends StatelessWidget {
  const _InfoChip(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textFaint),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.textFaint, letterSpacing: 0.4),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(value,
              style: theme.textTheme.titleMedium,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

/// A compact "N Label" pill (e.g. "16 Active") used for roster statistics.
class _StatusPill extends StatelessWidget {
  const _StatusPill(
      {required this.color, required this.label, required this.value});
  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text('$value $label',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
