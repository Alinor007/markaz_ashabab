import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import 'class_report_data.dart';
import 'report_pdf_common.dart';

/// Builds the "Class Tutorial Report" PDF for [data]. Pure Dart — safe to run
/// inside `Isolate.run`. [logoBytes] is the organization seal, already
/// loaded by the caller (isolates cannot use `rootBundle`).
///
/// Composed twice, same as [buildMemberReportPdf]: pass 1 discovers which
/// page each Area/Shu'ba/Level/Section landed on via [PageMarker]; pass 2
/// renders the real Table of Contents using those page numbers.
Future<Uint8List> buildClassReportPdf(
  ClassReportData data,
  Uint8List logoBytes,
) async {
  final logo = pw.MemoryImage(logoBytes);

  final pageOf = <String, int>{};
  final draft = _compose(data, logo, pageOf, recordPages: true);
  await draft.save();

  final finalDoc = _compose(data, logo, pageOf, recordPages: false);
  return finalDoc.save();
}

String _areaKey(ClassAreaGroup a) => 'area:${a.name}';
String _shubaKey(ClassAreaGroup a, ClassShubaGroup s) => 'shuba:${a.name}/${s.name}';
String _levelKey(ClassAreaGroup a, ClassShubaGroup s, ClassLevelGroup l) =>
    'level:${a.name}/${s.name}/${l.label}';
String _sectionKey(ClassAreaGroup a, ClassShubaGroup s, ClassLevelGroup l, ClassSection c) =>
    'section:${a.name}/${s.name}/${l.label}/${c.teacherName}|${c.sectionName}';
String _noClassKey(ClassAreaGroup a, ClassShubaGroup s, ClassLevelGroup l) =>
    'noclass:${a.name}/${s.name}/${l.label}';

pw.Document _compose(
  ClassReportData data,
  pw.MemoryImage logo,
  Map<String, int> pageOf, {
  required bool recordPages,
}) {
  final doc = pw.Document();

  doc.addPage(pw.Page(
    margin: reportPageMargin,
    build: (context) => buildCoverPage(
      logo,
      title: 'CLASS TUTORIAL REPORT',
      subtitle: 'Tutorial Class & Student Membership Overview',
      reportingPeriod: data.reportingPeriod,
      dateGenerated: data.dateGenerated,
      // filterSummary: data.filterSummary,
    ),
  ));

  doc.addPage(pw.MultiPage(
    margin: reportPageMargin,
    build: (context) => [
      pw.Text(
        'Table of Contents',
        style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 18, color: emerald),
      ),
      pw.SizedBox(height: 6),
      pw.Divider(color: borderColor, thickness: 1),
      pw.SizedBox(height: 12),
      for (final area in data.areas) ...[
        tocRow(area.name, pageOf[_areaKey(area)], bold: true),
        for (final shuba in area.shubas) ...[
          tocRow(shuba.name, pageOf[_shubaKey(area, shuba)], indentLevel: 1),
          for (final level in shuba.levels) ...[
            tocRow(level.label, pageOf[_levelKey(area, shuba, level)], indentLevel: 2),
            for (final section in level.sections)
              tocRow(
                '${section.teacherName}: ${section.sectionName}',
                pageOf[_sectionKey(area, shuba, level, section)],
                indentLevel: 3,
              ),
            if (level.noClass.isNotEmpty)
              tocRow(
                'No Class / No Teacher',
                pageOf[_noClassKey(area, shuba, level)],
                indentLevel: 3,
              ),
          ],
        ],
        pw.SizedBox(height: 8),
      ],
    ],
  ));

  doc.addPage(pw.MultiPage(
    margin: reportPageMargin,
    footer: reportPageFooter,
    build: (context) => [
      for (final area in data.areas) ...[
        if (recordPages) PageMarker((p) => pageOf[_areaKey(area)] = p),
        _areaHeader(area.name, area.total, area.withClass, area.withoutClass),
        for (final shuba in area.shubas) ...[
          if (recordPages) PageMarker((p) => pageOf[_shubaKey(area, shuba)] = p),
          _shubaHeader(shuba.name, shuba.masulName, shuba.total, shuba.withClass, shuba.withoutClass),
          for (final level in shuba.levels) ...[
            if (recordPages) PageMarker((p) => pageOf[_levelKey(area, shuba, level)] = p),
            _levelHeader(level.label, level.total, level.withClass, level.withoutClass),
            for (final section in level.sections) ...[
              if (recordPages) PageMarker((p) => pageOf[_sectionKey(area, shuba, level, section)] = p),
              _sectionHeader(section),
              _studentTable(section.students),
              subtotalLine('Class Subtotal: ${section.total} student${section.total == 1 ? '' : 's'}'),
              pw.SizedBox(height: 8),
            ],
            if (level.noClass.isNotEmpty) ...[
              if (recordPages) PageMarker((p) => pageOf[_noClassKey(area, shuba, level)] = p),
              _noClassHeader(level.noClass.length),
              _studentTable(level.noClass),
              subtotalLine(
                'Subtotal: ${level.noClass.length} member${level.noClass.length == 1 ? '' : 's'}',
              ),
              pw.SizedBox(height: 8),
            ],
          ],
          pw.SizedBox(height: 6),
        ],
        pw.SizedBox(height: 12),
      ],
      pw.Divider(color: emerald, thickness: 1.2),
      pw.SizedBox(height: 8),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'Grand Total: ${data.grandTotal} member${data.grandTotal == 1 ? '' : 's'}',
              style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 13, color: emerald),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              'With Class: ${data.grandWithClass}  ·  Without Class: ${data.grandWithoutClass}',
              style: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 10, color: muted),
            ),
          ],
        ),
      ),
    ],
  ));

  return doc;
}

