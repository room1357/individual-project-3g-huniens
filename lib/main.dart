import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'models/expense.dart';
import 'models/expense_manage.dart';

void main() {
  final sampleExpenses = [
    Expense(
      id: '1',
      title: 'Belanja Bulanan',
      amount: 150000,
      category: 'Makanan',
      date: DateTime(2024, 9, 15),
      description: 'Belanja kebutuhan bulanan',
    ),
    Expense(
      id: '2',
      title: 'Bensin Motor',
      amount: 50000,
      category: 'Transportasi',
      date: DateTime(2024, 9, 14),
      description: 'Isi bensin motor',
    ),
  ];

  print("Total per kategori: ${ExpenseManager.getTotalByCategory(sampleExpenses)}");
  print("Pengeluaran tertinggi: ${ExpenseManager.getHighestExpense(sampleExpenses)?.title}");
  print("Pengeluaran bulan 9/2024: ${ExpenseManager.getExpensesByMonth(sampleExpenses, 9, 2024).length} item");
  print("Cari 'bensin': ${ExpenseManager.searchExpenses(sampleExpenses, 'bensin').length} item");
  print("Rata-rata harian: Rp ${ExpenseManager.getAverageDaily(sampleExpenses)}");
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pengeluaran',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
       debugShowCheckedModeBanner: false,
      home: const LoginScreen(), // Halaman pertama
    );
  }
}