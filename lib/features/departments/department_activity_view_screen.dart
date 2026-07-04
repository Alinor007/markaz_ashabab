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
            title: 'Activity not found',
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
        title: 'Basic Information',
        child: Wrap(
          spacing: AppSpacing.xl,
          runSpacing: AppSpacing.lg,
          children: [
            DocField('Program Title',
                p.programTitle),
            DocField('Proposed Date',
                p.proposedDate),
            DocField('Venue / Location', p.venue),
            DocField('Target Participants',
                p.targetParticipants),
            DocField(
                'Expected Number of Participants',
                p.expectedParticipants),
          ],
        ),
      ),
      DocSection(
        letter: 'B',
        title: 'Objectives',
        child: p.objectives.isEmpty
            ? _empty(context)
            : DocBullets(items: p.objectives),
      ),
      DocSection(
        letter: 'H',
        title: 'Expected',
        child: Wrap(
          spacing: AppSpacing.xl,
          runSpacing: AppSpacing.lg,
          children: [
            DocField(
                'Output (Short-term results)',
                p.output),
            DocField(
                'Outcome (Long-term impact / Changes)',
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
                    'Proposed Date',
                    p.proposedDate),
                DocMeta(Icons.place_outlined,
                    'Venue', p.venue),
                DocMeta(Icons.groups_outlined,
                    'Target', p.targetParticipants),
                DocMeta(Icons.tag_outlined,
                    'Expected', p.expectedParticipants),
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
        'None.',
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
            Text('Back',
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
