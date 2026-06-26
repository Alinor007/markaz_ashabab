import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/audit_repository.dart';
import '../../core/repositories/leader_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/util/photo_service.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';

/// Dedicated Add / Edit Leader screen. Pass [leaderId] to edit an existing
/// record, or [category] to add a new one into a specific leadership group.
///
/// Replaces the former modal dialog so the form has room to breathe: fields are
/// grouped into labelled sections (Identity, Biography, Achievements,
/// Responsibilities, Contact) with English/Arabic pairs side by side.
class LeaderFormScreen extends StatefulWidget {
  const LeaderFormScreen({super.key, this.leaderId, this.category});

  final String? leaderId;
  final LeadershipCategory? category;

  bool get isEditing => leaderId != null;

  @override
  State<LeaderFormScreen> createState() => _LeaderFormScreenState();
}

class _LeaderFormScreenState extends State<LeaderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = true;
  bool _saving = false;

  LeadershipCategory _category = LeadershipCategory.officePresident;
  String _photoPath = '';

  final _name = TextEditingController();
  final _nameAr = TextEditingController();
  final _position = TextEditingController();
  final _positionAr = TextEditingController();
  final _serviceYears = TextEditingController();
  final _bio = TextEditingController();
  final _bioAr = TextEditingController();
  final _achievements = TextEditingController();
  final _achievementsAr = TextEditingController();
  final _responsibilities = TextEditingController();
  final _responsibilitiesAr = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    _category = widget.category ?? LeadershipCategory.officePresident;
    if (widget.isEditing) {
      _load();
    } else {
      _loading = false;
    }
  }

  Future<void> _load() async {
    final leader = await context.read<LeaderRepository>().getById(widget.leaderId!);
    if (leader == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    _category = LeadershipCategory.fromCode(leader.category);
    _photoPath = leader.photoPath;
    _name.text = leader.name;
    _nameAr.text = leader.nameAr;
    _position.text = leader.position;
    _positionAr.text = leader.positionAr;
    _serviceYears.text = leader.serviceYears;
    _bio.text = leader.bio;
    _bioAr.text = leader.bioAr;
    _achievements.text = leader.achievements;
    _achievementsAr.text = leader.achievementsAr;
    _responsibilities.text = leader.responsibilities;
    _responsibilitiesAr.text = leader.responsibilitiesAr;
    _email.text = leader.email;
    _phone.text = leader.phone;
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [
      _name, _nameAr, _position, _positionAr, _serviceYears, _bio, _bioAr,
      _achievements, _achievementsAr, _responsibilities, _responsibilitiesAr,
      _email, _phone,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? context.trRead('Required', 'مطلوب') : null;

  String _actor() =>
      context.read<SessionController>().user?.username ?? 'system';

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = context.read<LeaderRepository>();
    final audit = context.read<AuditRepository>();
    final actor = _actor();

    String leaderId;
    if (widget.isEditing) {
      leaderId = widget.leaderId!;
      await repo.updateLeader(
        leaderId,
        name: _name.text.trim(),
        nameAr: _nameAr.text.trim(),
        position: _position.text.trim(),
        positionAr: _positionAr.text.trim(),
        category: _category,
        serviceYears: _serviceYears.text.trim(),
        bio: _bio.text.trim(),
        bioAr: _bioAr.text.trim(),
        achievements: _achievements.text.trim(),
        achievementsAr: _achievementsAr.text.trim(),
        responsibilities: _responsibilities.text.trim(),
        responsibilitiesAr: _responsibilitiesAr.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        photoPath: _photoPath,
      );
      await audit.log(
        username: actor,
        action: 'Updated leader "${_name.text.trim()}"',
        actionAr: 'حدّث قائدًا «${_name.text.trim()}»',
        module: 'Leadership',
        moduleAr: 'القيادة',
      );
    } else {
      final leader = await repo.create(
        name: _name.text.trim(),
        nameAr: _nameAr.text.trim(),
        position: _position.text.trim(),
        positionAr: _positionAr.text.trim(),
        category: _category,
        serviceYears: _serviceYears.text.trim(),
        bio: _bio.text.trim(),
        bioAr: _bioAr.text.trim(),
        achievements: _achievements.text.trim(),
        achievementsAr: _achievementsAr.text.trim(),
        responsibilities: _responsibilities.text.trim(),
        responsibilitiesAr: _responsibilitiesAr.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        photoPath: _photoPath,
      );
      leaderId = leader.id;
      await audit.log(
        username: actor,
        action: 'Created leader "${leader.name}"',
        actionAr: 'أضاف قائدًا «${leader.name}»',
        module: 'Leadership',
        moduleAr: 'القيادة',
      );
    }

    if (!mounted) return;
    _toast(widget.isEditing
        ? context.trRead('Leader updated.', 'تم تحديث القائد.')
        : context.trRead('Leader added.', 'تمت إضافة القائد.'));
    context.go('/leadership/profile/$leaderId');
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _pickPhoto() async {
    final path =
        await const PhotoService().pickAndStore(subfolder: 'leader_photos');
    if (path != null && mounted) setState(() => _photoPath = path);
  }

  String _initials() {
    final parts = _name.text.trim().split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final w = parts.first;
      return w.substring(0, w.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  void _cancel() {
    if (context.canPop()) {
      context.pop();
    } else if (widget.isEditing) {
      context.go('/leadership/profile/${widget.leaderId}');
    } else {
      context.go(_categoryRoute(_category));
    }
  }

  static String _categoryRoute(LeadershipCategory c) => switch (c) {
        LeadershipCategory.officePresident => '/leadership/office-president',
        LeadershipCategory.board => '/leadership/board',
        LeadershipCategory.assembly => '/leadership/assembly',
      };

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return ModulePage(
        english: 'Leader',
        arabic: 'قائد',
        child: const LoadingState(),
      );
    }
    return ModulePage(
      english: widget.isEditing ? 'Edit Leader' : 'Add Leader',
      arabic: widget.isEditing ? 'تعديل قائد' : 'إضافة قائد',
      scrollable: true,
      actions: [
        OutlinedButton(
          onPressed: _saving ? null : _cancel,
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
            _categoryBanner(),
            const SizedBox(height: AppSpacing.lg),
            _identitySection(),
            const SizedBox(height: AppSpacing.lg),
            _biographySection(),
            const SizedBox(height: AppSpacing.lg),
            _achievementsSection(),
            const SizedBox(height: AppSpacing.lg),
            _responsibilitiesSection(),
            const SizedBox(height: AppSpacing.lg),
            _contactSection(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  // ── Sections ───────────────────────────────────────────────────────────────
  Widget _categoryBanner() {
    return Row(
      children: [
        const Icon(Icons.workspace_premium_outlined, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Text(
          context.isArabic ? _category.ar : _category.en,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }

  Widget _identitySection() {
    return InfoPanel(
      icon: Icons.badge_outlined,
      title: context.tr('Identity', 'الهوية'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PhotoPicker(
            path: _photoPath,
            initials: _initials(),
            onPick: _pickPhoto,
            onRemove: _photoPath.isEmpty
                ? null
                : () => setState(() => _photoPath = ''),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row([
                  _field(_name, context.tr('Name', 'الاسم'),
                      validator: _required,
                      onChanged: (_) => setState(() {})),
                  _field(_nameAr, context.tr('Name (Arabic)', 'الاسم (عربي)'),
                      rtl: true),
                ]),
                _row([
                  _field(_position, context.tr('Position', 'المنصب'),
                      validator: _required),
                  _field(_positionAr,
                      context.tr('Position (Arabic)', 'المنصب (عربي)'),
                      rtl: true),
                ]),
                _row([
                  _field(_serviceYears,
                      context.tr('Service Years', 'سنوات الخدمة'),
                      helper: context.tr(
                          'e.g. 2018 – Present', 'مثال: ٢٠١٨ – حتى الآن')),
                  const SizedBox.shrink(),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _biographySection() {
    return InfoPanel(
      icon: Icons.article_outlined,
      title: context.tr('Biography', 'السيرة'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _single(_field(_bio, context.tr('Biography', 'السيرة'), lines: 3)),
          _single(_field(_bioAr, context.tr('Biography (Arabic)', 'السيرة (عربي)'),
              lines: 3, rtl: true)),
        ],
      ),
    );
  }

  Widget _achievementsSection() {
    final hint = context.tr('Enter one item per line', 'أدخل عنصرًا واحدًا في كل سطر');
    return InfoPanel(
      icon: Icons.military_tech_outlined,
      title: context.tr('Achievements', 'الإنجازات'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _single(_field(_achievements,
              context.tr('Achievements', 'الإنجازات'),
              lines: 3, helper: hint)),
          _single(_field(_achievementsAr,
              context.tr('Achievements (Arabic)', 'الإنجازات (عربي)'),
              lines: 3, rtl: true, helper: hint)),
        ],
      ),
    );
  }

  Widget _responsibilitiesSection() {
    final hint = context.tr('Enter one item per line', 'أدخل عنصرًا واحدًا في كل سطر');
    return InfoPanel(
      icon: Icons.checklist_outlined,
      title: context.tr('Responsibilities', 'المسؤوليات'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _single(_field(_responsibilities,
              context.tr('Responsibilities', 'المسؤوليات'),
              lines: 3, helper: hint)),
          _single(_field(_responsibilitiesAr,
              context.tr('Responsibilities (Arabic)', 'المسؤوليات (عربي)'),
              lines: 3, rtl: true, helper: hint)),
        ],
      ),
    );
  }

  Widget _contactSection() {
    return InfoPanel(
      icon: Icons.contact_mail_outlined,
      title: context.tr('Contact', 'التواصل'),
      child: _row([
        _field(_email, context.tr('Email', 'البريد'),
            keyboard: TextInputType.emailAddress),
        _field(_phone, context.tr('Phone', 'الهاتف'),
            keyboard: TextInputType.phone),
      ]),
    );
  }

  // ── Field helpers ────────────────────────────────────────────────────────
  Widget _row(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            Expanded(child: children[i]),
          ],
        ],
      ),
    );
  }

  Widget _single(Widget child) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: child,
      );

  Widget _field(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
    int lines = 1,
    bool rtl = false,
    String? helper,
    TextInputType? keyboard,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      minLines: lines,
      maxLines: lines == 1 ? 1 : lines + 3,
      keyboardType: keyboard ?? (lines > 1 ? TextInputType.multiline : null),
      textDirection: rtl ? TextDirection.rtl : null,
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        isDense: true,
      ),
    );
  }
}

/// Avatar + upload/change/remove controls for the leader's profile photo.
class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.path,
    required this.initials,
    required this.onPick,
    this.onRemove,
  });

  final String path;
  final String initials;
  final VoidCallback onPick;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = path.trim().isNotEmpty;
    return Column(
      children: [
        PortraitAvatar(
            initials: initials,
            imagePath: path,
            accent: AppColors.emerald,
            size: 96),
        const SizedBox(height: AppSpacing.sm),
        TextButton.icon(
          onPressed: onPick,
          icon: const Icon(Icons.photo_camera_outlined, size: 18),
          label: Text(hasPhoto
              ? context.tr('Change Photo', 'تغيير الصورة')
              : context.tr('Upload Photo', 'رفع صورة')),
        ),
        if (hasPhoto && onRemove != null)
          TextButton.icon(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline,
                size: 18, color: AppColors.error),
            label: Text(context.tr('Remove', 'إزالة'),
                style: const TextStyle(color: AppColors.error)),
          ),
      ],
    );
  }
}
