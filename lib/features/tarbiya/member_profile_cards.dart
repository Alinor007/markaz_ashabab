import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/repositories/report_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/util/validators.dart';
import '../../widgets/common/info_panel.dart';
import '../../widgets/common/portrait_avatar.dart';
import '../../widgets/common/search_field.dart';
import '../reports/report_form_dialog.dart' show ProgramReport;
import 'widgets/confirm_dialog.dart';

// ════════════════════════════ shared helpers ════════════════════════════

class _KvRows extends StatelessWidget {
  const _KvRows(this.rows);
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    return Column(
      children: [
        for (final (label, value) in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 150,
                    child: Text(label, style: theme.textTheme.labelMedium)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    value.isEmpty ? '—' : value,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.charcoal),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// "Add" action button shown in a card header area.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add, size: 18),
        label: Text(label),
      ),
    );
  }
}

void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
  );
}

Future<String?> _pickDate(BuildContext context, String current) async {
  final now = DateTime.now();
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime.tryParse(current) ?? now,
    firstDate: DateTime(1990),
    lastDate: DateTime(now.year + 2),
  );
  return picked?.toIso8601String().split('T').first;
}

/// Date picker constrained to a single [year]/[month] — used for a monthly
/// donation so its date can only fall within the month it belongs to. The
/// month and year are effectively locked because the first and last selectable
/// dates are both inside that month.
Future<String?> _pickMonthDate(
    BuildContext context, int year, int month, String current) async {
  final first = DateTime(year, month, 1);
  final last = DateTime(year, month + 1, 0); // day 0 of next month = last day
  final parsed = DateTime.tryParse(current);
  final initial =
      (parsed != null && !parsed.isBefore(first) && !parsed.isAfter(last))
          ? parsed
          : first;
  final picked = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: first,
    lastDate: last,
  );
  return picked?.toIso8601String().split('T').first;
}

// ════════════════════════════ Personal ════════════════════════════

class PersonalInfoCard extends StatelessWidget {
  const PersonalInfoCard({super.key, required this.member});
  final Member member;

  @override
  Widget build(BuildContext context) {
    return InfoPanel(
      icon: Icons.person_outline,
      title: 'Personal Information',
      child: _KvRows([
        ('Full Name', member.fullName),
        ('Gender',
            member.gender == 'M'
                ? 'Male'
                : 'Female'),
        ('Date of Birth', member.dob),
        ('Place of Birth', member.placeOfBirth),
        ('Contact Number', member.contactNumber),
        ('Email', member.email),
        ('Address', member.address),
        ('Civil Status',
            member.civilStatusEnum.label(context.isArabic)),
        ('Ethnicity / Tribe', member.ethnicity),
        ('Occupation', member.occupation),
      ]),
    );
  }
}

// ════════════════════════════ Family & Children ════════════════════════════

