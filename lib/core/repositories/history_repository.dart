import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/app_database.dart';
import '../data/models.dart';
import '../util/photo_service.dart';

/// A story paragraph parsed from the History content's narrative.
typedef HistoryParagraph = ({String en});

/// A History stat card parsed from the content's facts JSON.
typedef HistoryFact = ({
  String value,
  String en,
  String iconKey,
  int accent,
});

/// Reads and edits the History page content (a singleton row) and its
/// milestones timeline. Executives edit; everyone reads.
class HistoryRepository {
  HistoryRepository(this._db, [this._photos = const PhotoService()]);
  final AppDatabase _db;
  final PhotoService _photos;

  static const _rowId = 'history';

  String _id(String p) => newId(p);

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

  /// Decodes the narrative JSON into paragraphs.
  static List<HistoryParagraph> paragraphsOf(HistoryContent? c) {
    if (c == null || c.narrative.trim().isEmpty) return const [];
    final list = jsonDecode(c.narrative) as List;
    return [
      for (final e in list) (en: '${(e as Map)['en'] ?? ''}')
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
          iconKey: '${e['iconKey'] ?? 'flag'}',
          accent: (e['accent'] as num?)?.toInt() ?? 0xFF0B5D3B,
        )
    ];
  }

  Future<void> setNarrative(List<HistoryParagraph> paragraphs) => updateContent(
        HistoryContentsCompanion(
          narrative:
              Value(jsonEncode([for (final p in paragraphs) {'en': p.en}])),
        ),
      );

  Future<void> setFacts(List<HistoryFact> facts) => updateContent(
        HistoryContentsCompanion(
          facts: Value(jsonEncode([
            for (final f in facts)
              {
                'value': f.value,
                'en': f.en,
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
    required String description,
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
            description: Value(description),
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
    required String description,
    required String iconKey,
    required int accent,
  }) =>
      (_db.update(_db.historyMilestones)..where((m) => m.id.equals(id))).write(
        HistoryMilestonesCompanion(
          year: Value(year),
          title: Value(title),
          description: Value(description),
          iconKey: Value(iconKey),
          accent: Value(accent),
        ),
      );

  Future<void> deleteMilestone(String id) =>
      (_db.delete(_db.historyMilestones)..where((m) => m.id.equals(id))).go();

  // ── Leadership Legacy (hand-curated, not member-linked) ─────────────────────
  Stream<List<HistoryLegacyLeader>> watchLegacyLeaders() =>
      (_db.select(_db.historyLegacyLeaders)
            ..orderBy([
              (l) => OrderingTerm(expression: l.sortOrder),
              (l) => OrderingTerm(expression: l.createdAt),
            ]))
          .watch();

  Stream<HistoryLegacyLeader?> watchLegacyLeader(String id) =>
      (_db.select(_db.historyLegacyLeaders)..where((l) => l.id.equals(id)))
          .watchSingleOrNull();

  Future<String> addLegacyLeader({
    required String name,
    required String position,
    required String termYears,
    required String photoPath,
    required int accent,
  }) async {
    final all = await _db.select(_db.historyLegacyLeaders).get();
    final nextSort =
        all.fold<int>(0, (m, e) => e.sortOrder >= m ? e.sortOrder + 1 : m);
    final id = _id('legacyleader');
    await _db.into(_db.historyLegacyLeaders).insert(
          HistoryLegacyLeadersCompanion.insert(
            id: id,
            name: Value(name),
            position: Value(position),
            termYears: Value(termYears),
            photoPath: Value(photoPath),
            accent: Value(accent),
            sortOrder: Value(nextSort),
          ),
        );
    return id;
  }

  Future<void> updateLegacyLeader(
    String id, {
    required String name,
    required String position,
    required String termYears,
    required int accent,
    // Only overwrite the photo when a new value is supplied.
    String? photoPath,
  }) =>
      (_db.update(_db.historyLegacyLeaders)..where((l) => l.id.equals(id)))
          .write(HistoryLegacyLeadersCompanion(
        name: Value(name),
        position: Value(position),
        termYears: Value(termYears),
        accent: Value(accent),
        photoPath:
            photoPath == null ? const Value.absent() : Value(photoPath),
      ));

  Future<void> deleteLegacyLeader(String id) async {
    final row = await (_db.select(_db.historyLegacyLeaders)
          ..where((l) => l.id.equals(id)))
        .getSingleOrNull();
    // Biography sections cascade-delete with the owning leader (FK).
    await (_db.delete(_db.historyLegacyLeaders)..where((l) => l.id.equals(id)))
        .go();
    await _photos.deleteStored(row?.photoPath);
  }

  // ── Legacy leader biography sections (repeatable title + body) ──────────────
  Stream<List<HistoryLegacyLeaderSection>> watchLegacySections(
          String legacyLeaderId) =>
      (_db.select(_db.historyLegacyLeaderSections)
            ..where((s) => s.legacyLeaderId.equals(legacyLeaderId))
            ..orderBy([(s) => OrderingTerm(expression: s.sortOrder)]))
          .watch();

  Future<void> addLegacySection({
    required String legacyLeaderId,
    required String title,
    required String body,
    required int sortOrder,
  }) =>
      _db.into(_db.historyLegacyLeaderSections).insert(
            HistoryLegacyLeaderSectionsCompanion.insert(
              id: _id('legacysection'),
              legacyLeaderId: legacyLeaderId,
              title: Value(title),
              body: Value(body),
              sortOrder: Value(sortOrder),
            ),
          );

  Future<void> deleteLegacySection(String id) =>
      (_db.delete(_db.historyLegacyLeaderSections)..where((s) => s.id.equals(id)))
          .go();
}
