import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../common/role_badge.dart';

enum UserAction { edit, resetPassword, toggleActive, delete }

/// A user list row for the admin User Management module, with an actions menu.
class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user, required this.onAction});

  final User user;
  final ValueChanged<UserAction> onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    final lastActive = user.lastActive == null
        ? '—'
        : '${user.lastActive!.toIso8601String().substring(0, 10)} '
            '${user.lastActive!.toIso8601String().substring(11, 16)}';
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: user.role.color.withValues(alpha: 0.15),
            child: Text(
              user.avatarInitials,
              style: theme.textTheme.titleSmall?.copyWith(color: user.role.color),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.displayName(isArabic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: theme.textTheme.titleSmall),
                Text('@${user.username} · ${user.email}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: RoleBadge(role: user.role, compact: true),
            ),
          ),
          Expanded(
            flex: 2,
            child: _StatusPill(active: user.active),
          ),
          Expanded(
            flex: 2,
            child: Text(lastActive,
                style: theme.textTheme.bodySmall, textAlign: TextAlign.start),
          ),
          PopupMenuButton<UserAction>(
            icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
            tooltip: context.tr('User actions', 'إجراءات المستخدم'),
            onSelected: onAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: UserAction.edit,
                child: _MenuRow(
                    icon: Icons.edit_outlined,
                    label: context.tr('Edit User', 'تعديل المستخدم')),
              ),
              PopupMenuItem(
                value: UserAction.resetPassword,
                child: _MenuRow(
                    icon: Icons.lock_reset_outlined,
                    label:
                        context.tr('Reset Password', 'إعادة تعيين كلمة المرور')),
              ),
              PopupMenuItem(
                value: UserAction.toggleActive,
                child: _MenuRow(
                  icon: user.active
                      ? Icons.block_outlined
                      : Icons.check_circle_outline,
                  label: user.active
                      ? context.tr('Disable User', 'تعطيل المستخدم')
                      : context.tr('Enable User', 'تفعيل المستخدم'),
                ),
              ),
              PopupMenuItem(
                value: UserAction.delete,
                child: _MenuRow(
                    icon: Icons.delete_outline,
                    label: context.tr('Delete User', 'حذف المستخدم'),
                    danger: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.emerald : AppColors.textFaint;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          active
              ? context.tr('Active', 'نشط')
              : context.tr('Disabled', 'معطّل'),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow(
      {required this.icon, required this.label, this.danger = false});
  final IconData icon;
  final String label;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.charcoal;
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSpacing.md),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
