import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/data/app_database.dart';
import '../../core/data/models.dart';
import '../../core/i18n/localized.dart';
import '../../core/repositories/department_repository.dart';
import '../../core/repositories/gallery_repository.dart';
import '../../core/repositories/leader_repository.dart';
import '../../core/repositories/report_repository.dart';
import '../../core/repositories/tarbiya_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/layout/module_page.dart';

/// One unified search hit.
class _Hit {
  _Hit({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.categoryEn,
    required this.categoryAr,
    required this.color,
    required this.route,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final String categoryEn;
  final String categoryAr;
  final Color color;
  final String route;
}

/// Unified search across members, leaders, departments, reports, and photos.
/// Results are grouped by category with a count badge.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialQuery});

  /// Seeded from the top-bar global search (`/search?q=…`).
  final String? initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialQuery ?? '');
  late String _query = widget.initialQuery ?? '';
  List<Leader> _leaders = const [];
  List<Member> _members = const [];
  List<Department> _departments = const [];
  List<Report> _reports = const [];
  List<GalleryPhoto> _photos = const [];
  Map<String, Department> _deptById = const {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final leaderRepo = context.read<LeaderRepository>();
    final tarbiyaRepo = context.read<TarbiyaRepository>();
    final deptRepo = context.read<DepartmentRepository>();
    final reportRepo = context.read<ReportRepository>();
    final galleryRepo = context.read<GalleryRepository>();
    final leaders = await leaderRepo.getAll();
    final members = await tarbiyaRepo.getAllMembers();
    final departments = await deptRepo.getAll();
    final reports = await reportRepo.getAll();
    final photos = await galleryRepo.getAll();
    if (!mounted) return;
    setState(() {
      _leaders = leaders;
      _members = members;
      _departments = departments;
      _reports = reports;
      _photos = photos;
      _deptById = {for (final d in departments) d.id: d};
    });
  }

  bool _match(String q, List<String> haystack) {
    final ql = q.toLowerCase();
    return haystack.any((h) => h.toLowerCase().contains(ql) || h.contains(q));
  }

  Map<String, List<_Hit>> _results(BuildContext context) {
    final q = _query.trim();
    final groups = <String, List<_Hit>>{};
    if (q.isEmpty) return groups;

    void add(String key, _Hit hit) =>
        groups.putIfAbsent(key, () => []).add(hit);

    for (final l in _leaders) {
      if (_match(q, [l.name, l.nameAr, l.position, l.positionAr])) {
        add('leaders', _Hit(
          title: l.name,
          subtitle: l.position,
          icon: Icons.workspace_premium_outlined,
          categoryEn: 'Leaders', categoryAr: 'القادة',
          color: AppColors.navy,
          route: '/leadership/profile/${l.id}',
        ));
      }
    }
    for (final m in _members) {
      if (_match(q, [m.fullName, m.nameAr, m.occupation])) {
        add('members', _Hit(
          title: m.displayName(context.isArabic),
          subtitle:
              m.occupation.isEmpty ? m.levelLabel(context.isArabic) : m.occupation,
          icon: Icons.person_outline,
          categoryEn: 'Members', categoryAr: 'الأعضاء',
          color: AppColors.emerald,
          route: '/tarbiya/member/${m.id}',
        ));
      }
    }
    for (final d in _departments) {
      if (_match(q, [d.name, d.nameAr, d.description, d.descriptionAr])) {
        add('departments', _Hit(
          title: d.displayName(context.isArabic),
          subtitle: 'Department',
          icon: d.icon,
          categoryEn: 'Departments', categoryAr: 'الأقسام',
          color: AppColors.goldDeep,
          route: '/departments/${d.id}',
        ));
      }
    }
    for (final r in _reports) {
      if (_match(q, [r.title, r.titleAr])) {
        add('reports', _Hit(
          title: r.title,
          subtitle: _deptById[r.departmentId]?.displayName(context.isArabic) ??
              'Report',
          icon: Icons.description_outlined,
          categoryEn: 'Reports', categoryAr: 'التقارير',
          color: AppColors.navy,
          route: '/reports',
        ));
      }
    }
    for (final p in _photos) {
      if (_match(q, [p.title, p.titleAr, p.event, p.eventAr])) {
        add('photos', _Hit(
          title: p.titleAr.isNotEmpty
              ? p.title
              : p.title,
          subtitle: '${p.event} · ${p.year}',
          icon: Icons.photo_outlined,
          categoryEn: 'Photos', categoryAr: 'الصور',
          color: AppColors.emerald,
          route: '/gallery',
        ));
      }
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _results(context);
    final totalCount =
        groups.values.fold<int>(0, (sum, list) => sum + list.length);

    return ModulePage(
      english: 'Search',
      arabic: 'البحث',
      actions: [
        SearchField(
          width: 360,
          controller: _controller,
          hint: 'Search members, leaders, reports…',
          onChanged: (v) => setState(() => _query = v),
        ),
      ],
      child: _query.trim().isEmpty
          ? EmptyState(
              icon: Icons.search,
              title: 'Search the archive',
              message: 'Find members, leaders, departments, reports, and photos.',
            )
          : totalCount == 0
              ? EmptyState(
                  icon: Icons.search_off,
                  title: 'No results',
                  message: 'No matches for “$_query”.',
                )
              : ListView(
                  children: [
                    for (final entry in groups.entries) ...[
                      _GroupSection(hits: entry.value),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ],
                ),
    );
  }
}

class _GroupSection extends StatelessWidget {
  const _GroupSection({required this.hits});
  final List<_Hit> hits;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final first = hits.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              isArabic ? first.categoryAr : first.categoryEn,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 1),
              decoration: BoxDecoration(
                color: first.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text('${hits.length}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: first.color,
                        fontWeight: FontWeight.w700,
                      )),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final hit in hits)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _HitRow(hit: hit),
          ),
      ],
    );
  }
}

class _HitRow extends StatelessWidget {
  const _HitRow({required this.hit});
  final _Hit hit;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.card,
      child: InkWell(
        borderRadius: AppRadius.card,
        onTap: () => context.go(hit.route),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: hit.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(hit.icon, color: hit.color, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hit.title,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall),
                    Text(hit.subtitle,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: hit.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  isArabic ? hit.categoryAr : hit.categoryEn,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: hit.color,
                      ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(isArabic ? Icons.arrow_back : Icons.arrow_forward,
                  size: 16, color: AppColors.textFaint),
            ],
          ),
        ),
      ),
    );
  }
}