String _countsLine(int total, int withClass, int withoutClass) =>
    'Total: $total  ·  With Class: $withClass  ·  Without Class: $withoutClass';

pw.Widget _areaHeader(String name, int total, int withClass, int withoutClass) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 8),
    padding: const pw.EdgeInsets.only(bottom: 6),
    decoration: const pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: emerald, width: 1.5)),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(name, style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 16, color: emerald)),
        pw.SizedBox(height: 3),
        pw.Text(
          _countsLine(total, withClass, withoutClass),
          style: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 9, color: muted),
        ),
      ],
    ),
  );
}

pw.Widget _shubaHeader(
  String name,
  String masulName,
  int total,
  int withClass,
  int withoutClass,
) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 4, bottom: 6, left: 8),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(name, style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 13, color: navy)),
            pw.SizedBox(width: 10),
            pw.Text(
              "Chairperson: $masulName",
              style: pw.TextStyle(font: pw.Font.helveticaOblique(), fontSize: 10, color: muted),
            ),
          ],
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          _countsLine(total, withClass, withoutClass),
          style: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 8.5, color: muted),
        ),
      ],
    ),
  );
}

pw.Widget _levelHeader(String label, int total, int withClass, int withoutClass) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 6, bottom: 4, left: 16),
    child: pw.Text(
      '$label  (${_countsLine(total, withClass, withoutClass)})',
      style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 10.5, color: charcoal),
    ),
  );
}

pw.Widget _sectionHeader(ClassSection s) {
  final year = s.schoolYear.trim().isEmpty ? 'N/A' : s.schoolYear.trim();
  final schedule = s.schedule.trim().isEmpty ? 'N/A' : s.schedule.trim();
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 8, bottom: 4, left: 24),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '${s.sectionName} (${s.total} student${s.total == 1 ? '' : 's'})',
          style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 11, color: navy),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          'Teacher: ${s.teacherName}  ·  School Year: $year  ·  Schedule: $schedule',
          style: pw.TextStyle(font: pw.Font.helveticaOblique(), fontSize: 9, color: muted),
        ),
      ],
    ),
  );
}

pw.Widget _noClassHeader(int count) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 8, bottom: 4, left: 24),
    child: pw.Text(
      'No Class / No Teacher ($count member${count == 1 ? '' : 's'})',
      style: pw.TextStyle(font: pw.Font.helveticaBoldOblique(), fontSize: 10.5, color: muted),
    ),
  );
}

pw.Widget _studentTable(List<ClassStudentRow> rows) {
  return dataTable(
    headers: const ['#', 'Full Name', 'Gender', 'Contact Number', 'Status'],
    rows: [
      for (final r in rows) [r.index.toString(), r.fullName, r.gender, r.contactNumber, r.status],
    ],
    columnWidths: const {
      0: pw.FixedColumnWidth(24),
      1: pw.FlexColumnWidth(3),
      2: pw.FlexColumnWidth(1.2),
      3: pw.FlexColumnWidth(1.8),
      4: pw.FlexColumnWidth(1.2),
    },
    cellAlignments: const {
      0: pw.Alignment.center,
      2: pw.Alignment.center,
      4: pw.Alignment.center,
    },
    // Deeper than the members report's tables — sections nest one level
    // further (Area → Shu'ba → Level → Section) before reaching a table.
    leftIndent: 32,
  );
}
