import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/expense_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ExpenseService.loadExpenses(); // muat data dari SharedPreferences
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pengeluaran',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
