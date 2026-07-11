import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/roles.dart';
import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/audit_repository.dart';
import '../../core/repositories/department_repository.dart';
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
    switch (action) {
      case UserAction.edit:
        await _openUserDialog(existing: user);
      case UserAction.resetPassword:
        await _resetPassword(user);
      case UserAction.toggleActive:
        if (user.id == selfId) {
          _toast('You cannot disable your own account.');
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
          module: 'User Management',
        );
      case UserAction.delete:
        if (user.id == selfId) {
          _toast(
               'You cannot delete your own account.');
          return;
        }
        await _confirmDelete(user);
    }
  }

  Future<void> _resetPassword(User user) async {
    final repo = _repo;
    final audit = _audit;
    final actor = _actor;
    final ar = context.isArabic;
    final controller = TextEditingController();
    var obscured = true;
    final newPassword = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setLocal) => AlertDialog(
          title: Text('Reset Password'),
          content: SizedBox(
            width: 360,
            child: TextField(
              controller: controller,
              obscureText: obscured,
              decoration: InputDecoration(
                labelText: 'New Password',
                suffixIcon: IconButton(
                  icon: Icon(obscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () => setLocal(() => obscured = !obscured),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, controller.text),
              child: Text('Reset'),
            ),
          ],
        ),
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
      module: 'User Management',
    );
    _toast(ar ? 'تم تحديث كلمة المرور.' : 'Password updated.');
  }

  Future<void> _confirmDelete(User user) async {
    final repo = _repo;
    final audit = _audit;
    final actor = _actor;
    final ar = context.isArabic;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Delete "${user.username}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await repo.delete(user.id);
    await audit.log(
      username: actor,
      action: 'Deleted user "${user.username}"',
      module: 'User Management',
    );
    _toast(ar ? 'تم حذف المستخدم.' : 'User deleted.');
  }

  Future<void> _openUserDialog({User? existing}) async {
    final repo = _repo;
    final audit = _audit;
    final actor = _actor;
    final ar = context.isArabic;
    final result = await showDialog<_UserFormResult>(
      context: context,
      builder: (_) => _UserFormDialog(existing: existing, repo: repo),
    );
    if (result == null) return;
    if (existing == null) {
      await repo.create(
        fullName: result.fullName,
        username: result.username,
        email: result.email,
        password: result.password,
        role: result.role,
        departmentId: result.departmentId,
      );
      await audit.log(
        username: actor,
        action: 'Created user "${result.username}"',
        module: 'User Management',
      );
      _toast(ar ? 'تم إنشاء المستخدم.' : 'User created.');
    } else {
      await repo.updateProfile(
        id: existing.id,
        fullName: result.fullName,
        username: result.username,
        email: result.email,
        role: result.role,
        departmentId: result.departmentId,
      );
      await audit.log(
        username: actor,
        action: 'Updated user "${result.username}"',
        module: 'User Management',
      );
      _toast(ar ? 'تم تحديث المستخدم.' : 'User updated.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final roles = [
      'All Roles',
      for (final r in UserRole.values) r.label(context.isArabic),
    ];

    return ModulePage(
      english: 'User Management',
      actions: [
        SearchField(
          width: 240,
          hint: 'Search users…',
          onChanged: (v) => setState(() => _query = v),
        ),
        FilledButton.icon(
          onPressed: () => _openUserDialog(),
          icon: const Icon(Icons.person_add_alt_1, size: 18),
          label: Text('Create User'),
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
                      title: 'Failed to load users.');
                }
                if (!snapshot.hasData) {
                  return const LoadingState();
                }
                final filtered = _filter(snapshot.data!);
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.group_off_outlined,
                    title: 'No users found',
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
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.departmentId,
  });
  final String fullName;
  final String username;
  final String email;
  final String password;
  final UserRole role;

  /// Set only for Department Head accounts — the department they manage.
  final String? departmentId;
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
  late final _username =
      TextEditingController(text: widget.existing?.username ?? '');
  late final _email = TextEditingController(text: widget.existing?.email ?? '');
  final _password = TextEditingController();
  late UserRole _role = widget.existing?.role ?? UserRole.departmentHead;
  late String? _departmentId = widget.existing?.departmentId;
  late final Stream<List<Department>> _departments =
      context.read<DepartmentRepository>().watchAll();
  bool _saving = false;

  @override
  void dispose() {
    _fullName.dispose();
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty)
      ? 'Required'
      : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final exists = await widget.repo.usernameExists(
      _username.text,
      excludeId: widget.existing?.id,
    );
    if (!mounted) return;
    if (exists) {
      setState(() => _saving = false);
      _showFieldError(
         'Username already taken.');
      return;
    }
    Navigator.pop(
      context,
      _UserFormResult(
        fullName: _fullName.text.trim(),
        username: _username.text.trim(),
        email: _email.text.trim(),
        password: _password.text.isEmpty ? 'changeme123' : _password.text,
        role: _role,
        // Only a Department Head carries a department assignment.
        departmentId: _role == UserRole.departmentHead ? _departmentId : null,
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
          ? 'Edit User'
          : 'Create User'),
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
                    labelText: 'Full Name'),
              ),
    
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _username,
                // The username is permanent: it cannot be changed after the
                // account is created.
                readOnly: isEditing,
                enabled: !isEditing,
                validator: _required,
                decoration: InputDecoration(
                  labelText: 'Username',
                  helperText: isEditing
                      ? 'Username cannot be changed'
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    labelText: 'Email'),
              ),
              if (!isEditing) ...[
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  validator: (v) => (v == null || v.length < 4)
                      ? 'At least 4 characters'
                      : null,
                  decoration: InputDecoration(
                      labelText: 'Password'),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<UserRole>(
                initialValue: _role,
                decoration:
                    InputDecoration(labelText: 'Role'),
                items: [
                  for (final r in UserRole.values)
                    DropdownMenuItem(
                        value: r, child: Text(r.label(context.isArabic))),
                ],
                onChanged: (v) => setState(() => _role = v ?? _role),
              ),
              if (_role == UserRole.departmentHead) ...[
                const SizedBox(height: AppSpacing.md),
                StreamBuilder<List<Department>>(
                  stream: _departments,
                  builder: (context, snap) {
                    final depts = snap.data ?? const <Department>[];
                    // Drop a stale selection that no longer matches a
                    // department (e.g. it was deleted) so the dropdown
                    // doesn't crash on an unknown value.
                    final value =
                        depts.any((d) => d.id == _departmentId)
                            ? _departmentId
                            : null;
                    return DropdownButtonFormField<String>(
                      initialValue: value,
                      decoration: InputDecoration(
                          labelText: 'Department'),
                      items: [
                        for (final d in depts)
                          DropdownMenuItem(
                            value: d.id,
                            child: Text( d.name),
                          ),
                      ],
                      onChanged: (v) => setState(() => _departmentId = v),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Required'
                          : null,
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Text('Save'),
        ),
      ],
    );
  }
}
