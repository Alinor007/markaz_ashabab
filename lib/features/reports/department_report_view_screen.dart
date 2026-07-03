import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/gallery_repository.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/repositories/report_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/document/document_view.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import 'report_form_dialog.dart';

/// Read-only view of a single Department Report (Program Completion, Form P-2),
/// presented as a formal archival dossier.
class DepartmentReportViewScreen extends StatelessWidget {
  const DepartmentReportViewScreen({
    super.key,
    required this.departmentId,
    required this.reportId,
  });

  final String departmentId;
  final String reportId;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ReportRepository>();
    return FutureBuilder<Report?>(
      future: repo.getById(reportId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
              padding: EdgeInsets.all(AppSpacing.xxl), child: LoadingState());
        }
        final report = snap.data;
        if (report == null) {
          return EmptyState(
            icon: Icons.description_outlined,
            title: context.tr('Report not found', 'التقرير غير موجود'),
          );
        }
        return _Body(departmentId: departmentId, report: report);
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.departmentId, required this.report});
  final String departmentId;
  final Report report;

  bool get _memberBased =>
      report.departmentId == 'human_capital' || report.departmentId == 'dawah';

  (String, Color) _statusChip(BuildContext context, String code) =>
      switch (code) {
        'achieved' => (context.tr('Achieved', 'تحقق'), AppColors.emerald),
        'partial' => (
            context.tr('Partially Achieved', 'تحقق جزئيًا'),
            AppColors.goldDeep
          ),
        'not' => (context.tr('Not Achieved', 'لم يتحقق'), AppColors.error),
        _ => (code, AppColors.textMuted),
      };

  (String, Color) _flowChip(BuildContext context, String code) =>
      switch (code) {
        'best' => (context.tr('Best', 'ممتاز'), AppColors.emerald),
        'good' => (context.tr('Good', 'جيد'), AppColors.navy),
        'needs' => (
            context.tr('Needs Improvement', 'يحتاج إلى تحسين'),
            AppColors.goldDeep
          ),
        _ => (code, AppColors.textMuted),
      };

  @override
  Widget build(BuildContext context) {
    final raw = report.formData;
    final r = raw.isNotEmpty
        ? ProgramReport.fromJson(jsonDecode(raw) as Map<String, dynamic>)
        : ProgramReport(
            programTitle: report.title,
            briefDescription: report.summary,
            dateConducted: report.date);
    final variance = (double.tryParse(r.approvedBudget) ?? 0) -
        (double.tryParse(r.actualExpenses) ?? 0);
    final (statusLabel, statusColor) = _statusChip(context, r.objectiveStatus);
    final (flowLabel, flowColor) = _flowChip(context, r.eventFlow);

    // Build the ordered list of section blocks (so they can be staggered).
    final sections = <Widget>[
      DocSection(
        letter: 'B',
        title: context.tr('Objectives Review', 'مراجعة الأهداف'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DocProse(r.objective, label: context.tr('Objective', 'الهدف')),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Text('${context.tr('Status', 'الحالة')}:  ',
                    style: Theme.of(context).textTheme.labelMedium),
                DocStatusPill(label: statusLabel, color: statusColor),
              ],
            ),
            if (r.remarks.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              DocBullets(items: r.remarks),
            ],
          ],
        ),
      ),
      DocSection(
        letter: 'C',
        title:
            context.tr('Program Implementation Summary', 'ملخص تنفيذ البرنامج'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DocProse(r.briefDescription,
                label: context.tr('Brief description of what actually happened',
                    'وصف موجز لما حدث فعليًا')),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Text('${context.tr('Flow of the Event', 'سير الفعالية')}:  ',
                    style: Theme.of(context).textTheme.labelMedium),
                DocStatusPill(label: flowLabel, color: flowColor),
              ],
            ),
            if (r.keyActivities.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(context.tr('Key Activities Conducted', 'الأنشطة الرئيسية'),
                  style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              DocBullets(items: r.keyActivities),
            ],
          ],
        ),
      ),
      if (_memberBased)
        DocSection(
          letter: 'D',
          title: context.tr('Participation Data', 'بيانات المشاركة'),
          child: _Participation(report: r),
        ),
      DocSection(
        letter: 'E',
        title: context.tr(
            'Resource Utilization — Budget', 'استخدام الموارد — الميزانية'),
        child: Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            DocMetric(
                value: r.approvedBudget,
                caption: context.tr('Approved Budget', 'الميزانية المعتمدة'),
                accent: AppColors.navy),
            DocMetric(
                value: r.actualExpenses,
                caption: context.tr('Actual Expenses', 'المصروفات الفعلية'),
                accent: AppColors.goldDeep),
            DocMetric(
                value: variance.toStringAsFixed(2),
                caption:
                    context.tr('Variance', 'الفرق'),
                accent: variance < 0 ? AppColors.error : AppColors.emerald),
          ],
        ),
      ),
      DocSection(
        letter: 'F',
        title: context.tr('Outputs & Results', 'المخرجات والنتائج'),
        child: r.outputs.isEmpty
            ? _empty(context)
            : DocBullets(items: r.outputs),
      ),
      DocSection(
        letter: 'G',
        title: context.tr('Challenges Encountered', 'التحديات المواجهة'),
        child: r.challenges.isEmpty
            ? _empty(context)
            : DocBullets(items: r.challenges),
      ),
      DocSection(
        letter: 'H',
        title: context.tr('Solutions Applied', 'الحلول المطبقة'),
        child: r.solutions.isEmpty
            ? _empty(context)
            : DocBullets(items: r.solutions),
      ),
      DocSection(
        letter: 'I',
        title: context.tr('Photos', 'الصور'),
        child: _Photos(reportId: report.id),
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BackLink(departmentId: departmentId),
          const SizedBox(height: AppSpacing.md),
          DocReveal(
            child: DocMasthead(
              formCode: 'P-2',
              eyebrowEn: 'Program Completion Report',
              eyebrowAr: 'تقرير إنجاز برنامج',
              title: r.programTitle.isEmpty ? report.title : r.programTitle,
              accent: AppColors.goldDeep,
              meta: [
                DocMeta(Icons.apartment_outlined,
                    context.tr('Lead Office', 'المكتب الرئيسي'), r.leadOffice),
                DocMeta(Icons.event_outlined,
                    context.tr('Date Conducted', 'تاريخ التنفيذ'),
                    r.dateConducted),
                DocMeta(Icons.place_outlined,
                    context.tr('Venue', 'المكان'), r.venue),
                DocMeta(Icons.person_outline,
                    context.tr('Program Head', 'رئيس البرنامج'), r.programHead),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var i = 0; i < sections.length; i++) ...[
            DocReveal(delayMs: 70 * (i + 1), child: sections[i]),
            const SizedBox(height: AppSpacing.lg),
          ],
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context) => Text(
        context.tr('None.', 'لا يوجد.'),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.textMuted),
      );
}

