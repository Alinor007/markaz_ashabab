import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import 'member_report_data.dart';
import 'report_pdf_common.dart';

/// Builds the "Member List Report" PDF for [data]. Pure Dart — safe to run
/// inside `Isolate.run`. [logoBytes] is the organization seal, already
/// loaded by the caller (isolates cannot use `rootBundle`).
///
/// The document is composed twice: pass 1 discovers which page each Area and
/// Shu'ba landed on (via [PageMarker], an invisible widget that reports
/// `context.pageNumber` at paint time — the same mechanism the `pdf` package
/// itself uses for named destinations/bookmarks); pass 2 renders the real
/// Table of Contents using those page numbers. The two passes render
/// identical content (the TOC's own page count is unaffected by whether the
/// page-number column is filled in), so the offsets line up.
Future<Uint8List> buildMemberReportPdf(
  MemberReportData data,
  Uint8List logoBytes,
) async {
  final logo = pw.MemoryImage(logoBytes);

  final pageOf = <String, int>{};
  final draft = _compose(data, logo, pageOf, recordPages: true);
  await draft.save();

  final finalDoc = _compose(data, logo, pageOf, recordPages: false);
  return finalDoc.save();
}

String _areaKey(AreaGroup area) => 'area:${area.name}';
String _shubaKey(AreaGroup area, ShubaGroup shuba) =>
    'shuba:${area.name}/${shuba.name}';

pw.Document _compose(
  MemberReportData data,
  pw.MemoryImage logo,
  Map<String, int> pageOf, {
  required bool recordPages,
}) {
  final doc = pw.Document();

  doc.addPage(pw.Page(
    margin: reportPageMargin,
    build: (context) => buildCoverPage(
      logo,
      title: 'MEMBER LIST REPORT',
      subtitle: "Tarbiya Area, Shu'ba & Class Membership Overview",
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
        for (final shuba in area.shubas)
          tocRow(shuba.name, pageOf[_shubaKey(area, shuba)], indentLevel: 1),
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
        _areaHeader(area.name),
        for (final shuba in area.shubas) ...[
          if (recordPages) PageMarker((p) => pageOf[_shubaKey(area, shuba)] = p),
          _shubaHeader(shuba.name, shuba.masulName),
          for (final level in shuba.levels) ...[
            _levelHeader(level.label, level.total),
            _memberTable(level.rows),
          ],
          subtotalLine("Shu'ba Subtotal: ${shuba.total} member${shuba.total == 1 ? '' : 's'}"),
          pw.SizedBox(height: 14),
        ],
        subtotalLine('Area Subtotal: ${area.total} member${area.total == 1 ? '' : 's'}', emphasis: true),
        pw.SizedBox(height: 18),
      ],
      pw.Divider(color: emerald, thickness: 1.2),
      pw.SizedBox(height: 8),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Grand Total: ${data.grandTotal} member${data.grandTotal == 1 ? '' : 's'}',
          style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 13, color: emerald),
        ),
      ),
    ],
  ));

  return doc;
}

pw.Widget _areaHeader(String name) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 8),
    padding: const pw.EdgeInsets.only(bottom: 6),
    decoration: const pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: emerald, width: 1.5)),
    ),
    child: pw.Text(
      name,
      style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 16, color: emerald),
    ),
  );
}

pw.Widget _shubaHeader(String name, String masulName) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 4, bottom: 6, left: 8),
    child: pw.Row(
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
  );
}

pw.Widget _levelHeader(String label, int total) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 6, bottom: 4, left: 16),
    child: pw.Text(
      '$label ($total member${total == 1 ? '' : 's'})',
      style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 10.5, color: charcoal),
    ),
  );
}

pw.Widget _memberTable(List<MemberReportRow> rows) {
  return dataTable(
    headers: const ['#', 'Full Name', 'Gender', 'Civil Status', 'Contact Number', 'Status'],
    rows: [
      for (final r in rows)
        [r.index.toString(), r.fullName, r.gender, r.civilStatus, r.contactNumber, r.status],
    ],
    columnWidths: const {
      0: pw.FixedColumnWidth(24),
      1: pw.FlexColumnWidth(3),
      2: pw.FlexColumnWidth(1.2),
      3: pw.FlexColumnWidth(1.6),
      4: pw.FlexColumnWidth(1.8),
      5: pw.FlexColumnWidth(1.2),
    },
    cellAlignments: const {
      0: pw.Alignment.center,
      2: pw.Alignment.center,
      5: pw.Alignment.center,
    },
  );
}
