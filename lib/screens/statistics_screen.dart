import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() {
    setState(() async {
      expenses = await ExpenseService.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Statistik Pengeluaran')),
        body: const Center(child: Text('Belum ada pengeluaran')),
      );
    }

    // Hitung total pengeluaran per kategori
    final Map<String, double> categoryTotals = {};
    for (var e in expenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Pengeluaran'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '📊 Distribusi Pengeluaran per Kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // PIE CHART
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: categoryTotals.entries.map((entry) {
                    return PieChartSectionData(
                      title: entry.key,
                      value: entry.value,
                      color: Colors.primaries[
                          categoryTotals.keys.toList().indexOf(entry.key) %
                              Colors.primaries.length],
                      radius: 80,
                      titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // LIST DETAIL PER KATEGORI
            Expanded(
              child: ListView(
                children: categoryTotals.entries.map((entry) {
                  return ListTile(
                    leading: const Icon(Icons.category),
                    title: Text(entry.key),
                    trailing: Text('Rp ${entry.value.toStringAsFixed(0)}'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
