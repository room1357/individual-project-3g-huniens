import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'services/user_service.dart';
import 'services/expense_service.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load user yang tersimpan di SharedPreferences
  await UserService.loadLoggedInUser();

  // Inisialisasi data Expense untuk user yang sedang login
  await ExpenseService.initialize();

  final isLoggedIn = UserService.loggedInUser != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
