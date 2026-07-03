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
import '../../core/theme/app_typography.dart';
import '../../widgets/common/member_picker.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import '../../widgets/layout/module_page.dart';
import '../tarbiya/widgets/confirm_dialog.dart';
import '../tarbiya/widgets/name_form_dialog.dart';
import 'widgets/leader_medallion.dart';

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
/// an Add Position action, then the positions themselves.
///
/// Office of the President (`office_president`), Board of Trustees (`board`),
/// and General Membership (`assembly_general`) are rank-ordered, so they
/// render as rows of growing size per [_rowSize]. All other categories keep
/// the original "prominent first card + even wrap" layout.
class _PositionsGroup extends StatelessWidget {
  const _PositionsGroup({
    required this.code,
    required this.canManage,
  });

  final String code;
  final bool canManage;

  /// Categories that use the rank-ordered row layout instead of the flat
  /// wrap layout.
  bool get _usesPyramidLayout =>
      code == 'office_president' || code == 'board' || code == 'assembly_general';

  /// The number of cards in row [rowIndex] (0-based) for categories that use
  /// the rank-ordered row layout.
  ///
  /// - `office_president`: 1, 2, 3, 4, ... (classic pyramid).
  /// - `board`: 3, 4, 4, 4, ...
  /// - `assembly_general`: 1, 2, 4, 4, 4, ...
  int _rowSize(int rowIndex) {
    switch (code) {
      case 'board':
        return rowIndex == 0 ? 3 : 4;
      case 'assembly_general':
        if (rowIndex == 0) return 1;
        if (rowIndex == 1) return 2;
        return 4;
      default:
        return rowIndex + 1;
    }
  }

  /// A short office abbreviation shown as a gold tag on each card's cover.
  String get _tag => switch (code) {
        'office_president' => 'OP',
        'board' => 'BOT',
        'assembly_general' => 'GM',
        'committee_hayah' => 'HS',
        'committee_audit' => 'AUD',
        _ => 'LDR',
      };

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

