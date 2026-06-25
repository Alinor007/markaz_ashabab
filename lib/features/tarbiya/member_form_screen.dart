import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/util/photo_service.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';

/// Mutable child row in the form.
class _ChildRow {
  _ChildRow({String name = '', this.dob = ''})
      : name = TextEditingController(text: name);
  final TextEditingController name;
  String dob;
}

/// Mutable education row in the form.
class _EduRow {
  _EduRow({
    this.stage = EducationStage.college,
    String school = '',
    String degree = '',
    String program = '',
    String year = '',
  })  : school = TextEditingController(text: school),
        degree = TextEditingController(text: degree),
        program = TextEditingController(text: program),
        year = TextEditingController(text: year);
  EducationStage stage;
  final TextEditingController school;
  final TextEditingController degree;
  final TextEditingController program;
  final TextEditingController year;
}

/// Add / Edit Member form. Pass [memberId] to edit, or [shubaId] + [level] to
/// add into a specific level.
class MemberFormScreen extends StatefulWidget {
  const MemberFormScreen({super.key, this.memberId, this.shubaId, this.level});

  final String? memberId;
  final String? shubaId;
  final int? level;

  bool get isEditing => memberId != null;

  @override
  State<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends State<MemberFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = true;
  bool _saving = false;

  // Controllers
  final _first = TextEditingController();
  final _middle = TextEditingController();
  final _last = TextEditingController();
  final _suffix = TextEditingController();
  final _nameAr = TextEditingController();
  final _placeOfBirth = TextEditingController();
  final _contact = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _ethnicity = TextEditingController();
  final _occupation = TextEditingController();
  final _spouseName = TextEditingController();
  final _usraName = TextEditingController();
  final _usraYear = TextEditingController();
  final _usraSchedule = TextEditingController();

  String _gender = 'M';
  String _dob = '';
  String _spouseDate = '';
  String _dateJoined = '';
  CivilStatus _civil = CivilStatus.single;
  String _status = 'active';
  int _level = 1;
  String _shubaId = '';
  String _photoPath = '';

  final List<_ChildRow> _children = [];
  final List<_EduRow> _education = [];

  @override
  void initState() {
    super.initState();
    _level = widget.level ?? 1;
    _shubaId = widget.shubaId ?? '';
    if (widget.isEditing) {
      _load();
    } else {
      _loading = false;
    }
  }

  Future<void> _load() async {
    final repo = context.read<MemberRepository>();
    final m = await repo.getMember(widget.memberId!);
    if (m == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final children = await repo.watchChildren(m.id).first;
    final education = await repo.watchEducation(m.id).first;
    _first.text = m.firstName;
    _middle.text = m.middleName;
    _last.text = m.lastName;
    _suffix.text = m.suffix;
    _nameAr.text = m.nameAr;
    _placeOfBirth.text = m.placeOfBirth;
    _contact.text = m.contactNumber;
    _email.text = m.email;
    _address.text = m.address;
    _ethnicity.text = m.ethnicity;
    _occupation.text = m.occupation;
    _spouseName.text = m.spouseName;
    _usraName.text = m.usraName;
    _usraYear.text = m.usraEstablishedYear;
    _usraSchedule.text = m.usraMeetingSchedule;
    _gender = m.gender;
    _dob = m.dob;
    _spouseDate = m.spouseDate;
    _dateJoined = m.dateJoined;
    _civil = m.civilStatusEnum;
    _status = m.status;
    _level = m.level;
    _shubaId = m.shubaId;
    _photoPath = m.photoPath;
    _children
      ..clear()
      ..addAll(children.map((c) => _ChildRow(name: c.name, dob: c.dob)));
    _education
      ..clear()
      ..addAll(education.map((e) => _EduRow(
            stage: EducationStage.fromCode(e.stage),
            school: e.schoolName,
            degree: e.degree,
            program: e.program,
            year: e.yearGraduated,
          )));
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [
      _first, _middle, _last, _suffix, _nameAr, _placeOfBirth, _contact,
      _email, _address, _ethnicity, _occupation, _spouseName, _usraName,
      _usraYear, _usraSchedule,
    ]) {
      c.dispose();
    }
    for (final r in _children) {
      r.name.dispose();
    }
    for (final r in _education) {
      r.school.dispose();
      r.degree.dispose();
      r.program.dispose();
      r.year.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final path = await const PhotoService().pickAndStore();
    if (path != null && mounted) setState(() => _photoPath = path);
  }

  Future<void> _pickDate(String current, ValueChanged<String> onPicked) async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(current) ?? DateTime(now.year - 20);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      onPicked(picked.toIso8601String().split('T').first);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_shubaId.isEmpty) {
      _toast(context.trRead('Missing Shu\'ba context.', 'سياق الشُّعبة مفقود.'));
      return;
    }
    setState(() => _saving = true);
    final repo = context.read<MemberRepository>();

