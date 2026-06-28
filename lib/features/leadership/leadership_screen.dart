import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/audit_repository.dart';
import '../../core/repositories/leader_repository.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/common/member_picker.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import '../tarbiya/widgets/confirm_dialog.dart';
import '../tarbiya/widgets/name_form_dialog.dart';

/// A leadership positions screen for one category [code] — Office of the
/// President (`office_president`), Board of Trustees (`board`), or one of the
/// Consultative Assembly sub-sections (`assembly_general`, `committee_hayah`,
/// `committee_audit`). Each is a set of assignable positions filled by assigning
/// an existing member (no separate leader creation). Admins add, rename, and
/// delete positions; department heads are read-only. The Assembly sub-sections
/// are reached from the sidebar's nested dropdown.
class LeadershipPositionsScreen extends StatelessWidget {
  const LeadershipPositionsScreen({
    super.key,
    required this.code,
    required this.titleEn,
    required this.titleAr,
  });

  final String code;
  final String titleEn;
  final String titleAr;

  @override
  Widget build(BuildContext context) {
    final canManage =
        context.watch<SessionController>().can?.manageLeadership ?? false;
    return ModulePage(
      english: titleEn,
      arabic: titleAr,
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _GroupDescription(code: code, canManage: canManage),
          const SizedBox(height: AppSpacing.lg),
          _PositionsGroup(code: code, canManage: canManage),
        ],
      ),
    );
  }
}

/// An editable description of a leadership group's functions, shown above its
/// positions. Executives can edit the English/Arabic text.
class _GroupDescription extends StatelessWidget {
  const _GroupDescription({required this.code, required this.canManage});
  final String code;
  final bool canManage;

