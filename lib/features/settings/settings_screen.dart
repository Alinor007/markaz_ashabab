import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/models.dart';
import '../../core/i18n/locale_controller.dart';
import '../../core/i18n/localized.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/common/role_badge.dart';
import '../../widgets/layout/module_page.dart';

/// Settings: account summary, language/appearance, notifications, and
/// application/about information.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifyReports = true;
  bool _notifyActivities = true;
  bool _notifyMentions = false;

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
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
                                onPressed: () => _toast(context.trRead(
                                    'Password reset link sent.',
                                    'تم إرسال رابط إعادة التعيين.')),
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
            icon: Icons.notifications_outlined,
            title: context.tr('Notifications', 'الإشعارات'),
            child: Column(
              children: [
                _SwitchRow(
                  title: context.tr('New reports', 'تقارير جديدة'),
                  subtitle: context.tr(
                      'Notify when a report is published.',
                      'تنبيه عند نشر تقرير.'),
                  value: _notifyReports,
                  onChanged: (v) => setState(() => _notifyReports = v),
                ),
                _SwitchRow(
                  title: context.tr('Upcoming activities', 'الأنشطة القادمة'),
                  subtitle: context.tr(
                      'Reminders for scheduled activities.',
                      'تذكيرات بالأنشطة المجدولة.'),
                  value: _notifyActivities,
                  onChanged: (v) => setState(() => _notifyActivities = v),
                ),
                _SwitchRow(
                  title: context.tr('Mentions', 'الإشارات'),
                  subtitle: context.tr(
                      'When you are mentioned in a record.',
                      'عند الإشارة إليك في سجل.'),
                  value: _notifyMentions,
                  onChanged: (v) => setState(() => _notifyMentions = v),
                  isLast: true,
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
                      'Markaz Archive System', 'نظام أرشيف المركز'),
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

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: AppColors.emerald,
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
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
