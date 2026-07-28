import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Built-in Type1 fonts only (Helvetica/Times) — the app's bundled Inter and
// Cormorant Garamond are *variable* fonts and `pdf`'s Font.ttf() cannot
// interpolate their weight axis, so embedding them would yield no real bold.
// Built-in fonts also mean report PDF builders never need `rootBundle`,
// keeping them safe to run inside `Isolate.run`. They're also Latin-only, so
// report text sticks to plain ASCII (a hyphen, never an em-dash).
//
// Shared by every report PDF builder (member_report_pdf.dart,
// class_report_pdf.dart, …) so they render as one consistent document family.

const emerald = PdfColor.fromInt(0xFF0B5D3B);
const emeraldLight = PdfColor.fromInt(0xFF3F8A63);
const navy = PdfColor.fromInt(0xFF16243D);
const muted = PdfColor.fromInt(0xFF5C5F58);
const borderColor = PdfColor.fromInt(0xFFE3DDCB);
const charcoal = PdfColor.fromInt(0xFF22251F);

const orgName = "MARKAZOSSHABAB AL-MUSLIM FIL-FILIBBIN FOUNDATION, INC.";
const orgAddress = "Biaba-Damag, Marawi City, Lanao Del Sur";

const reportPageMargin = pw.EdgeInsets.all(36);

/// The shared cover page: logo + org name/address header, a divider, the
/// vertically-centered title/subtitle, and a reporting-period/date-generated/
/// filters footer. [title] and [subtitle] are the only per-report content.
pw.Widget buildCoverPage(
  pw.MemoryImage logo, {
  required String title,
  required String subtitle,
  required String reportingPeriod,
  required String dateGenerated,
  // required String filterSummary,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.SizedBox(width: 56, height: 56, child: pw.Image(logo)),
          pw.SizedBox(width: 16),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  orgName,
                  style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 13, color: emerald),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  orgAddress,
                  style: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 9.5, color: muted),
                ),
              ],
            ),
          ),
        ],
      ),
      pw.SizedBox(height: 14),
      pw.Divider(color: borderColor, thickness: 1.2),
      pw.Expanded(
        child: pw.Center(
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 28, color: emerald),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                subtitle,
                style: pw.TextStyle(font: pw.Font.timesItalic(), fontSize: 13, color: emeraldLight),
              ),
            ],
          ),
        ),
      ),
      pw.Column(
        children: [
          pw.Text(
            'Reporting Period: $reportingPeriod',
            style: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 10, color: muted),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            'Date Generated: $dateGenerated',
            style: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 10, color: muted),
          ),
          // if (filterSummary.isNotEmpty) ...[
          //   pw.SizedBox(height: 8),
          //   pw.Text(
          //     'Filters Applied: $filterSummary',
          //     style: pw.TextStyle(font: pw.Font.timesItalic(), fontSize: 9, color: muted),
          //   ),
          // ],
        ],
      ),
    ],
  );
}

/// One Table-of-Contents line: a label on the left, its page number on the
/// right, indented `indentLevel` steps to show hierarchy depth.
pw.Widget tocRow(String label, int? page, {int indentLevel = 0, bool bold = false}) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(left: indentLevel * 16.0, bottom: 4),
    child: pw.Row(
      children: [
        pw.Expanded(
          child: pw.Text(
            label,
            style: pw.TextStyle(
              font: bold ? pw.Font.helveticaBold() : pw.Font.helvetica(),
              fontSize: bold ? 12 : 10.5,
              color: bold ? charcoal : muted,
            ),
          ),
        ),
        pw.Text(
          page?.toString() ?? '-', // plain hyphen — Helvetica lacks U+2014
          style: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 10.5, color: muted),
        ),
      ],
    ),
  );
}

/// The "Page N of M" footer shared by every report body `MultiPage`.
pw.Widget reportPageFooter(pw.Context context) {
  return pw.Container(
    alignment: pw.Alignment.centerRight,
    margin: const pw.EdgeInsets.only(top: 8),
    child: pw.Text(
      'Page ${context.pageNumber} of ${context.pagesCount}',
      style: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 9, color: muted),
    ),
  );
}

/// A right-aligned subtotal/count line (e.g. "Shu'ba Subtotal: 12 members",
/// "With Class: 8  ·  Without Class: 4"). Callers compose the full [text].
pw.Widget subtotalLine(String text, {bool emphasis = false}) {
  return pw.Align(
    alignment: pw.Alignment.centerRight,
    child: pw.Text(
      text,
      style: pw.TextStyle(
        font: emphasis ? pw.Font.helveticaBold() : pw.Font.helveticaOblique(),
        fontSize: emphasis ? 10.5 : 9.5,
        color: emphasis ? navy : muted,
      ),
    ),
  );
}

/// The shared roster-table look: emerald header row, hairline borders, small
/// body text. Each report supplies its own [headers]/[rows]/[columnWidths]
/// since the columns differ (e.g. the members table has a Civil Status
/// column the class report's student table omits).
pw.Widget dataTable({
  required List<String> headers,
  required List<List<String>> rows,
  required Map<int, pw.TableColumnWidth> columnWidths,
  Map<int, pw.Alignment> cellAlignments = const {},
  double leftIndent = 16,
}) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(left: leftIndent, bottom: 6),
    child: pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows,
      headerStyle: pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 9, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: emerald),
      cellStyle: pw.TextStyle(font: pw.Font.helvetica(), fontSize: 9, color: charcoal),
      cellHeight: 20,
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      border: pw.TableBorder.all(color: borderColor, width: 0.5),
      columnWidths: columnWidths,
      cellAlignments: cellAlignments,
    ),
  );
}

/// An invisible zero-size widget that reports the page it actually landed on
/// once painted. Mirrors how the `pdf` package's own `Anchor`/`Outline`
/// widgets capture `context.pageNumber` at paint time to register named
/// destinations/bookmarks — the mechanism is proven to reflect each widget's
/// real, final page rather than an intermediate layout pass.
///
/// Used for the two-pass Table of Contents: pass 1 renders with these markers
/// active to discover page numbers; pass 2 renders the real TOC using them.
class PageMarker extends pw.Widget {
  PageMarker(this._onPage);
  final void Function(int pageNumber) _onPage;

  @override
  void layout(pw.Context context, pw.BoxConstraints constraints, {bool parentUsesSize = false}) {
    box = PdfRect.zero;
  }

  @override
  void paint(pw.Context context) {
    super.paint(context);
    _onPage(context.pageNumber);
  }
}