            if (_usesPyramidLayout) {
              return _PyramidPositions(
                positions: positions,
                rowSize: _rowSize,
                canManage: canManage,
                tag: _tag,
                onAssign: (p) => _assign(context, p),
                onClear: (p) => _clear(context, p),
                onEdit: (p) => _edit(context, p),
                onDelete: (p) => _delete(context, p),
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
                      tag: _tag,
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
                          tag: _tag,
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

/// Renders [positions] in rank order as rows, with each row's size given by
/// [rowSize] (0-based row index). The final row may be shorter than its
/// target size if there aren't enough remaining positions to fill it; that's
/// expected as new positions get added over time.
///
/// Assumes [positions] already arrives in display/rank order (e.g. President
/// first, then Vice President, etc.) from `watchByCategoryCode`.
class _PyramidPositions extends StatelessWidget {
  const _PyramidPositions({
    required this.positions,
    required this.rowSize,
    required this.canManage,
    required this.tag,
    required this.onAssign,
    required this.onClear,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Leader> positions;
  final int Function(int rowIndex) rowSize;
  final bool canManage;
  final String tag;
  final void Function(Leader) onAssign;
  final void Function(Leader) onClear;
  final void Function(Leader) onEdit;
  final void Function(Leader) onDelete;

  List<List<Leader>> get _rows {
    final rows = <List<Leader>>[];
    var index = 0;
    var rowIndex = 0;
    while (index < positions.length) {
      final size = rowSize(rowIndex);
      final end =
          (index + size < positions.length) ? index + size : positions.length;
      rows.add(positions.sublist(index, end));
      index = end;
      rowIndex++;
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    return Column(
      children: [
        for (var r = 0; r < rows.length; r++) ...[
          if (r > 0) const SizedBox(height: AppSpacing.xl),
          _PyramidRow(
            positions: rows[r],
            // A row with a single card (typically the lone top position)
            // gets the larger "prominent" treatment; multi-card rows are
            // uniform, even when they appear first (e.g. Board of Trustees'
            // 3-card opening row).
            prominent: rows[r].length == 1,
            canManage: canManage,
            tag: tag,
            onAssign: onAssign,
            onClear: onClear,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ],
    );
  }
}

/// One horizontal row of the pyramid, centered, wrapping gracefully on
/// narrow screens if there isn't room for the full row on one line.
class _PyramidRow extends StatelessWidget {
  const _PyramidRow({
    required this.positions,
    required this.prominent,
    required this.canManage,
    required this.tag,
    required this.onAssign,
    required this.onClear,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Leader> positions;
  final bool prominent;
  final bool canManage;
  final String tag;
  final void Function(Leader) onAssign;
  final void Function(Leader) onClear;
  final void Function(Leader) onEdit;
  final void Function(Leader) onDelete;

  /// The smallest a card is allowed to shrink to before we give up trying to
  /// keep the whole row on one line and let it wrap instead (narrow/mobile
  /// screens).
  static const double _minCardWidth = 140.0;

  @override
  Widget build(BuildContext context) {
    final idealWidth = prominent ? 360.0 : 260.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = positions.length;
        final fitWidth = count > 1
            ? (constraints.maxWidth - AppSpacing.lg * (count - 1)) / count
            : idealWidth;
        // Shrink cards so a row that would otherwise overflow onto a second
        // line (e.g. a 4-card row) still fits on one line, as long as that
        // doesn't shrink them below a legible minimum.
        final cardWidth = fitWidth >= _minCardWidth
            ? (fitWidth < idealWidth ? fitWidth : idealWidth)
            : idealWidth;
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            for (final p in positions)
              SizedBox(
                width: cardWidth,
                child: _PositionCard(
                  position: p,
                  prominent: prominent,
                  canManage: canManage,
                  tag: tag,
                  onAssign: () => onAssign(p),
                  onClear: () => onClear(p),
                  onEdit: () => onEdit(p),
                  onDelete: () => onDelete(p),
                ),
              ),
          ],
        );
      },
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
    required this.tag,
    required this.onAssign,
    required this.onClear,
    required this.onEdit,
    required this.onDelete,
  });

  final Leader position;
  final bool prominent;
  final bool canManage;
  final String tag;
  final VoidCallback onAssign;
  final VoidCallback onClear;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<LeaderRepository>();
    return StreamBuilder<Member?>(
      stream: repo.watchAssignedMember(position.id),
      builder: (context, snap) {
        final member = snap.data;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.panel,
            border: Border.all(
                color: AppColors.border, width: prominent ? 1.5 : 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.charcoal.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _cover(context, member),
              _body(context, member),
            ],
          ),
        );
      },
    );
  }

  /// The full-bleed portrait cover that fades into the white body, with the gold
  /// office tag and (for managers) a discreet actions menu.
  Widget _cover(BuildContext context, Member? member) {
    final cover = LeaderCover(
      assigned: member != null,
      initials: member?.initials ?? '',
      imagePath: member?.photoPath,
      accent: AppColors.emerald,
    );
    return AspectRatio(
      aspectRatio: prominent ? 1.04 : 0.94,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Tapping a filled portrait opens the view-only leader profile.
          if (member != null)
            InkWell(
              onTap: () => context.push('/leadership/member/${member.id}'),
              child: cover,
            )
          else
            cover,
          if (canManage)
            PositionedDirectional(
              top: AppSpacing.sm,
              start: AppSpacing.sm,
              child: _ManageMenu(
                member: member,
                onAssign: onAssign,
                onClear: onClear,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ),
          PositionedDirectional(
            top: AppSpacing.md,
            end: AppSpacing.md,
            child: LeaderTag(label: tag),
          ),
        ],
      ),
    );
  }

  /// The white lower section: name (serif), Arabic name (gold), office, and the
  /// optional term line.
  Widget _body(BuildContext context, Member? member) {
    final isArabic = context.isArabic;
    final office = isArabic ? position.positionAr : position.position;
    final name = member?.displayName(isArabic) ??
        context.tr('Vacant Position', 'منصب شاغر');
    final secondaryAr =
        (!isArabic && member != null && member.nameAr.trim().isNotEmpty)
            ? member.nameAr
            : '';
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name,
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyle(
                    fontFamily: AppTypography.serif,
                    fontSize: prominent ? 26 : 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                    height: 1.2,
                  ),
                ),
              ),
              if (secondaryAr.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm, top: 4),
                  child: Text(
                    secondaryAr,
                    textDirection: TextDirection.rtl,
                    style: AppTypography.arabic(
                        fontSize: 15, color: AppColors.goldDeep),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            office,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(
              fontFamily: AppTypography.serif,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: AppColors.navy,
              height: 1.3,
            ),
          ),
          if (position.serviceYears.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.account_balance_outlined,
                    size: 15, color: AppColors.textFaint),
                const SizedBox(width: AppSpacing.xs),
                Text(position.serviceYears,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// A discreet circular actions menu placed over a card's cover (managers only):
/// assign/reassign, edit, unassign, and delete.
class _ManageMenu extends StatelessWidget {
  const _ManageMenu({
    required this.member,
    required this.onAssign,
    required this.onClear,
    required this.onEdit,
    required this.onDelete,
  });

  final Member? member;
  final VoidCallback onAssign;
  final VoidCallback onClear;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        shape: BoxShape.circle,
      ),
      child: PopupMenuButton<String>(
        tooltip: context.trRead('Manage', 'إدارة'),
        icon: const Icon(Icons.more_vert, size: 18, color: AppColors.charcoal),
        onSelected: (v) {
          if (v == 'assign') onAssign();
          if (v == 'edit') onEdit();
          if (v == 'clear') onClear();
          if (v == 'delete') onDelete();
        },
        itemBuilder: (_) => [
          PopupMenuItem(
              value: 'assign',
              child: Text(member == null
                  ? context.trRead('Assign member', 'تعيين عضو')
                  : context.trRead('Reassign member', 'إعادة تعيين عضو'))),
          PopupMenuItem(
              value: 'edit',
              child: Text(context.trRead('Edit position', 'تعديل المنصب'))),
          if (member != null)
            PopupMenuItem(
                value: 'clear',
                child: Text(context.trRead('Unassign', 'إلغاء التعيين'))),
          PopupMenuItem(
              value: 'delete',
              child: Text(context.trRead('Delete position', 'حذف المنصب'))),
        ],
      ),
    );
  }
}