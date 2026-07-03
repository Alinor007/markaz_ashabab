import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/department_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/document/document_view.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/loading_state.dart';
import 'department_activity_dialog.dart';

/// Read-only view of a single Department Activity (Program Proposal, Form P-1),
/// presented as a formal archival dossier. Shows the kept sections only:
/// A. Basic Information, B. Objectives, and H. Expected.
class DepartmentActivityViewScreen extends StatelessWidget {
  const DepartmentActivityViewScreen({
    super.key,
    required this.departmentId,
    required this.activityId,
  });

  final String departmentId;
  final String activityId;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<DepartmentRepository>();
    return StreamBuilder<DeptActivity?>(
      stream: repo.watchActivity(activityId),
      builder: (context, snap) {
        if (!snap.hasData && snap.connectionState == ConnectionState.waiting) {
          return const Padding(
              padding: EdgeInsets.all(AppSpacing.xxl), child: LoadingState());
        }
        final activity = snap.data;
        if (activity == null) {
          return EmptyState(
            icon: Icons.event_busy_outlined,
            title: context.tr('Activity not found', 'النشاط غير موجود'),
          );
        }
        return _Body(departmentId: departmentId, activity: activity);
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.departmentId, required this.activity});
  final String departmentId;
  final DeptActivity activity;

  @override
  Widget build(BuildContext context) {
    final raw = activity.formData;
    final p = raw.isNotEmpty
        ? ProgramProposal.fromJson(jsonDecode(raw) as Map<String, dynamic>)
        : ProgramProposal(
            programTitle: activity.title, proposedDate: activity.date);

    final sections = <Widget>[
      DocSection(
        letter: 'A',
        title: context.tr('Basic Information', 'المعلومات الأساسية'),
        child: Wrap(
          spacing: AppSpacing.xl,
          runSpacing: AppSpacing.lg,
          children: [
            DocField(context.tr('Program Title', 'عنوان البرنامج'),
                p.programTitle),
            DocField(context.tr('Proposed Date', 'التاريخ المقترح'),
                p.proposedDate),
            DocField(context.tr('Venue / Location', 'المكان / الموقع'), p.venue),
            DocField(context.tr('Target Participants', 'المشاركون المستهدفون'),
                p.targetParticipants),
            DocField(
                context.tr('Expected Number of Participants',
                    'العدد المتوقع للمشاركين'),
                p.expectedParticipants),
          ],
        ),
      ),
      DocSection(
        letter: 'B',
        title: context.tr('Objectives', 'الأهداف'),
        child: p.objectives.isEmpty
            ? _empty(context)
            : DocBullets(items: p.objectives),
      ),
      DocSection(
        letter: 'H',
        title: context.tr('Expected', 'المتوقع'),
        child: Wrap(
          spacing: AppSpacing.xl,
          runSpacing: AppSpacing.lg,
          children: [
            DocField(
                context.tr('Output (Short-term results)',
                    'المخرجات (نتائج قصيرة المدى)'),
                p.output),
            DocField(
                context.tr('Outcome (Long-term impact / Changes)',
                    'النتائج (أثر طويل المدى / تغييرات)'),
                p.outcome),
          ],
        ),
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
              formCode: 'P-1',
              eyebrowEn: 'Program Proposal',
              eyebrowAr: 'مقترح برنامج',
              title: p.programTitle.isEmpty ? activity.title : p.programTitle,
              accent: AppColors.emerald,
              meta: [
                DocMeta(Icons.event_outlined,
                    context.tr('Proposed Date', 'التاريخ المقترح'),
                    p.proposedDate),
                DocMeta(Icons.place_outlined,
                    context.tr('Venue', 'المكان'), p.venue),
                DocMeta(Icons.groups_outlined,
                    context.tr('Target', 'المستهدف'), p.targetParticipants),
                DocMeta(Icons.tag_outlined,
                    context.tr('Expected', 'المتوقع'), p.expectedParticipants),
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