  Future<void> _edit(
      BuildContext context, LeadershipGroupInfoData? info) async {
    final desc = TextEditingController(text: info?.description ?? '');
    final descAr = TextEditingController(text: info?.descriptionAr ?? '');
    final repo = context.read<LeaderRepository>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(context.tr('Edit Description', 'تعديل الوصف')),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: desc,
                  minLines: 3,
                  maxLines: 8,
                  decoration: InputDecoration(
                      labelText: context.tr('Description', 'الوصف'),
                      alignLabelWithHint: true),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: descAr,
                  minLines: 3,
                  maxLines: 8,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                      labelText:
                          context.tr('Description (Arabic)', 'الوصف (عربي)'),
                      alignLabelWithHint: true),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(context.tr('Cancel', 'إلغاء'))),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(context.tr('Save', 'حفظ'))),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await repo.setGroupDescription(
          code, desc.text.trim(), descAr.text.trim());
    }
    desc.dispose();
    descAr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final repo = context.read<LeaderRepository>();
    return StreamBuilder<LeadershipGroupInfoData?>(
      stream: repo.watchGroupInfo(code),
      builder: (context, snap) {
        final info = snap.data;
        final text = isArabic ? (info?.descriptionAr ?? '') : (info?.description ?? '');
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 18, color: AppColors.emerald),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                        context.tr('Functions of this group',
                            'وظائف هذه المجموعة'),
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  if (canManage)
                    IconButton(
                      tooltip: context.tr('Edit', 'تعديل'),
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.edit_outlined,
                          size: 18, color: AppColors.emerald),
                      onPressed: () => _edit(context, info),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                text.trim().isEmpty
                    ? context.tr('No description provided.', 'لا يوجد وصف.')
                    : text,
                textDirection:
                    isArabic ? TextDirection.rtl : TextDirection.ltr,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A self-contained group of positions for one category [code]: a header with
/// an Add Position action, then a prominent first card and the rest in a wrap.
class _PositionsGroup extends StatelessWidget {
  const _PositionsGroup({
    required this.code,
    required this.canManage,
  });

  final String code;
  final bool canManage;

  LeaderRepository _leaders(BuildContext c) => c.read<LeaderRepository>();
  AuditRepository _audit(BuildContext c) => c.read<AuditRepository>();
  String _actor(BuildContext c) =>
      c.read<SessionController>().user?.username ?? 'system';

  Future<void> _add(BuildContext context) async {
    final r = await NameFormDialog.show(context,
        title: context.trRead('Add Position', 'إضافة منصب'));
    if (r == null || !context.mounted) return;
    await _leaders(context)
        .addPosition(code: code, title: r.name, titleAr: r.nameAr);
  }

  Future<void> _edit(BuildContext context, Leader p) async {
    final r = await NameFormDialog.show(
      context,
      title: context.trRead('Edit Position', 'تعديل المنصب'),
      name: p.position,
      nameAr: p.positionAr,
    );
    if (r == null || !context.mounted) return;
    await _leaders(context).editPosition(p.id, r.name, r.nameAr);
  }

  Future<void> _delete(BuildContext context, Leader p) async {
    final ok = await confirmDialog(
      context,
      title: context.trRead('Remove position?', 'إزالة المنصب؟'),
      message: context.trRead(
          'Remove the "${p.position}" position? This cannot be undone.',
          'إزالة منصب «${p.positionAr}»؟ لا يمكن التراجع.'),
    );
    if (!ok || !context.mounted) return;
    await _leaders(context).delete(p.id);
  }

  Future<void> _assign(BuildContext context, Leader p) async {
    final repo = context.read<MemberRepository>();
    final picked = await pickMember(context, repo,
        title: context.trRead('Assign a Member', 'تعيين عضو'));
    if (picked == null || !context.mounted) return;
    await _leaders(context).assignMember(p.id, picked.id);
    if (!context.mounted) return;
    await _audit(context).log(
      username: _actor(context),
      action: 'Assigned "${picked.fullName}" as ${p.position}',
      actionAr: 'عيّن «${picked.fullName}» في منصب ${p.positionAr}',
      module: 'Leadership',
      moduleAr: 'القيادة',
    );
  }

  Future<void> _clear(BuildContext context, Leader p) async {
    await _leaders(context).assignMember(p.id, null);
    if (!context.mounted) return;
    await _audit(context).log(
      username: _actor(context),
      action: 'Vacated the ${p.position} position',
      actionAr: 'أخلى منصب ${p.positionAr}',
      module: 'Leadership',
      moduleAr: 'القيادة',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (canManage)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton.icon(
              onPressed: () => _add(context),
              icon: const Icon(Icons.add, size: 18),
              label: Text(context.tr('Add Position', 'إضافة منصب')),
            ),
          ),
        if (canManage) const SizedBox(height: AppSpacing.lg),
        StreamBuilder<List<Leader>>(
          stream: _leaders(context).watchByCategoryCode(code),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Padding(
                  padding: EdgeInsets.all(AppSpacing.xl), child: LoadingState());
            }
            final positions = snap.data!;
            if (positions.isEmpty) {
              return EmptyState(
                icon: Icons.workspace_premium_outlined,
                title: context.tr('No positions yet', 'لا توجد مناصب بعد'),
                message: canManage
                    ? context.tr('Add the first position.', 'أضف أول منصب.')
                    : null,
              );
            }
            final prominent = positions.first;
            final others = positions.skip(1).toList();
            return Column(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: _PositionCard(
                      position: prominent,
                      prominent: true,
                      canManage: canManage,
                      onAssign: () => _assign(context, prominent),
                      onClear: () => _clear(context, prominent),
                      onEdit: () => _edit(context, prominent),
                      onDelete: () => _delete(context, prominent),
                    ),
                  ),
                ),
                if (others.isNotEmpty) const SizedBox(height: AppSpacing.xl),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppSpacing.lg,
                  runSpacing: AppSpacing.lg,
                  children: [
                    for (final p in others)
                      SizedBox(
                        width: 260,
                        child: _PositionCard(
                          position: p,
                          prominent: false,
                          canManage: canManage,
                          onAssign: () => _assign(context, p),
                          onClear: () => _clear(context, p),
                          onEdit: () => _edit(context, p),
                          onDelete: () => _delete(context, p),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// A single position card: title, the assigned member (photo + name) or an
/// "Unassigned" placeholder, an Assign/Reassign action, and an admin menu to
/// edit, unassign, or delete the position.
class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.position,
    required this.prominent,
    required this.canManage,
    required this.onAssign,
    required this.onClear,
    required this.onEdit,
    required this.onDelete,
  });

  final Leader position;
  final bool prominent;
  final bool canManage;
  final VoidCallback onAssign;
  final VoidCallback onClear;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final repo = context.read<LeaderRepository>();
    final title = isArabic ? position.positionAr : position.position;
    final avatarSize = prominent ? 104.0 : 72.0;

    return StreamBuilder<Member?>(
      stream: repo.watchAssignedMember(position.id),
      builder: (context, snap) {
        final member = snap.data;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.card,
            border: Border.all(
                color: prominent ? AppColors.gold : AppColors.border,
                width: prominent ? 1.5 : 1),
          ),
          padding: EdgeInsets.all(prominent ? AppSpacing.xl : AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign:
                          canManage ? TextAlign.start : TextAlign.center,
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      style: (prominent
                              ? Theme.of(context).textTheme.titleLarge
                              : Theme.of(context).textTheme.titleMedium)
                          ?.copyWith(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (canManage)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert,
                          size: 18, color: AppColors.textMuted),
                      onSelected: (v) {
                        if (v == 'edit') onEdit();
                        if (v == 'clear') onClear();
                        if (v == 'delete') onDelete();
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                            value: 'edit',
                            child:
                                Text(context.trRead('Edit position', 'تعديل المنصب'))),
                        if (member != null)
                          PopupMenuItem(
                              value: 'clear',
                              child: Text(
                                  context.trRead('Unassign', 'إلغاء التعيين'))),
                        PopupMenuItem(
                            value: 'delete',
                            child: Text(
                                context.trRead('Delete position', 'حذف المنصب'))),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (member != null)
                InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  // Push (not go) so the back button returns to the leadership
                  // screen. Opens the view-only leader profile.
                  onTap: () =>
                      context.push('/leadership/member/${member.id}'),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PortraitAvatar(
                        initials: member.initials,
                        imagePath: member.photoPath,
                        size: avatarSize,
                        accent: AppColors.emerald,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        member.displayName(isArabic),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                )
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceAlt,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(Icons.person_outline,
                          size: avatarSize * 0.42, color: AppColors.textFaint),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.tr('Unassigned', 'غير معيّن'),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              if (canManage) ...[
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onAssign,
                    icon: const Icon(Icons.person_search_outlined, size: 18),
                    label: Text(member == null
                        ? context.tr('Assign', 'تعيين')
                        : context.tr('Reassign', 'إعادة تعيين')),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