/// The back link to the owning department.
class _BackLink extends StatelessWidget {
  const _BackLink({required this.departmentId});
  final String departmentId;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return InkWell(
      onTap: () => context.canPop()
          ? context.pop()
          : context.go('/departments/$departmentId'),
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
    );
  }
}

/// Participation block: Target & Actual metrics, plus the resolved participant
/// members.
class _Participation extends StatelessWidget {
  const _Participation({required this.report});
  final ProgramReport report;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final memberRepo = context.read<MemberRepository>();
    // Participant names are only tappable (→ Member Profile) for Admin /
    // Executive roles; everyone else sees plain, non-navigable text.
    final canNavigate =
        context.read<SessionController>().role?.isExecutive ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            DocMetric(
                value: report.targetParticipants,
                caption:
                    context.tr('Target Participants', 'المشاركون المستهدفون'),
                accent: AppColors.navy),
            DocMetric(
                value: '${report.participantIds.length}',
                caption:
                    context.tr('Actual Participants', 'المشاركون الفعليون'),
                accent: AppColors.emerald),
          ],
        ),
        if (report.participantIds.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          FutureBuilder<List<Member>>(
            future: _resolve(memberRepo, report.participantIds),
            builder: (context, snap) {
              final members = snap.data ?? const <Member>[];
              if (members.isEmpty) return const SizedBox.shrink();
              return Column(
                children: [
                  for (final m in members)
                    _ParticipantRow(
                        member: m, isArabic: isArabic, canNavigate: canNavigate),
                ],
              );
            },
          ),
        ],
      ],
    );
  }

  Future<List<Member>> _resolve(MemberRepository repo, List<String> ids) async {
    final out = <Member>[];
    for (final id in ids) {
      final m = await repo.getMember(id);
      if (m != null) out.add(m);
    }
    return out;
  }
}

/// A single participant row. Tappable (→ that member's profile, pushed onto
/// the stack) only when [canNavigate] — Admin / Executive roles; otherwise
/// rendered as plain, non-interactive text.
class _ParticipantRow extends StatelessWidget {
  const _ParticipantRow({
    required this.member,
    required this.isArabic,
    required this.canNavigate,
  });
  final Member member;
  final bool isArabic;
  final bool canNavigate;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        PortraitAvatar(
            initials: member.initials,
            imagePath: member.photoPath,
            size: 36,
            ring: false),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            member.displayName(isArabic),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: canNavigate ? AppColors.emerald : null,
                  decoration:
                      canNavigate ? TextDecoration.underline : null,
                  decorationColor: AppColors.emerald,
                ),
          ),
        ),
        if (canNavigate)
          const Icon(Icons.chevron_right, size: 18, color: AppColors.textFaint),
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: canNavigate
          ? InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: () => context.push('/tarbiya/member/${member.id}'),
              child: row,
            )
          : row,
    );
  }
}

/// Photo album grid for the report (from the linked Gallery album).
class _Photos extends StatelessWidget {
  const _Photos({required this.reportId});
  final String reportId;

  @override
  Widget build(BuildContext context) {
    final galleryRepo = context.read<GalleryRepository>();
    return StreamBuilder<GalleryPhoto?>(
      stream: galleryRepo.watchForReport(reportId),
      builder: (context, snap) {
        final album = snap.data;
        final paths =
            album == null ? const <String>[] : GalleryRepository.imagesOf(album);
        if (paths.isEmpty) {
          return Text(
            context.tr('No photos uploaded.', 'لم يتم رفع صور.'),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textMuted),
          );
        }
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final path in paths)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Image.file(File(path),
                    width: 120, height: 120, fit: BoxFit.cover),
              ),
          ],
        );
      },
    );
  }
}
