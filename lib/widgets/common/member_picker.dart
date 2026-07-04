import 'package:flutter/material.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/member_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import 'portrait_avatar.dart';

/// Opens a search-and-select dialog over existing members and returns the one
/// the user taps, or null if cancelled. Only members that exist (match the
/// search) can be chosen.
///
/// The repository is passed in because dialogs in this app are shown on the
/// root navigator and don't read providers themselves — capture it in the
/// caller (where the provider is in scope) and hand it over.
Future<Member?> pickMember(
  BuildContext context,
  MemberRepository repo, {
  required String title,
  String? excludeId,
  Set<String> excludeIds = const {},
}) {
  return showDialog<Member>(
    context: context,
    builder: (_) => MemberPickerDialog(
      repo: repo,
      title: title,
      excludeId: excludeId,
      excludeIds: excludeIds,
    ),
  );
}

class MemberPickerDialog extends StatefulWidget {
  const MemberPickerDialog({
    super.key,
    required this.repo,
    required this.title,
    this.excludeId,
    this.excludeIds = const {},
  });

  final MemberRepository repo;
  final String title;
  final String? excludeId;
  final Set<String> excludeIds;

  @override
  State<MemberPickerDialog> createState() => _MemberPickerDialogState();
}

class _MemberPickerDialogState extends State<MemberPickerDialog> {
  final _searchCtrl = TextEditingController();
  List<Member> _results = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _run('');
  }

  Future<void> _run(String query) async {
    setState(() => _loading = true);
    try {
      final results =
          await widget.repo.searchMembers(query, excludeId: widget.excludeId);
      if (!mounted) return;
      setState(() {
        _results =
            results.where((m) => !widget.excludeIds.contains(m.id)).toList();
        _loading = false;
      });
    } catch (_) {
      // Surface as "no results" rather than hanging on the spinner forever.
      if (!mounted) return;
      setState(() {
        _results = const [];
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(widget.title),
      content: SizedBox(
        width: 440,
        height: 460,
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              autofocus: true,
              onChanged: _run,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Icon(Icons.search),
                labelText: 'Search by name',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? Center(
                          child: Text(
                            'No members found',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      : ListView.separated(
                          itemCount: _results.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final m = _results[i];
                            return ListTile(
                              dense: true,
                              leading: PortraitAvatar(
                                  initials: m.initials,
                                  imagePath: m.photoPath,
                                  size: 36,
                                  ring: false),
                              title: Text(m.displayName(context.isArabic)),
                              subtitle: Text(m.levelLabel(context.isArabic)),
                              onTap: () => Navigator.pop(context, m),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
