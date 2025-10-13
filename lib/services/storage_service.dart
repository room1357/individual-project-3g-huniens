import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/expense.dart';

class StorageService {
  // 📁 Export ke CSV
  static Future<String> exportToCSV(List<Expense> expenses) async {
    List<List<dynamic>> rows = [
      ["ID", "Judul", "Jumlah", "Kategori", "Tanggal", "Deskripsi"]
    ];

    for (var e in expenses) {
      rows.add([
        e.id,
        e.title,
        e.amount,
        e.category,
        e.date.toString(),
        e.description,
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/pengeluaran.csv";
    final file = File(path);
    await file.writeAsString(csvData);
    return path;
  }

  // 📄 Export ke PDF
  static Future<String> exportToPDF(List<Expense> expenses) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Laporan Pengeluaran",
                style: pw.TextStyle(
                    fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ["Judul", "Jumlah", "Kategori", "Tanggal"],
              data: expenses.map((e) {
                return [
                  e.title,
                  e.amount.toString(),
                  e.category,
                  "${e.date.day}/${e.date.month}/${e.date.year}",
                ];
              }).toList(),
            ),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/pengeluaran.pdf";
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    return path;
  }
}
