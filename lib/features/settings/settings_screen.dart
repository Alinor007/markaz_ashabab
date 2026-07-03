import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/password_hasher.dart';
import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/locale_controller.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/audit_repository.dart';
import '../../core/repositories/user_repository.dart';
import '../../core/theme/app_colors.dart';
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
      actionAr: 'غيّر كلمة مروره الخاصة',
      module: 'Account',
      moduleAr: 'الحساب',
    );
    if (!mounted) return;
    _toast(context.trRead('Password updated.', 'تم تحديث كلمة المرور.'));
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final locale = context.watch<LocaleController>();
    final user = context.watch<SessionController>().user;

    return ModulePage(
      english: 'Settings',
      arabic: 'الإعدادات',
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: InfoPanel(
                    icon: Icons.account_circle_outlined,
                    title: context.tr('Account', 'الحساب'),
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
                                      textDirection: isArabic
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    RoleBadge(role: user.role, compact: true),
                                  ],
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _changePassword(user),
                                icon: const Icon(Icons.lock_reset_outlined,
                                    size: 18),
                                label: Text(context.tr(
                                    'Change Password', 'تغيير كلمة المرور')),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  flex: 2,
                  child: InfoPanel(
                    icon: Icons.translate_outlined,
                    title: context.tr('Language', 'اللغة'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr(
                              'Choose the interface language.',
                              'اختر لغة الواجهة.'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _LanguageChoice(locale: locale),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          InfoPanel(
            icon: Icons.info_outline,
            title: context.tr('About', 'حول التطبيق'),
            child: Column(
              children: [
                _InfoRow(
                  label: context.tr('Application', 'التطبيق'),
                  value: context.tr(
                      'Markazosshabab App', 'تطبيق مركز الشباب'),
                ),
                _InfoRow(
                  label: context.tr('Version', 'الإصدار'),
                  value: '1.0.0',
                ),
                _InfoRow(
                  label: context.tr('Mode', 'الوضع'),
                  value: context.tr('Offline · Internal', 'دون اتصال · داخلي'),
                ),
                _InfoRow(
                  label: context.tr('Storage', 'التخزين'),
                  value: context.tr('Local device', 'الجهاز المحلي'),
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
      title: Text(context.tr('Change Password', 'تغيير كلمة المرور')),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _passwordField(
                controller: _current,
                label: context.tr('Current Password', 'كلمة المرور الحالية'),
                obscure: _obscureCurrent,
                toggle: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return context.trRead('Required', 'مطلوب');
                  }
                  if (!PasswordHasher.verify(v, widget.currentHash)) {
                    return context.trRead('Current password is incorrect.',
                        'كلمة المرور الحالية غير صحيحة.');
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _passwordField(
                controller: _next,
                label: context.tr('New Password', 'كلمة المرور الجديدة'),
                obscure: _obscureNext,
                toggle: () => setState(() => _obscureNext = !_obscureNext),
                validator: (v) => (v == null || v.length < 4)
                    ? context.trRead(
                        'At least 4 characters', '4 أحرف على الأقل')
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              _passwordField(
                controller: _confirm,
                label: context.tr(
                    'Confirm New Password', 'تأكيد كلمة المرور الجديدة'),
                obscure: _obscureConfirm,
                toggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (v) => v != _next.text
                    ? context.trRead(
                        'Passwords do not match', 'كلمتا المرور غير متطابقتين')
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('Cancel', 'إلغاء')),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(context.tr('Save', 'حفظ')),
        ),
      ],
    );
  }
}

class _LanguageChoice extends StatelessWidget {
  const _LanguageChoice({required this.locale});
  final LocaleController locale;

  @override
  Widget build(BuildContext context) {
    Widget option(String label, bool active, VoidCallback onTap) {
      return Expanded(
        child: Material(
          color: active ? AppColors.emerald : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                    color: active ? AppColors.emerald : AppColors.border),
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color:
                          active ? AppColors.onEmerald : AppColors.textMuted,
                    ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        option('English', !locale.isArabic,
            () => locale.setLocale(LocaleController.english)),
        const SizedBox(width: AppSpacing.md),
        option('العربية', locale.isArabic,
            () => locale.setLocale(LocaleController.arabic)),
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