    final companion = MembersCompanion(
      shubaId: Value(_shubaId),
      level: Value(_level),
      firstName: Value(_first.text.trim()),
      middleName: Value(_middle.text.trim()),
      lastName: Value(_last.text.trim()),
      suffix: Value(_suffix.text.trim()),
      nameAr: Value(_nameAr.text.trim()),
      gender: Value(_gender),
      dob: Value(_dob),
      placeOfBirth: Value(_placeOfBirth.text.trim()),
      contactNumber: Value(_contact.text.trim()),
      email: Value(_email.text.trim()),
      address: Value(_address.text.trim()),
      ethnicity: Value(_ethnicity.text.trim()),
      occupation: Value(_occupation.text.trim()),
      photoPath: Value(_photoPath),
      civilStatus: Value(_civil.code),
      spouseName: Value(_spouseName.text.trim()),
      spouseDate: Value(_spouseDate),
      status: Value(_status),
      dateJoined: Value(_dateJoined),
      usraName: Value(_usraName.text.trim()),
      usraEstablishedYear: Value(_usraYear.text.trim()),
      usraMeetingSchedule: Value(_usraSchedule.text.trim()),
    );

    String memberId;
    if (widget.isEditing) {
      memberId = widget.memberId!;
      await repo.updateMember(memberId, companion);
      // Reconcile children & education (delete + re-add).
      for (final c in await repo.watchChildren(memberId).first) {
        await repo.deleteChild(c.id);
      }
      for (final e in await repo.watchEducation(memberId).first) {
        await repo.deleteEducation(e.id);
      }
    } else {
      memberId = await repo.insertMember(companion);
    }
    for (final c in _children) {
      if (c.name.text.trim().isEmpty) continue;
      await repo.addChild(memberId, c.name.text.trim(), c.dob);
    }
    for (final e in _education) {
      if (e.school.text.trim().isEmpty) continue;
      await repo.addEducation(
        memberId: memberId,
        stage: e.stage.code,
        schoolName: e.school.text.trim(),
        degree: e.degree.text.trim(),
        program: e.program.text.trim(),
        yearGraduated: e.year.text.trim(),
      );
    }