class FamilyChildrenCard extends StatelessWidget {
  const FamilyChildrenCard({super.key, required this.member});
  final Member member;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MemberRepository>();
    final single = member.civilStatusEnum == CivilStatus.single;
    return InfoPanel(
      icon: Icons.family_restroom_outlined,
      title: 'Family Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (single)
            Text('Single',
                style: Theme.of(context).textTheme.bodyMedium),
          // Spouses (1 for a female, up to 4 for a male) — stored in the
          // MemberWives table for all genders.
          if (!single)
            StreamBuilder<List<MemberWife>>(
              stream: repo.watchWives(member.id),
              builder: (context, snap) {
                final spouses = snap.data ?? const <MemberWife>[];
                // Back-compat: fall back to the legacy denormalized spouse for
                // older records that predate the unified store.
                final entries = spouses.isNotEmpty
                    ? [
                        for (final s in spouses)
                          (s.name, s.marriageDate),
                      ]
                    : (member.spouseName.trim().isNotEmpty
                        ? [(member.spouseName, member.spouseDate)]
                        : const <(String, String)>[]);
                final isMale = member.gender == 'M';
                final heading = isMale
                    ? 'Spouse'
                    : 'Spouse';
                if (entries.isEmpty) {
                  return Text(
                      'No spouse recorded',
                      style: Theme.of(context).textTheme.bodySmall);
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(heading,
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.sm),
                    for (final (name, date) in entries)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: Text(
                          date.isEmpty ? name : '$name — $date',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                  ],
                );
              },
            ),
          const SizedBox(height: AppSpacing.md),
          Text('Children',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          StreamBuilder<List<MemberChildrenData>>(
            stream: repo.watchChildren(member.id),
            builder: (context, snap) {
              final children = snap.data ?? const [];
              if (children.isEmpty) {
                return Text('No children recorded',
                    style: Theme.of(context).textTheme.bodySmall);
              }
              return Column(
                children: [
                  for (final c in children)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        children: [
                          const Icon(Icons.child_care_outlined,
                              size: 16, color: AppColors.emerald),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(child: Text(c.name)),
                          Text(c.dob,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════ Education ════════════════════════════

class EducationCard extends StatelessWidget {
  const EducationCard({super.key, required this.member});
  final Member member;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MemberRepository>();
    return InfoPanel(
      icon: Icons.school_outlined,
      title: 'Educational Background',
      child: StreamBuilder<List<MemberEducationData>>(
        stream: repo.watchEducation(member.id),
        builder: (context, snap) {
          final records = snap.data ?? const [];
          if (records.isEmpty) {
            return Text('No records',
                style: Theme.of(context).textTheme.bodySmall);
          }
          return Column(
            children: [
              for (final e in records)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          EducationStage.fromCode(e.stage)
                              .label(context.isArabic),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.schoolName,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.charcoal)),
                            if (e.degree.isNotEmpty || e.program.isNotEmpty ||
                                e.yearGraduated.isNotEmpty)
                              Text(
                                [e.degree, e.program, e.yearGraduated]
                                    .where((s) => s.isNotEmpty)
                                    .join(' · '),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ════════════════════════════ Naqib-Usra ════════════════════════════

class NaqibUsraCard extends StatelessWidget {
  const NaqibUsraCard({super.key, required this.member});
  final Member member;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MemberRepository>();
    return InfoPanel(
      icon: Icons.groups_2_outlined,
      title: 'Naqib-Usra Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _KvRows([
            ('Name of Usra', member.usraName),
            ('Established Year',
                member.usraEstablishedYear),
            ('Meeting Schedule',
                member.usraMeetingSchedule),
          ]),
          const SizedBox(height: AppSpacing.md),
          Text('Naqib',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          // ── Navigatable Naqib ──────────────────────────────────────
          FutureBuilder<Member?>(
            future: member.naqibMemberId == null
                ? Future.value(null)
                : repo.getMember(member.naqibMemberId!),
            builder: (context, snap) {
              final naqib = snap.data;
              if (naqib == null) {
                return Text(
                  'Not assigned',
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }
              return InkWell(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                onTap: () => context.go('/tarbiya/member/${naqib.id}'),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, AppSpacing.md, 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PortraitAvatar(
                          initials: naqib.initials, size: 28, ring: false),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        naqib.displayName(context.isArabic),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.emerald,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.emerald,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // ──────────────────────────────────────────────────────────
          const SizedBox(height: AppSpacing.md),
          Text('Students',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          StreamBuilder<List<Member>>(
            stream: repo.watchUsraMembers(member.id),
            builder: (context, snap) {
              final members = snap.data ?? const [];
              if (members.isEmpty) {
                return Text(
                    'No other students',
                    style: Theme.of(context).textTheme.bodySmall);
              }
              return Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final m in members)
                    _UsraMemberChip(member: m),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _UsraMemberChip extends StatelessWidget {
  const _UsraMemberChip({required this.member});
  final Member member;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: () => context.go('/tarbiya/member/${member.id}'),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, AppSpacing.md, 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PortraitAvatar(
                  initials: member.initials, size: 28, ring: false),
              const SizedBox(width: AppSpacing.sm),
              Text(member.displayName(context.isArabic),
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════ Tas'ed ════════════════════════════

class TasedCard extends StatelessWidget {
  const TasedCard({super.key, required this.member, required this.canManage});
  final Member member;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MemberRepository>();
    return InfoPanel(
      icon: Icons.grading_outlined,
      title: "Promotion Information",
      child: StreamBuilder<List<MemberTasedData>>(
        stream: repo.watchTased(member.id),
        builder: (context, snap) {
          final records = snap.data ?? const [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tableHeader(context, [
                'Level',
                'Year',
                'Status',
                '',
              ]),
              if (records.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Text('No records',
                      style: Theme.of(context).textTheme.bodySmall),
                ),
              for (final r in records)
                _TasedRow(
                  record: r,
                  canManage: canManage,
                  onEdit: () => _showTasedDialog(context, repo, member, r),
                  onDelete: () async {
                    final ok = await confirmDialog(context,
                        title: 'Delete record?',
                        message: 'Remove this tas\'ed record.');
                    if (ok) await repo.deleteTased(r.id);
                  },
                ),
              if (canManage)
                _AddButton(
                  label: 'Add Record',
                  onTap: () => _showTasedDialog(context, repo, member, null),
                ),
            ],
          );
        },
      ),
    );
  }
}

Widget _tableHeader(BuildContext context, List<String> cols) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
    child: Row(
      children: [
        for (final c in cols)
          Expanded(
            child: Text(c,
                style: Theme.of(context).textTheme.labelSmall),
          ),
      ],
    ),
  );
}

class _TasedRow extends StatelessWidget {
  const _TasedRow({
    required this.record,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });
  final MemberTasedData record;
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final active = record.status == 'active';
    final color = active ? AppColors.emerald : AppColors.textFaint;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(context.tr('Level ${record.level}'))),
          Expanded(child: Text(record.year.isEmpty ? '—' : record.year)),
          Expanded(
            child: Text(
              active ? 'Active' : 'Inactive',
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: canManage
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.delete_outline,
                            size: 18, color: AppColors.error),
                        onPressed: onDelete,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

Future<void> _showTasedDialog(BuildContext context, MemberRepository repo,
    Member member, MemberTasedData? existing) async {
  int level = existing?.level ?? 1;
  final yearCtrl = TextEditingController(text: existing?.year ?? '');
  String status = existing?.status ?? 'inactive';
  final formKey = GlobalKey<FormState>();
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(existing == null
            ? 'Add Tas\'ed Record'
            : 'Edit Tas\'ed Record'),
        content: SizedBox(
          width: 360,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: level,
                    decoration: InputDecoration(
                        labelText: 'Level'),
                    items: [
                      for (final l in kTarbiyaLevels)
                        DropdownMenuItem(value: l, child: Text('Level $l')),
                    ],
                    onChanged: (v) => level = v ?? level,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: yearCtrl,
                    keyboardType: TextInputType.number,
                    validator: (v) => Validators.optionalYear(context, v),
                    decoration:
                        InputDecoration(labelText: 'Year'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: status,
                    decoration: InputDecoration(
                        labelText: 'Status'),
                    items: [
                      DropdownMenuItem(
                          value: 'active',
                          child: Text('Active')),
                      DropdownMenuItem(
                          value: 'inactive',
                          child: Text('Inactive')),
                    ],
                    onChanged: (v) => status = v ?? status,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel')),
          FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(context, true);
              },
              child: Text('Save')),
        ],
      ),
    ),
  );
  if (result == true) {
    if (existing == null) {
      await repo.addTased(
          memberId: member.id, level: level, year: yearCtrl.text.trim(), status: status);
    } else {
      await repo.updateTased(existing.id,
          level: level, year: yearCtrl.text.trim(), status: status);
    }
  }
  yearCtrl.dispose();
}

// ════════════════════════════ Donation Monitoring ════════════════════════════

class DonationCard extends StatefulWidget {
  const DonationCard({super.key, required this.member, required this.canManage});
  final Member member;
  final bool canManage;

  @override
  State<DonationCard> createState() => _DonationCardState();
}

class _DonationCardState extends State<DonationCard> {
  late int _year = DateTime.now().year;

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _monthsAr = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MemberRepository>();
    final isArabic = context.isArabic;
    return InfoPanel(
      icon: Icons.savings_outlined,
      title: 'Donation Monitoring',
      child: StreamBuilder<List<MemberDonation>>(
        stream: repo.watchDonations(widget.member.id, _year),
        builder: (context, snap) {
          final byMonth = {for (final d in snap.data ?? const []) d.month: d};
          final donatedCount = byMonth.values.where((d) => d.donated).length;
          final total = byMonth.values
              .where((d) => d.donated)
              .fold<double>(0, (s, d) => s + d.amount);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => setState(() => _year--),
                  ),
                  Text('$_year',
                      style: Theme.of(context).textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => setState(() => _year++),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (var m = 1; m <= 12; m++)
                    _MonthTile(
                      label: (isArabic ? _monthsAr : _months)[m - 1],
                      donation: byMonth[m],
                      onTap: widget.canManage
                          ? () => _editMonth(context, repo, m, byMonth[m])
                          : null,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.sm,
                children: [
                  _summary(context, 'Total Donations',
                      total.toStringAsFixed(0)),
                  _summary(context, 'Months Contributed',
                      '$donatedCount'),
                  _summary(context, 'Missing Months',
                      '${12 - donatedCount}'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _summary(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColors.emerald)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Future<void> _editMonth(BuildContext context, MemberRepository repo, int month,
      MemberDonation? existing) async {
    bool donated = existing?.donated ?? false;
    final amountCtrl =
        TextEditingController(text: existing?.amount.toStringAsFixed(0) ?? '');
    final notesCtrl = TextEditingController(text: existing?.notes ?? '');
    String date = existing?.date ?? '';
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          scrollable: true,
          backgroundColor: AppColors.surface,
          title: Text(
              '${(context.isArabic ? _monthsAr : _months)[month - 1]} $_year'),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Donated'),
                  value: donated,
                  activeTrackColor: AppColors.emerald,
                  onChanged: (v) => setLocal(() => donated = v),
                ),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Amount'),
                ),
                const SizedBox(height: AppSpacing.md),
                InkWell(
                  onTap: () async {
                    final picked =
                        await _pickMonthDate(context, _year, month, date);
                    if (picked != null) setLocal(() => date = picked);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date of Donation',
                      suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                    ),
                    child: Text(date.isEmpty ? '—' : date),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: notesCtrl,
                  decoration:
                      InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Save')),
          ],
        ),
      ),
    );
    if (result == true) {
      await repo.setDonation(
        memberId: widget.member.id,
        year: _year,
        month: month,
        donated: donated,
        date: date,
        amount: double.tryParse(amountCtrl.text.trim()) ?? 0,
        notes: notesCtrl.text.trim(),
      );
    }
    amountCtrl.dispose();
    notesCtrl.dispose();
  }
}

class _MonthTile extends StatelessWidget {
  const _MonthTile({required this.label, required this.donation, this.onTap});
  final String label;
  final MemberDonation? donation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final donated = donation?.donated ?? false;
    final color = donated ? AppColors.emerald : AppColors.border;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        width: 96,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: donated ? AppColors.emeraldTint : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: color),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(donated ? Icons.check_circle : Icons.circle_outlined,
                    size: 14,
                    color: donated ? AppColors.emerald : AppColors.textFaint),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(label.substring(0, label.length >= 3 ? 3 : label.length),
                      style: Theme.of(context).textTheme.labelMedium),
                ),
              ],
            ),
            if (donated && (donation?.amount ?? 0) > 0)
              Text(donation!.amount.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════ Activity History ════════════════════════════

class ActivityHistoryCard extends StatefulWidget {
  const ActivityHistoryCard(
      {super.key, required this.member, required this.canManage});
  final Member member;
  final bool canManage;

  @override
  State<ActivityHistoryCard> createState() => _ActivityHistoryCardState();
}

/// A unified, sortable/searchable Activity History row: either a manually
/// added [MemberActivity] or an auto-populated entry (see [_ParticipatedReportRow]).
typedef _HistoryRow = ({String date, String search, Widget widget});

/// If [report] is from a participant-tracked department (Da'wah, Human
/// Capital) and lists [memberId] in its Participation Data, returns the
/// decoded payload; otherwise null.
ProgramReport? _participationOf(Report report, String memberId) {
  if (report.formData.trim().isEmpty) return null;
  final data =
      ProgramReport.fromJson(jsonDecode(report.formData) as Map<String, dynamic>);
  return data.participantIds.contains(memberId) ? data : null;
}

class _ActivityHistoryCardState extends State<ActivityHistoryCard> {
  String _query = '';
  int _page = 0;
  static const _pageSize = 5;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MemberRepository>();
    final reportRepo = context.read<ReportRepository>();
    final isArabic = context.isArabic;
    return InfoPanel(
      icon: Icons.timeline_outlined,
      title: 'Activity History',
      child: StreamBuilder<List<MemberActivity>>(
        stream: repo.watchActivities(widget.member.id),
        builder: (context, activitySnap) {
          final manual = activitySnap.data ?? const <MemberActivity>[];
          return StreamBuilder<List<Report>>(
            stream: reportRepo.watchParticipantTrackedReports(),
            builder: (context, reportSnap) {
              final trackedReports = reportSnap.data ?? const <Report>[];

              final rows = <_HistoryRow>[
                for (final a in manual)
                  (
                    date: a.date,
                    search: '${a.name} ${a.type}'.toLowerCase(),
                    widget: _ActivityRow(
                      activity: a,
                      canManage: widget.canManage,
                      onDelete: () async {
                        final ok = await confirmDialog(context,
                            title: 'Delete activity?',
                            message: a.name);
                        if (ok) await repo.deleteActivity(a.id);
                      },
                    ),
                  ),
              ];
              // Auto-populated: reports where this member appears as a
              // Da'wah / Human Capital participant — passive, no manual entry.
              for (final r in trackedReports) {
                final data = _participationOf(r, widget.member.id);
                if (data == null) continue;
                final title = data.programTitle.isEmpty ? r.title : data.programTitle;
                rows.add((
                  date: r.date,
                  search: title.toLowerCase(),
                  widget: _ParticipatedReportRow(
                    title: title,
                    departmentId: r.departmentId,
                    date: r.date,
                    isArabic: isArabic,
                    onTap: () => context
                        .push('/departments/${r.departmentId}/reports/${r.id}'),
                  ),
                ));
              }
              rows.sort((x, y) => y.date.compareTo(x.date));

              final filtered = _query.isEmpty
                  ? rows
                  : rows
                      .where((r) => r.search.contains(_query.toLowerCase()))
                      .toList();
              final pages = (filtered.length / _pageSize).ceil().clamp(1, 9999);
              if (_page >= pages) _page = pages - 1;
              final start = _page * _pageSize;
              final pageItems = filtered.skip(start).take(_pageSize).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchField(
                          hint: 'Search activities…',
                          onChanged: (v) => setState(() {
                            _query = v;
                            _page = 0;
                          }),
                        ),
                      ),
                      if (widget.canManage) ...[
                        const SizedBox(width: AppSpacing.sm),
                        IconButton.filled(
                          style: IconButton.styleFrom(
                              backgroundColor: AppColors.emerald),
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () =>
                              _showActivityDialog(context, repo, widget.member),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (pageItems.isEmpty)
                    Text('No activities',
                        style: Theme.of(context).textTheme.bodySmall)
                  else
                    for (final row in pageItems) row.widget,
                  if (pages > 1) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed:
                              _page > 0 ? () => setState(() => _page--) : null,
                        ),
                        Text('${_page + 1} / $pages',
                            style: Theme.of(context).textTheme.bodySmall),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _page < pages - 1
                              ? () => setState(() => _page++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// An auto-populated Activity History row for a Da'wah / Human Capital report
/// this member participated in — passive (no manual entry, not deletable
/// here) and tappable to the report's Department Report View Screen.
class _ParticipatedReportRow extends StatelessWidget {
  const _ParticipatedReportRow({
    required this.title,
    required this.departmentId,
    required this.date,
    required this.isArabic,
    required this.onTap,
  });
  final String title;
  final String departmentId;
  final String date;
  final bool isArabic;
  final VoidCallback onTap;

  /// A short label for the two participant-tracking departments — avoids a
  /// repository round-trip just to show a subtitle.
  (String, String) get _deptLabel => switch (departmentId) {
        'dawah' => ('Da‘wah', 'الدعوة'),
        'human_capital' => (
            'Human Capital (Tarbiya)',
            'رأس المال البشري (التربية)'
          ),
        _ => (departmentId, departmentId),
      };

  @override
  Widget build(BuildContext context) {
    final (en, ar) = _deptLabel;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(top: 1),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.emeraldTint,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(Icons.description_outlined,
                  size: 16, color: AppColors.emerald),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.emerald,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.emerald,
                        ),
                  ),
                  Text(
                    [isArabic ? ar : en, date]
                        .where((s) => s.isNotEmpty)
                        .join(' · '),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.textFaint),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow(
      {required this.activity, required this.canManage, required this.onDelete});
  final MemberActivity activity;
  final bool canManage;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final present = activity.attendanceStatus == 'present';
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.name,
                    style: Theme.of(context).textTheme.titleSmall),
                Text(
                  [activity.type, activity.date]
                      .where((s) => s.isNotEmpty)
                      .join(' · '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (activity.remarks.isNotEmpty)
                  Text(activity.remarks,
                      style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: 2),
            decoration: BoxDecoration(
              color: (present ? AppColors.emerald : AppColors.error)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              present
                  ? 'Present'
                  : 'Absent',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: present ? AppColors.emerald : AppColors.error),
            ),
          ),
          if (canManage)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.delete_outline,
                  size: 18, color: AppColors.error),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}

Future<void> _showActivityDialog(
    BuildContext context, MemberRepository repo, Member member) async {
  final nameCtrl = TextEditingController();
  final typeCtrl = TextEditingController();
  final remarksCtrl = TextEditingController();
  String date = '';
  String attendance = 'present';
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setLocal) => AlertDialog(
        scrollable: true,
        backgroundColor: AppColors.surface,
        title: Text('Add Activity'),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                      labelText: 'Activity Name')),
              const SizedBox(height: AppSpacing.md),
              TextField(
                  controller: typeCtrl,
                  decoration: InputDecoration(
                      labelText: 'Activity Type')),
              const SizedBox(height: AppSpacing.md),
              InkWell(
                onTap: () async {
                  final picked = await _pickDate(context, date);
                  if (picked != null) setLocal(() => date = picked);
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    suffixIcon:
                        const Icon(Icons.calendar_today_outlined, size: 18),
                  ),
                  child: Text(date.isEmpty ? '—' : date),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: attendance,
                decoration: InputDecoration(
                    labelText: 'Attendance'),
                items: [
                  DropdownMenuItem(
                      value: 'present', child: Text('Present')),
                  DropdownMenuItem(
                      value: 'absent', child: Text('Absent')),
                ],
                onChanged: (v) => setLocal(() => attendance = v ?? attendance),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                  controller: remarksCtrl,
                  decoration: InputDecoration(
                      labelText: 'Remarks')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Save')),
        ],
      ),
    ),
  );
  if (result == true && nameCtrl.text.trim().isNotEmpty) {
    await repo.addActivity(
      memberId: member.id,
      name: nameCtrl.text.trim(),
      type: typeCtrl.text.trim(),
      date: date,
      attendanceStatus: attendance,
      remarks: remarksCtrl.text.trim(),
    );
  } else if (context.mounted && result == true) {
    _toast(context, 'Activity name is required.');
  }
  nameCtrl.dispose();
  typeCtrl.dispose();
  remarksCtrl.dispose();
}

// ════════════════════════════ Contributions ════════════════════════════

class ContributionsCard extends StatelessWidget {
  const ContributionsCard(
      {super.key, required this.member, required this.canManage});
  final Member member;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MemberRepository>();
    return InfoPanel(
      icon: Icons.handshake_outlined,
      title: "Contribution to Foundation",
      child: StreamBuilder<List<MemberContribution>>(
        stream: repo.watchContributions(member.id),
        builder: (context, snap) {
          final items = snap.data ?? const [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (items.isEmpty)
                Text('No contributions',
                    style: Theme.of(context).textTheme.bodySmall),
              for (final c in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.title,
                                style: Theme.of(context).textTheme.titleSmall),
                            if (c.description.isNotEmpty)
                              Text(c.description,
                                  style: Theme.of(context).textTheme.bodySmall),
                            if (c.date.isNotEmpty)
                              Text(c.date,
                                  style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      _statusPill(context, c.status),
                      if (canManage) ...[
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () =>
                              _showContributionDialog(context, repo, member, c),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.delete_outline,
                              size: 18, color: AppColors.error),
                          onPressed: () async {
                            final ok = await confirmDialog(context,
                                title: 'Delete contribution?',
                                message: c.title);
                            if (ok) await repo.deleteContribution(c.id);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              if (canManage)
                _AddButton(
                  label: 'Add Contribution',
                  onTap: () =>
                      _showContributionDialog(context, repo, member, null),
                ),
            ],
          );
        },
      ),
    );
  }
}

Widget _statusPill(BuildContext context, String status) {
  final active = status == 'active';
  final color = active ? AppColors.emerald : AppColors.textFaint;
  return Container(
    margin: const EdgeInsets.only(top: 2),
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.pill),
    ),
    child: Text(
      active ? 'Active' : 'Completed',
      style: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: color, fontWeight: FontWeight.w700),
    ),
  );
}

Future<void> _showContributionDialog(BuildContext context,
    MemberRepository repo, Member member, MemberContribution? existing) async {
  final titleCtrl = TextEditingController(text: existing?.title ?? '');
  final descCtrl = TextEditingController(text: existing?.description ?? '');
  String date = existing?.date ?? '';
  String status = existing?.status ?? 'active';
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setLocal) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(existing == null
            ? 'Add Contribution'
            : 'Edit Contribution'),
        content: SizedBox(
          width: 380,
          child: SingleChildScrollView(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleCtrl,
                  decoration:
                      InputDecoration(labelText: 'Title')),
              const SizedBox(height: AppSpacing.md),
              TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                      labelText: 'Description')),
              const SizedBox(height: AppSpacing.md),
              InkWell(
                onTap: () async {
                  final picked = await _pickDate(context, date);
                  if (picked != null) setLocal(() => date = picked);
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    suffixIcon:
                        const Icon(Icons.calendar_today_outlined, size: 18),
                  ),
                  child: Text(date.isEmpty ? '—' : date),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: status,
                decoration:
                    InputDecoration(labelText: 'Status'),
                items: [
                  DropdownMenuItem(
                      value: 'active', child: Text('Active')),
                  DropdownMenuItem(
                      value: 'completed',
                      child: Text('Completed')),
                ],
                onChanged: (v) => status = v ?? status,
              ),
            ],
          )),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Save')),
        ],
      ),
    ),
  );
  if (result == true && titleCtrl.text.trim().isNotEmpty) {
    if (existing == null) {
      await repo.addContribution(
          memberId: member.id,
          title: titleCtrl.text.trim(),
          description: descCtrl.text.trim(),
          date: date,
          status: status);
    } else {
      await repo.updateContribution(existing.id,
          title: titleCtrl.text.trim(),
          description: descCtrl.text.trim(),
          date: date,
          status: status);
    }
  }
  titleCtrl.dispose();
  descCtrl.dispose();
}

// ════════════════════════════ Organizational Roles ════════════════════════════

class OrgRolesCard extends StatelessWidget {
  const OrgRolesCard({super.key, required this.member, required this.canManage});
  final Member member;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MemberRepository>();
    return InfoPanel(
      icon: Icons.badge_outlined,
      title: 'Role in Fundation',
      child: StreamBuilder<List<MemberRole>>(
        stream: repo.watchRoles(member.id),
        builder: (context, snap) {
          final roles = snap.data ?? const [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (roles.isEmpty)
                Text('No roles recorded',
                    style: Theme.of(context).textTheme.bodySmall),
              for (final r in roles)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.positionTitle,
                                style: Theme.of(context).textTheme.titleSmall),
                            Text(
                              [
                                r.department,
                                [r.startDate, r.endDate]
                                    .where((s) => s.isNotEmpty)
                                    .join(' – ')
                              ].where((s) => s.isNotEmpty).join(' · '),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      _statusPill(context, r.status),
                      if (canManage) ...[
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () =>
                              _showRoleDialog(context, repo, member, r),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.delete_outline,
                              size: 18, color: AppColors.error),
                          onPressed: () async {
                            final ok = await confirmDialog(context,
                                title: 'Delete role?',
                                message: r.positionTitle);
                            if (ok) await repo.deleteRole(r.id);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              if (canManage)
                _AddButton(
                  label: 'Add Role',
                  onTap: () => _showRoleDialog(context, repo, member, null),
                ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> _showRoleDialog(BuildContext context, MemberRepository repo,
    Member member, MemberRole? existing) async {
  final titleCtrl = TextEditingController(text: existing?.positionTitle ?? '');
  final deptCtrl = TextEditingController(text: existing?.department ?? '');
  String startDate = existing?.startDate ?? '';
  String endDate = existing?.endDate ?? '';
  String status = existing?.status ?? 'active';
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setLocal) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(existing == null
            ? 'Add Role'
            : 'Edit Role'),
        content: SizedBox(
          width: 380,
          child: SingleChildScrollView(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                      labelText: 'Position Title')),
              const SizedBox(height: AppSpacing.md),
              TextField(
                  controller: deptCtrl,
                  decoration: InputDecoration(
                      labelText: 'Department')),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await _pickDate(context, startDate);
                        if (picked != null) setLocal(() => startDate = picked);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                            labelText: 'Start Date'),
                        child: Text(startDate.isEmpty ? '—' : startDate),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await _pickDate(context, endDate);
                        if (picked != null) setLocal(() => endDate = picked);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                            labelText: 'End Date'),
                        child: Text(endDate.isEmpty ? '—' : endDate),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: status,
                decoration:
                    InputDecoration(labelText: 'Status'),
                items: [
                  DropdownMenuItem(
                      value: 'active', child: Text('Active')),
                  DropdownMenuItem(
                      value: 'completed',
                      child: Text('Completed')),
                ],
                onChanged: (v) => status = v ?? status,
              ),
            ],
          )),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Save')),
        ],
      ),
    ),
  );
  if (result == true && titleCtrl.text.trim().isNotEmpty) {
    if (existing == null) {
      await repo.addRole(
          memberId: member.id,
          positionTitle: titleCtrl.text.trim(),
          department: deptCtrl.text.trim(),
          startDate: startDate,
          endDate: endDate,
          status: status);
    } else {
      await repo.updateRole(existing.id,
          positionTitle: titleCtrl.text.trim(),
          department: deptCtrl.text.trim(),
          startDate: startDate,
          endDate: endDate,
          status: status);
    }
  }
  titleCtrl.dispose();
  deptCtrl.dispose();
}