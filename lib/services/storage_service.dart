import 'dart:convert';
//import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:csv/csv.dart';
import '../models/expense.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:universal_html/html.dart' as html;

class StorageService {
  // ============================================================
  // 📄 Export ke PDF (Support: Web & Mobile)
  // ============================================================
  static Future<String> exportToPDF(List<Expense> expenses) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Laporan Pengeluaran",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.TableHelper.fromTextArray(
                  headers: ["Judul", "Jumlah", "Kategori", "Tanggal"],
                  data:
                      expenses.map((e) {
                        return [
                          e.title,
                          e.amount.toString(),
                          e.category,
                          "${e.date.day}/${e.date.month}/${e.date.year}",
                        ];
                      }).toList(),
                  headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellAlignment: pw.Alignment.centerLeft,
                ),
              ],
            ),
      ),
    );

    final bytes = await pdf.save();

    if (kIsWeb) {
      // 🌐 WEB: langsung trigger download via browser
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', 'Laporan_Pengeluaran.pdf')
        ..click();
      html.Url.revokeObjectUrl(url);
      return "sebagai PDF";
    } else {
      // 📱 MOBILE: simpan ke folder Downloads
      final dir =
          await DownloadsPathProvider.downloadsDirectory ??
          await getApplicationDocumentsDirectory();
      final path = "${dir.path}/Laporan_Pengeluaran.pdf";
      final file = File(path);
      await file.writeAsBytes(bytes);
      return path;
    }
  }

  // ============================================================
  // 📊 Export ke CSV (Support: Web & Mobile)
  // ============================================================
  static Future<String> exportToCSV(List<Expense> expenses) async {
    final List<List<dynamic>> rows = [
      ["Judul", "Jumlah", "Kategori", "Tanggal"],
    ];

    for (var e in expenses) {
      rows.add([
        e.title,
        e.amount,
        e.category,
        "${e.date.day}/${e.date.month}/${e.date.year}",
      ]);
    }

    final csvData = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csvData);

    if (kIsWeb) {
      // 🌐 WEB: langsung trigger download CSV via browser
      final blob = html.Blob([bytes], 'text/csv');
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..setAttribute('download', 'Laporan_Pengeluaran.csv')
        ..click();

      html.Url.revokeObjectUrl(url);
      return "sebagai CSV";
    } else {
      // 📱 MOBILE: simpan ke folder Downloads
      final dir =
          await DownloadsPathProvider.downloadsDirectory ??
          await getApplicationDocumentsDirectory();
      final path = "${dir.path}/Laporan_Pengeluaran.csv";
      final file = File(path);
      await file.writeAsBytes(bytes);
      return path;
    }
  }
}
