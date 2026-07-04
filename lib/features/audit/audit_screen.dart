import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/audit_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/cards/timeline_item.dart';
import '../../widgets/feedback/app_snackbar.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/error_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import '../tarbiya/widgets/confirm_dialog.dart';

/// Admin Audit Logs: a live, database-backed timeline of user actions.
class AuditScreen extends StatelessWidget {
  const AuditScreen({super.key});

  Future<void> _clear(BuildContext context) async {
    final repo = context.read<AuditRepository>();
    final ok = await confirmDialog(
      context,
      title: 'Clear audit log?',
      message: 'This permanently deletes all audit log entries and cannot be undone.',
    );
    if (!ok || !context.mounted) return;
    await repo.clearAll();
    if (context.mounted) {
      showAppSnackBar(
          context, 'Audit log cleared.',
          tone: SnackTone.info);
    }
  }

  IconData _iconFor(String module) {
    switch (module) {
      case 'User Management':
        return Icons.manage_accounts_outlined;
      case 'Leadership':
        return Icons.workspace_premium_outlined;
      case 'Authentication':
        return Icons.login;
      case 'Reports':
        return Icons.description_outlined;
      default:
        return Icons.circle;
    }
  }

  Color _colorFor(String module) {
    switch (module) {
      case 'User Management':
        return AppColors.emerald;
      case 'Leadership':
        return AppColors.goldDeep;
      case 'Authentication':
        return AppColors.navy;
      default:
        return AppColors.textMuted;
    }
  }

  String _formatTime(DateTime t) {
    final iso = t.toIso8601String();
    return '${iso.substring(0, 10)} ${iso.substring(11, 16)}';
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return ModulePage(
      english: 'Audit Logs',
      arabic: 'سجلات التدقيق',
      actions: [
        OutlinedButton.icon(
          onPressed: () => _clear(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error),
          ),
          icon: const Icon(Icons.delete_sweep_outlined, size: 18),
          label: Text('Clear Log'),
        ),
      ],
      child: StreamBuilder<List<AuditLog>>(
        stream: context.read<AuditRepository>().watchAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorState(
                title: 'Failed to load audit logs.');
          }
          if (!snapshot.hasData) return const LoadingState();
          final logs = snapshot.data!;
          if (logs.isEmpty) {
            return EmptyState(
              icon: Icons.fact_check_outlined,
              title: 'No activity yet',
            );
          }
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.card,
              border: Border.all(color: AppColors.border),
            ),
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, i) {
                final entry = logs[i];
                final color = _colorFor(entry.module);
                return TimelineItem(
                  icon: _iconFor(entry.module),
                  accent: color,
                  isFirst: i == 0,
                  isLast: i == logs.length - 1,
                  timestamp:
                      '${_formatTime(entry.timestamp)}  ·  @${entry.username}',
                  title: isArabic && entry.actionAr.isNotEmpty
                      ? entry.actionAr
                      : entry.action,
                  trailing: _ModuleTag(
                    label: isArabic && entry.moduleAr.isNotEmpty
                        ? entry.moduleAr
                        : entry.module,
                    color: color,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ModuleTag extends StatelessWidget {
  const _ModuleTag({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