    if (!mounted) return;
    _toast(widget.isEditing
        ? context.trRead('Member updated.', 'تم تحديث العضو.')
        : context.trRead('Member added.', 'تمت إضافة العضو.'));
    context.go('/tarbiya/member/$memberId');
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty)
      ? context.trRead('Required', 'مطلوب')
      : null;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return ModulePage(
        english: 'Member',
        arabic: 'عضو',
        child: const LoadingState(),
      );
    }
    return ModulePage(
      english: widget.isEditing ? 'Edit Member' : 'Add Member',
      arabic: widget.isEditing ? 'تعديل عضو' : 'إضافة عضو',
      scrollable: true,
      actions: [
        OutlinedButton(
          onPressed: _saving ? null : () => context.pop(),
          child: Text(context.tr('Cancel', 'إلغاء')),
        ),
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _personalSection(),
            const SizedBox(height: AppSpacing.lg),
            _familySection(),
            const SizedBox(height: AppSpacing.lg),
            _childrenSection(),
            const SizedBox(height: AppSpacing.lg),
            _educationSection(),
            const SizedBox(height: AppSpacing.lg),
            _usraSection(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  // ── Sections ──────────────────────────────────────────────────────────────
  Widget _personalSection() {
    return InfoPanel(
      icon: Icons.person_outline,
      title: context.tr('Personal Information', 'المعلومات الشخصية'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PhotoPicker(path: _photoPath, onPick: _pickPhoto,
                  initials: _initials()),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Column(
                  children: [
                    _row([
                      _field(_first, context.tr('First Name', 'الاسم الأول'),
                          validator: _required),
                      _field(_middle, context.tr('Middle Name', 'الاسم الأوسط')),
                    ]),
                    _row([
                      _field(_last, context.tr('Last Name', 'اسم العائلة'),
                          validator: _required),
                      _field(_suffix, context.tr('Suffix', 'اللاحقة')),
                    ]),
                    _row([
                      _field(_nameAr, context.tr('Arabic Name', 'الاسم بالعربية'),
                          textDirection: TextDirection.rtl),
                      _dropdown<String>(
                        label: context.tr('Gender', 'الجنس'),
                        value: _gender,
                        items: {
                          'M': context.tr('Male', 'ذكر'),
                          'F': context.tr('Female', 'أنثى'),
                        },
                        onChanged: (v) => setState(() => _gender = v),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _row([
            _dateField(context.tr('Date of Birth', 'تاريخ الميلاد'), _dob,
                (v) => setState(() => _dob = v)),
            _field(_placeOfBirth, context.tr('Place of Birth', 'مكان الميلاد')),
          ]),
          _row([
            _field(_contact, context.tr('Contact Number', 'رقم الهاتف')),
            _field(_email, context.tr('Email Address', 'البريد الإلكتروني')),
          ]),
          _row([
            _field(_address, context.tr('Address', 'العنوان')),
            _dropdown<CivilStatus>(
              label: context.tr('Civil Status', 'الحالة الاجتماعية'),
              value: _civil,
              items: {for (final c in CivilStatus.values) c: c.label(context.isArabic)},
              onChanged: (v) => setState(() => _civil = v),
            ),
          ]),
          _row([
            _field(_ethnicity, context.tr('Ethnicity / Tribe', 'العرق / القبيلة')),
            _field(_occupation, context.tr('Occupation', 'المهنة')),
          ]),
          _row([
            _dropdown<int>(
              label: context.tr('Level', 'المستوى'),
              value: _level,
              items: {for (final l in kTarbiyaLevels) l: 'Level $l'},
              onChanged: (v) => setState(() => _level = v),
            ),
            _dropdown<String>(
              label: context.tr('Status', 'الحالة'),
              value: _status,
              items: {
                'active': context.tr('Active', 'نشط'),
                'inactive': context.tr('Inactive', 'غير نشط'),
              },
              onChanged: (v) => setState(() => _status = v),
            ),
          ]),
          _row([
            _dateField(context.tr('Date Joined', 'تاريخ الانضمام'), _dateJoined,
                (v) => setState(() => _dateJoined = v)),
            const SizedBox.shrink(),
          ]),
        ],
      ),
    );
  }

  Widget _familySection() {
    if (_civil == CivilStatus.single) {
      return const SizedBox.shrink();
    }
    final (label, dateLabel) = switch (_civil) {
      CivilStatus.married => (
          context.tr('Husband / Wife Name', 'اسم الزوج / الزوجة'),
          context.tr('Date of Marriage', 'تاريخ الزواج')
        ),
      CivilStatus.widowed => (
          context.tr('Spouse Name', 'اسم الزوج/ة'),
          context.tr('Date Widowed', 'تاريخ الترمل')
        ),
      CivilStatus.divorced => (
          context.tr('Former Spouse Name', 'اسم الزوج/ة السابق'),
          context.tr('Date of Divorce', 'تاريخ الطلاق')
        ),
      CivilStatus.single => ('', ''),
    };
    return InfoPanel(
      icon: Icons.family_restroom_outlined,
      title: context.tr('Family Information', 'معلومات الأسرة'),
      child: _row([
        _field(_spouseName, label),
        _dateField(dateLabel, _spouseDate, (v) => setState(() => _spouseDate = v)),
      ]),
    );
  }

  Widget _childrenSection() {
    return InfoPanel(
      icon: Icons.child_care_outlined,
      title: context.tr('Children Information', 'معلومات الأبناء'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < _children.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _row([
                _field(_children[i].name, context.tr('Child Name', 'اسم الابن')),
                _dateField(context.tr('Date of Birth', 'تاريخ الميلاد'),
                    _children[i].dob, (v) => setState(() => _children[i].dob = v)),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: AppColors.error),
                  onPressed: () => setState(() => _children.removeAt(i)),
                ),
              ]),
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => setState(() => _children.add(_ChildRow())),
              icon: const Icon(Icons.add, size: 18),
              label: Text(context.tr('Add Child', 'إضافة ابن')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _educationSection() {
    return InfoPanel(
      icon: Icons.school_outlined,
      title: context.tr('Educational Background', 'المؤهلات الدراسية'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < _education.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                children: [
                  _row([
                    _dropdown<EducationStage>(
                      label: context.tr('Stage', 'المرحلة'),
                      value: _education[i].stage,
                      items: {
                        for (final s in EducationStage.values)
                          s: s.label(context.isArabic)
                      },
                      onChanged: (v) => setState(() => _education[i].stage = v),
                    ),
                    _field(_education[i].school,
                        context.tr('School Name', 'اسم المدرسة')),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: AppColors.error),
                      onPressed: () => setState(() => _education.removeAt(i)),
                    ),
                  ]),
                  _row([
                    _field(_education[i].degree,
                        context.tr('Degree', 'الدرجة العلمية')),
                    _field(_education[i].program,
                        context.tr('Program', 'البرنامج')),
                    _field(_education[i].year,
                        context.tr('Year Graduated', 'سنة التخرج')),
                  ]),
                ],
              ),
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => setState(() => _education.add(_EduRow())),
              icon: const Icon(Icons.add, size: 18),
              label: Text(context.tr('Add Education', 'إضافة مؤهل')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _usraSection() {
    return InfoPanel(
      icon: Icons.groups_2_outlined,
      title: context.tr('Naqib-Usra Information', 'معلومات النقيب والأسرة'),
      child: _row([
        _field(_usraName, context.tr('Name of Usra', 'اسم الأسرة')),
        _field(_usraYear, context.tr('Established Year', 'سنة التأسيس')),
        _field(_usraSchedule, context.tr('Meeting Schedule', 'موعد اللقاء')),
      ]),
    );
  }

  // ── Field helpers ──────────────────────────────────────────────────────────
  String _initials() {
    final f = _first.text.trim();
    final l = _last.text.trim();
    if (f.isEmpty && l.isEmpty) return '?';
    if (l.isEmpty) return f.substring(0, f.length >= 2 ? 2 : 1).toUpperCase();
    return '${f.isNotEmpty ? f[0] : ''}${l[0]}'.toUpperCase();
  }

  Widget _row(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            if (children[i] is IconButton)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: children[i],
              )
            else
              Expanded(child: children[i]),
          ],
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
    TextDirection? textDirection,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textDirection: textDirection,
      decoration: InputDecoration(labelText: label, isDense: true),
      onChanged: (_) {
        // Refresh avatar initials live.
        if (controller == _first || controller == _last) setState(() {});
      },
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required Map<T, String> items,
    required ValueChanged<T> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, isDense: true),
      items: [
        for (final entry in items.entries)
          DropdownMenuItem(value: entry.key, child: Text(entry.value)),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }

  Widget _dateField(String label, String value, ValueChanged<String> onPicked) {
    return InkWell(
      onTap: () => _pickDate(value, onPicked),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(value.isEmpty ? '—' : value,
            style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker(
      {required this.path, required this.onPick, required this.initials});
  final String path;
  final VoidCallback onPick;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (path.isNotEmpty && File(path).existsSync())
          CircleAvatar(radius: 44, backgroundImage: FileImage(File(path)))
        else
          PortraitAvatar(initials: initials, size: 88),
        const SizedBox(height: AppSpacing.sm),
        TextButton.icon(
          onPressed: onPick,
          icon: const Icon(Icons.photo_camera_outlined, size: 18),
          label: Text(context.tr('Upload Photo', 'رفع صورة')),
        ),
      ],
    );
  }
}
