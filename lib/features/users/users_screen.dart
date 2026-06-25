import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/roles.dart';
import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/locale_controller.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/audit_repository.dart';
import '../../core/repositories/user_repository.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/cards/user_card.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/error_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';

/// Admin User Management: live, database-backed user list with create, edit,
/// disable/enable, reset-password, and delete actions, plus audit logging.
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String _query = '';
  int _roleIndex = 0; // 0 == All

  UserRepository get _repo => context.read<UserRepository>();
  AuditRepository get _audit => context.read<AuditRepository>();
  String get _actor =>
      context.read<SessionController>().user?.username ?? 'system';

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  List<User> _filter(List<User> users) {
    return users.where((u) {
      final q = _query.toLowerCase();
      final matchesQuery = q.isEmpty ||
          u.fullName.toLowerCase().contains(q) ||
          u.username.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q);
      final matchesRole =
          _roleIndex == 0 || u.role == UserRole.values[_roleIndex - 1];
      return matchesQuery && matchesRole;
    }).toList();
  }

  Future<void> _handleAction(User user, UserAction action) async {
    final session = context.read<SessionController>();
    final selfId = session.user?.id;
    final ar = context.read<LocaleController>().isArabic;
    switch (action) {
      case UserAction.edit:
        await _openUserDialog(existing: user);
      case UserAction.resetPassword:
        await _resetPassword(user);
      case UserAction.toggleActive:
        if (user.id == selfId) {
          _toast(ar
              ? 'لا يمكنك تعطيل حسابك.'
              : 'You cannot disable your own account.');
          return;
        }
        final repo = _repo;
        final audit = _audit;
        final actor = session.user?.username ?? 'system';
        await repo.setActive(user.id, !user.active);
        await audit.log(
          username: actor,
          action:
              '${user.active ? 'Disabled' : 'Enabled'} user "${user.username}"',
          actionAr:
              '${user.active ? 'عطّل' : 'فعّل'} المستخدم «${user.username}»',
          module: 'User Management',
          moduleAr: 'إدارة المستخدمين',
        );
      case UserAction.delete:
        if (user.id == selfId) {
          _toast(ar
              ? 'لا يمكنك حذف حسابك.'
              : 'You cannot delete your own account.');
          return;
        }
        await _confirmDelete(user);
    }
  }

  Future<void> _resetPassword(User user) async {
    final repo = _repo;
    final audit = _audit;
    final actor = _actor;
    final ar = context.read<LocaleController>().isArabic;
    final controller = TextEditingController();
    final newPassword = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.tr('Reset Password', 'إعادة تعيين كلمة المرور')),
        content: SizedBox(
          width: 360,
          child: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              labelText: context.tr('New Password', 'كلمة المرور الجديدة'),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('Cancel', 'إلغاء')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(context.tr('Reset', 'إعادة تعيين')),
          ),
        ],
      ),
    );
    if (newPassword == null || newPassword.length < 4) {
      if (newPassword != null) {
        _toast(ar
            ? 'يجب أن تكون كلمة المرور 4 أحرف على الأقل.'
            : 'Password must be at least 4 characters.');
      }
      return;
    }
    await repo.resetPassword(user.id, newPassword);
    await audit.log(
      username: actor,
      action: 'Reset password for "${user.username}"',
      actionAr: 'أعاد تعيين كلمة مرور «${user.username}»',
      module: 'User Management',
      moduleAr: 'إدارة المستخدمين',
    );
    _toast(ar ? 'تم تحديث كلمة المرور.' : 'Password updated.');
  }

  Future<void> _confirmDelete(User user) async {
    final repo = _repo;
    final audit = _audit;
    final actor = _actor;
    final ar = context.read<LocaleController>().isArabic;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.tr('Delete User', 'حذف المستخدم')),
        content: Text(context.tr(
            'Delete "${user.username}"? This cannot be undone.',
            'حذف «${user.username}»؟ لا يمكن التراجع.')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.tr('Cancel', 'إلغاء')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.tr('Delete', 'حذف')),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await repo.delete(user.id);
    await audit.log(
      username: actor,
      action: 'Deleted user "${user.username}"',
      actionAr: 'حذف المستخدم «${user.username}»',
      module: 'User Management',
      moduleAr: 'إدارة المستخدمين',
    );
    _toast(ar ? 'تم حذف المستخدم.' : 'User deleted.');
  }

  Future<void> _openUserDialog({User? existing}) async {
    final repo = _repo;
    final audit = _audit;
    final actor = _actor;
    final ar = context.read<LocaleController>().isArabic;
    final result = await showDialog<_UserFormResult>(
      context: context,
      builder: (_) => _UserFormDialog(existing: existing, repo: repo),
    );
    if (result == null) return;
    if (existing == null) {
      await repo.create(
        fullName: result.fullName,
        fullNameAr: result.fullNameAr,
        username: result.username,
        email: result.email,
        password: result.password,
        role: result.role,
      );
      await audit.log(
        username: actor,
        action: 'Created user "${result.username}"',
        actionAr: 'أنشأ المستخدم «${result.username}»',
        module: 'User Management',
        moduleAr: 'إدارة المستخدمين',
      );
      _toast(ar ? 'تم إنشاء المستخدم.' : 'User created.');
    } else {
      await repo.updateProfile(
        id: existing.id,
        fullName: result.fullName,
        fullNameAr: result.fullNameAr,
        username: result.username,
        email: result.email,
        role: result.role,
      );
      await audit.log(
        username: actor,
        action: 'Updated user "${result.username}"',
        actionAr: 'حدّث المستخدم «${result.username}»',
        module: 'User Management',
        moduleAr: 'إدارة المستخدمين',
      );
      _toast(ar ? 'تم تحديث المستخدم.' : 'User updated.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final roles = [
      context.tr('All Roles', 'كل الأدوار'),
      for (final r in UserRole.values) r.label(context.isArabic),
    ];

    return ModulePage(
      english: 'User Management',
      arabic: 'إدارة المستخدمين',
      actions: [
        SearchField(
          width: 240,
          hint: context.tr('Search users…', 'ابحث عن المستخدمين…'),
          onChanged: (v) => setState(() => _query = v),
        ),
        FilledButton.icon(
          onPressed: () => _openUserDialog(),
          icon: const Icon(Icons.person_add_alt_1, size: 18),
          label: Text(context.tr('Create User', 'إنشاء مستخدم')),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterBar(
            options: roles,
            selectedIndex: _roleIndex,
            onSelected: (i) => setState(() => _roleIndex = i),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: StreamBuilder<List<User>>(
              stream: _repo.watchAll(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorState(
                      title: context.tr('Failed to load users.',
                          'تعذّر تحميل المستخدمين.'));
                }
                if (!snapshot.hasData) {
                  return const LoadingState();
                }
                final filtered = _filter(snapshot.data!);
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.group_off_outlined,
                    title: context.tr('No users found', 'لا يوجد مستخدمون'),
                  );
                }
                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) => UserCard(
                    user: filtered[i],
                    onAction: (a) => _handleAction(filtered[i], a),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UserFormResult {
  _UserFormResult({
    required this.fullName,
    required this.fullNameAr,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });
  final String fullName;
  final String fullNameAr;
  final String username;
  final String email;
  final String password;
  final UserRole role;
}

class _UserFormDialog extends StatefulWidget {
  const _UserFormDialog({this.existing, required this.repo});
  final User? existing;
  final UserRepository repo;

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _fullName =
      TextEditingController(text: widget.existing?.fullName ?? '');
  late final _fullNameAr =
      TextEditingController(text: widget.existing?.fullNameAr ?? '');
  late final _username =
      TextEditingController(text: widget.existing?.username ?? '');
  late final _email = TextEditingController(text: widget.existing?.email ?? '');
  final _password = TextEditingController();
  late UserRole _role = widget.existing?.role ?? UserRole.departmentHead;
  bool _saving = false;

  @override
  void dispose() {
    _fullName.dispose();
    _fullNameAr.dispose();
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty)
      ? context.trRead('Required', 'مطلوب')
      : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ar = context.read<LocaleController>().isArabic;
    setState(() => _saving = true);
    final exists = await widget.repo.usernameExists(
      _username.text,
      excludeId: widget.existing?.id,
    );
    if (!mounted) return;
    if (exists) {
      setState(() => _saving = false);
      _showFieldError(
          ar ? 'اسم المستخدم مستخدم بالفعل.' : 'Username already taken.');
      return;
    }
    Navigator.pop(
      context,
      _UserFormResult(
        fullName: _fullName.text.trim(),
        fullNameAr: _fullNameAr.text.trim(),
        username: _username.text.trim(),
        email: _email.text.trim(),
        password: _password.text.isEmpty ? 'changeme123' : _password.text,
        role: _role,
      ),
    );
  }

  void _showFieldError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return AlertDialog(
      title: Text(isEditing
          ? context.tr('Edit User', 'تعديل المستخدم')
          : context.tr('Create User', 'إنشاء مستخدم')),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _fullName,
                validator: _required,
                decoration: InputDecoration(
                    labelText: context.tr('Full Name', 'الاسم الكامل')),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _fullNameAr,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                    labelText: context.tr('Full Name (Arabic)',
                        'الاسم الكامل (عربي)')),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _username,
                validator: _required,
                decoration: InputDecoration(
                    labelText: context.tr('Username', 'اسم المستخدم')),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    labelText: context.tr('Email', 'البريد الإلكتروني')),
              ),
              if (!isEditing) ...[
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  validator: (v) => (v == null || v.length < 4)
                      ? context.trRead('At least 4 characters',
                          '4 أحرف على الأقل')
                      : null,
                  decoration: InputDecoration(
                      labelText: context.tr('Password', 'كلمة المرور')),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<UserRole>(
                initialValue: _role,
                decoration:
                    InputDecoration(labelText: context.tr('Role', 'الدور')),
                items: [
                  for (final r in UserRole.values)
                    DropdownMenuItem(
                        value: r, child: Text(r.label(context.isArabic))),
                ],
                onChanged: (v) => setState(() => _role = v ?? _role),
              ),
            ],
          ),
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
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Text(context.tr('Save', 'حفظ')),
        ),
      ],
    );
  }
}
