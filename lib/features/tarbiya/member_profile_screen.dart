import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/repositories/tarbiya_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/hierarchy_breadcrumb.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import 'member_profile_cards.dart';
import 'widgets/confirm_dialog.dart';

/// Level 4 (detail) — full member profile with all CRUD cards.
class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context) {
    final memberRepo = context.read<MemberRepository>();
    final tarbiyaRepo = context.read<TarbiyaRepository>();
    final canManage =
        context.read<SessionController>().can?.manageTarbiya ?? false;

    return StreamBuilder<Member?>(
      stream: memberRepo.watchMember(memberId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
              padding: EdgeInsets.all(AppSpacing.xxl), child: LoadingState());
        }
        final member = snap.data;
        if (member == null) {
          return EmptyState(
            icon: Icons.person_off_outlined,
            title: context.tr('Member not found', 'العضو غير موجود'),
          );
        }
        return FutureBuilder<(Shuba?, TarbiyaArea?)>(
          future: _loadContext(tarbiyaRepo, member.shubaId),
          builder: (context, ctxSnap) {
            final shuba = ctxSnap.data?.$1;
            final area = ctxSnap.data?.$2;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _breadcrumb(context, member, shuba, area),
                  const SizedBox(height: AppSpacing.lg),
                  _Header(
                    member: member,
                    shuba: shuba,
                    area: area,
                    canManage: canManage,
                    onEdit: () =>
                        context.go('/tarbiya/member/${member.id}/edit'),
                    onDelete: () => _delete(context, memberRepo, member),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Two-column card layout.
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              PersonalInfoCard(member: member),
                              const SizedBox(height: AppSpacing.lg),
                              FamilyChildrenCard(member: member),
                              const SizedBox(height: AppSpacing.lg),
                              EducationCard(member: member),
                              const SizedBox(height: AppSpacing.lg),
                              ActivityHistoryCard(
                                  member: member, canManage: canManage),
                              const SizedBox(height: AppSpacing.lg),
                              ContributionsCard(
                                  member: member, canManage: canManage),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              NaqibUsraCard(member: member),
                              const SizedBox(height: AppSpacing.lg),
                              TasedCard(member: member, canManage: canManage),
                              const SizedBox(height: AppSpacing.lg),
                              DonationCard(
                                  member: member, canManage: canManage),
                              const SizedBox(height: AppSpacing.lg),
                              OrgRolesCard(
                                  member: member, canManage: canManage),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<(Shuba?, TarbiyaArea?)> _loadContext(
      TarbiyaRepository repo, String shubaId) async {
    final shuba = await repo.getShuba(shubaId);
    final area = shuba == null ? null : await repo.getArea(shuba.areaId);
    return (shuba, area);
  }

  Widget _breadcrumb(
      BuildContext context, Member member, Shuba? shuba, TarbiyaArea? area) {
    final isArabic = context.isArabic;
    return HierarchyBreadcrumb(
      crumbs: [
        Crumb(
          label: context.tr('Tarbiya Al-Kawadeer', 'تربية الكوادر'),
          route: '/tarbiya',
          icon: Icons.hub_outlined,
        ),
        if (area != null)
          Crumb(
              label: isArabic ? area.nameAr : area.name,
              route: '/tarbiya/area/${area.id}'),
        if (shuba != null && area != null)
          Crumb(
              label: isArabic ? shuba.nameAr : shuba.name,
              route: '/tarbiya/area/${area.id}/shuba/${shuba.id}'),
        if (shuba != null)
          Crumb(
              label: context.tr('Level ${member.level}', 'المستوى ${member.level}'),
              route:
                  '/tarbiya/area/${area?.id}/shuba/${shuba.id}/level/${member.level}'),
        Crumb(label: member.displayName(isArabic)),
      ],
    );
  }

  Future<void> _delete(
      BuildContext context, MemberRepository repo, Member member) async {
    final ok = await confirmDialog(
      context,
      title: context.trRead('Delete member?', 'حذف العضو؟'),
      message: context.trRead(
          'This permanently removes ${member.fullName} and all their records.',
          'سيؤدي هذا إلى حذف ${member.fullName} وجميع سجلاته نهائيًا.'),
    );
    if (!ok) return;
    final shubaId = member.shubaId;
    await repo.deleteMember(member.id);
    if (context.mounted) {
      // Return to the member's level list if we can resolve it, else the module.
      final tarbiya = context.read<TarbiyaRepository>();
      final shuba = await tarbiya.getShuba(shubaId);
      if (context.mounted) {
        context.go(shuba == null
            ? '/tarbiya'
            : '/tarbiya/area/${shuba.areaId}/shuba/$shubaId/level/${member.level}');
      }
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.member,
    required this.shuba,
    required this.area,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });

  final Member member;
  final Shuba? shuba;
  final TarbiyaArea? area;
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final hasPhoto = member.photoPath.isNotEmpty &&
        File(member.photoPath).existsSync();
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.navy, AppColors.emerald],
        ),
        borderRadius: AppRadius.panel,
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        children: [
          if (hasPhoto)
            CircleAvatar(
                radius: 48, backgroundImage: FileImage(File(member.photoPath)))
          else
            PortraitAvatar(
                initials: member.initials, accent: AppColors.gold, size: 96),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  member.displayName(isArabic),
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                  style: isArabic
                      ? AppTypography.arabic(
                          fontSize: 30,
                          color: AppColors.onEmerald,
                          fontWeight: FontWeight.w700)
                      : Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(color: AppColors.onEmerald),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _chip(context, Icons.workspace_premium_outlined,
                        context.tr('Level ${member.level}', 'المستوى ${member.level}')),
                    if (area != null)
                      _chip(context, Icons.map_outlined,
                          isArabic ? area!.nameAr : area!.name),
                    if (shuba != null)
                      _chip(context, Icons.location_city_outlined,
                          isArabic ? shuba!.nameAr : shuba!.name),
                    _chip(
                        context,
                        member.isActive
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        member.isActive
                            ? context.tr('Active', 'نشط')
                            : context.tr('Inactive', 'غير نشط')),
                    if (member.dateJoined.isNotEmpty)
                      _chip(context, Icons.event_outlined,
                          '${context.tr('Joined', 'انضم')} ${member.dateJoined}'),
                  ],
                ),
              ],
            ),
          ),
          if (canManage) ...[
            _HeaderAction(
                icon: Icons.edit_outlined,
                label: context.tr('Edit', 'تعديل'),
                onTap: onEdit),
            const SizedBox(width: AppSpacing.sm),
            _HeaderAction(
                icon: Icons.delete_outline,
                label: context.tr('Delete', 'حذف'),
                onTap: onDelete),
          ],
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.85)),
          const SizedBox(width: AppSpacing.xs),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: AppSpacing.xs),
              Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
