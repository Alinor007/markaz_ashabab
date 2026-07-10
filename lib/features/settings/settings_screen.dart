import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/password_hasher.dart';
import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/audit_repository.dart';
import '../../core/repositories/user_repository.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/common/role_badge.dart';
import '../../widgets/layout/module_page.dart';

/// Settings: account summary, language/appearance, and application/about
/// information.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _changePassword(User user) async {
    final newPassword = await showDialog<String>(
      context: context,
      builder: (_) => _ChangePasswordDialog(currentHash: user.passwordHash),
    );
    if (newPassword == null || !mounted) return;
    final repo = context.read<UserRepository>();
    final audit = context.read<AuditRepository>();
    final session = context.read<SessionController>();
    await repo.resetPassword(user.id, newPassword);
    await session.refreshUser();
    await audit.log(
      username: user.username,
      action: 'Changed own password',
      module: 'Account',
    );
    if (!mounted) return;
    _toast('Password updated.');
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final user = context.watch<SessionController>().user;

    return ModulePage(
      english: 'Settings',
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoPanel(
            icon: Icons.account_circle_outlined,
            title: 'Account',
            child: user == null
                ? const SizedBox.shrink()
                : Row(
                    children: [
                      PortraitAvatar(
                        initials: user.avatarInitials,
                        size: 64,
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName(isArabic),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            RoleBadge(role: user.role, compact: true),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _changePassword(user),
                        icon: const Icon(Icons.lock_reset_outlined, size: 18),
                        label: Text('Change Password'),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.lg),
          InfoPanel(
            icon: Icons.info_outline,
            title: 'About',
            child: Column(
              children: [
                _InfoRow(
                  label: 'Application',
                  value: 'Markazosshabab App',
                ),
                _InfoRow(
                  label: 'Version',
                  value: '1.0.0',
                ),
                _InfoRow(
                  label: 'Mode',
                  value: 'Offline · Internal',
                ),
                _InfoRow(
                  label: 'Storage',
                  value: 'Local device',
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Prompts for the current password (verified against [currentHash]) and a
/// new password (entered twice), each with an independent show/hide toggle.
/// Pops the new password on save, or null on cancel.
class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog({required this.currentHash});
  final String currentHash;

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNext = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, _next.text);
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(obscure
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
          onPressed: toggle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Change Password'),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _passwordField(
                controller: _current,
                label: 'Current Password',
                obscure: _obscureCurrent,
                toggle: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Required';
                  }
                  if (!PasswordHasher.verify(v, widget.currentHash)) {
                    return 'Current password is incorrect.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _passwordField(
                controller: _next,
                label: 'New Password',
                obscure: _obscureNext,
                toggle: () => setState(() => _obscureNext = !_obscureNext),
                validator: (v) => (v == null || v.length < 4)
                    ? 'At least 4 characters'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              _passwordField(
                controller: _confirm,
                label: 'Confirm New Password',
                obscure: _obscureConfirm,
                toggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (v) => v != _next.text
                    ? 'Passwords do not match'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text('Save'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Text(label, style: theme.textTheme.labelMedium),
              ),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}
