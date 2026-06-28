import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/common/profile_header.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';

/// View-only profile for a member who holds a leadership position. Shows three
/// sections only — Personal Information, Educational Background, and Role in
/// Organization — sourced from the member's record. No edit/delete, and none of
/// the member's family / Usra / donation details.
class LeaderProfileScreen extends StatelessWidget {
  const LeaderProfileScreen({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MemberRepository>();
    return FutureBuilder<Member?>(
      future: repo.getMember(memberId),
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
        return _Body(member: member);
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.member});
  final Member member;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final memberRepo = context.read<MemberRepository>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.canPop()
                ? context.pop()
                : context.go('/leadership/office-president'),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back,
                      size: 18, color: AppColors.emerald),
                  const SizedBox(width: AppSpacing.sm),
                  Text(context.tr('Back', 'رجوع'),
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: AppColors.emerald)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ProfileHeader(
            initials: member.initials,
            imagePath: member.photoPath,
            nameEn: member.fullName,
            nameAr: member.nameAr,
            subtitleEn: member.occupation.isEmpty ? 'Member' : member.occupation,
            subtitleAr: member.occupation.isEmpty ? 'عضو' : member.occupation,
            accent: AppColors.emerald,
          ),
          const SizedBox(height: AppSpacing.xl),

          // 1. Personal Information.
          InfoPanel(
            icon: Icons.person_outline,
            title: context.tr('Personal Information', 'المعلومات الشخصية'),
            child: Wrap(
              spacing: AppSpacing.xl,
              runSpacing: AppSpacing.lg,
              children: [
                _Field(context.tr('Full Name', 'الاسم الكامل'), member.fullName),
                _Field(
                    context.tr('Gender', 'الجنس'),
                    member.gender == 'F'
                        ? context.tr('Female', 'أنثى')
                        : context.tr('Male', 'ذكر')),
                _Field(context.tr('Date of Birth', 'تاريخ الميلاد'), member.dob),
                _Field(context.tr('Place of Birth', 'مكان الميلاد'),
                    member.placeOfBirth),
                _Field(context.tr('Contact Number', 'رقم الهاتف'),
                    member.contactNumber),
                _Field(context.tr('Address', 'العنوان'), member.address),
                _Field(context.tr('Civil Status', 'الحالة الاجتماعية'),
                    member.civilStatusEnum.label(isArabic)),
                _Field(context.tr('Email', 'البريد الإلكتروني'), member.email),
                _Field(context.tr('Ethnicity / Tribe', 'العرق / القبيلة'),
                    member.ethnicity),
                _Field(context.tr('Occupation', 'المهنة'), member.occupation),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 2. Educational Background.
          InfoPanel(
            icon: Icons.school_outlined,
            title: context.tr('Educational Background', 'المؤهلات الدراسية'),
            child: StreamBuilder<List<MemberEducationData>>(
              stream: memberRepo.watchEducation(member.id),
              builder: (context, snap) {
                final rows = snap.data ?? const <MemberEducationData>[];
                if (rows.isEmpty) return _empty(context);
                return Column(
                  children: [
                    for (var i = 0; i < rows.length; i++) ...[
                      if (i > 0) const Divider(height: AppSpacing.xl),
                      _Record(fields: [
                        _Field(context.tr('Degree / Course', 'الدرجة / التخصص'),
                            rows[i].degree.isEmpty
                                ? rows[i].program
                                : rows[i].degree),
                        _Field(
                            context.tr(
                                'School / University', 'المدرسة / الجامعة'),
                            rows[i].schoolName),
                        _Field(context.tr('Year Graduated', 'سنة التخرج'),
                            rows[i].yearGraduated),
                      ]),
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 3. Role in Organization.
          InfoPanel(
            icon: Icons.badge_outlined,
            title: context.tr('Role in Organization', 'الدور في المنظمة'),
            child: StreamBuilder<List<MemberRole>>(
              stream: memberRepo.watchRoles(member.id),
              builder: (context, snap) {
                final roles = snap.data ?? const <MemberRole>[];
                if (roles.isEmpty) return _empty(context);
                return Column(
                  children: [
                    for (var i = 0; i < roles.length; i++) ...[
                      if (i > 0) const Divider(height: AppSpacing.xl),
                      _Record(fields: [
                        _Field(context.tr('Current Position', 'المنصب الحالي'),
                            roles[i].positionTitle),
                        _Field(context.tr('Department', 'القسم'),
                            roles[i].department),
                        _Field(context.tr('Term / Period', 'الفترة'),
                            _term(roles[i])),
                      ]),
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  String _term(MemberRole r) {
    if (r.startDate.isEmpty && r.endDate.isEmpty) return '';
    final end = r.endDate.isEmpty ? '—' : r.endDate;
    return '${r.startDate} – $end';
  }

  Widget _empty(BuildContext context) => Text(
        context.tr('No records.', 'لا توجد سجلات.'),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.textMuted),
      );
}

/// A labelled value cell (label above the value); empty values show an em dash.
class _Field extends StatelessWidget {
  const _Field(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(value.trim().isEmpty ? '—' : value,
              style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

/// A single record (e.g. one degree or one role) as a wrap of [_Field]s.
class _Record extends StatelessWidget {
  const _Record({required this.fields});
  final List<Widget> fields;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xl,
      runSpacing: AppSpacing.lg,
      children: fields,
    );
  }
}
