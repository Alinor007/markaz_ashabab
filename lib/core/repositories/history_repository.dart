import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/app_database.dart';

/// A story paragraph (bilingual) parsed from the History content's narrative.
typedef HistoryParagraph = ({String en, String ar});

/// A History stat card parsed from the content's facts JSON.
typedef HistoryFact = ({
  String value,
  String en,
  String ar,
  String iconKey,
  int accent,
});

/// Reads and edits the History page content (a singleton row) and its
/// milestones timeline. Executives edit; everyone reads.
class HistoryRepository {
  HistoryRepository(this._db);
  final AppDatabase _db;

  static const _rowId = 'history';

  String _id(String p) => '${p}_${DateTime.now().microsecondsSinceEpoch}';

  // ── Singleton content ──────────────────────────────────────────────────────
  Stream<HistoryContent?> watchContent() =>
      (_db.select(_db.historyContents)..where((c) => c.id.equals(_rowId)))
          .watchSingleOrNull();

  Future<HistoryContent?> getContent() =>
      (_db.select(_db.historyContents)..where((c) => c.id.equals(_rowId)))
          .getSingleOrNull();

  /// Writes a partial update to the singleton content row (creating it first if
  /// it somehow does not exist).
  Future<void> updateContent(HistoryContentsCompanion data) async {
    final existing = await getContent();
    if (existing == null) {
      await _db.into(_db.historyContents).insert(
          data.copyWith(id: const Value(_rowId)),
          mode: InsertMode.insertOrReplace);
      return;
    }
    await (_db.update(_db.historyContents)..where((c) => c.id.equals(_rowId)))
        .write(data);
  }

  /// Decodes the narrative JSON into bilingual paragraphs.
  static List<HistoryParagraph> paragraphsOf(HistoryContent? c) {
    if (c == null || c.narrative.trim().isEmpty) return const [];
    final list = jsonDecode(c.narrative) as List;
    return [
      for (final e in list)
        (en: '${(e as Map)['en'] ?? ''}', ar: '${e['ar'] ?? ''}')
    ];
  }

  /// Decodes the facts JSON into stat cards.
  static List<HistoryFact> factsOf(HistoryContent? c) {
    if (c == null || c.facts.trim().isEmpty) return const [];
    final list = jsonDecode(c.facts) as List;
    return [
      for (final e in list)
        (
          value: '${(e as Map)['value'] ?? ''}',
          en: '${e['en'] ?? ''}',
          ar: '${e['ar'] ?? ''}',
          iconKey: '${e['iconKey'] ?? 'flag'}',
          accent: (e['accent'] as num?)?.toInt() ?? 0xFF0B5D3B,
        )
    ];
  }

  Future<void> setNarrative(List<HistoryParagraph> paragraphs) => updateContent(
        HistoryContentsCompanion(
          narrative: Value(jsonEncode(
              [for (final p in paragraphs) {'en': p.en, 'ar': p.ar}])),
        ),
      );

  Future<void> setFacts(List<HistoryFact> facts) => updateContent(
        HistoryContentsCompanion(
          facts: Value(jsonEncode([
            for (final f in facts)
              {
                'value': f.value,
                'en': f.en,
                'ar': f.ar,
                'iconKey': f.iconKey,
                'accent': f.accent,
              }
          ])),
        ),
      );

  // ── Milestones ─────────────────────────────────────────────────────────────
  Stream<List<HistoryMilestone>> watchMilestones() =>
      (_db.select(_db.historyMilestones)
            ..orderBy([
              (m) => OrderingTerm(expression: m.sortOrder),
              (m) => OrderingTerm(expression: m.createdAt),
            ]))
          .watch();

  Future<void> addMilestone({
    required String year,
    required String title,
    required String titleAr,
    required String description,
    required String descriptionAr,
    required String iconKey,
    required int accent,
  }) async {
    final all = await _db.select(_db.historyMilestones).get();
    final nextSort = all.fold<int>(0, (m, e) => e.sortOrder >= m ? e.sortOrder + 1 : m);
    await _db.into(_db.historyMilestones).insert(
          HistoryMilestonesCompanion.insert(
            id: _id('milestone'),
            year: Value(year),
            title: Value(title),
            titleAr: Value(titleAr),
            description: Value(description),
            descriptionAr: Value(descriptionAr),
            iconKey: Value(iconKey),
            accent: Value(accent),
            sortOrder: Value(nextSort),
          ),
        );
  }

  Future<void> updateMilestone(
    String id, {
    required String year,
    required String title,
    required String titleAr,
    required String description,
    required String descriptionAr,
    required String iconKey,
    required int accent,
  }) =>
      (_db.update(_db.historyMilestones)..where((m) => m.id.equals(id))).write(
        HistoryMilestonesCompanion(
          year: Value(year),
          title: Value(title),
          titleAr: Value(titleAr),
          description: Value(description),
          descriptionAr: Value(descriptionAr),
          iconKey: Value(iconKey),
          accent: Value(accent),
        ),
      );

  Future<void> deleteMilestone(String id) =>
      (_db.delete(_db.historyMilestones)..where((m) => m.id.equals(id))).go();
}
