import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'expense_list_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'add_expense_screen.dart';
import 'category_screen.dart';
import 'statistics_screen.dart';
import '../services/user_service.dart';
import 'shared_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade700,
              Colors.purple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang! 👋',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () {
                          UserService.logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // Card Container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildModernCard(
                          context,
                          'Tambah',
                          Icons.add_circle_rounded,
                          Colors.purpleAccent.shade400,
                          Colors.purple.shade50,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddExpenseScreen(),
                              ),
                            );
                          },
                        ),
                        _buildModernCard(
                          context,
                          'Pengeluaran',
                          Icons.wallet_rounded,
                          Colors.deepPurple.shade400,
                          Colors.deepPurple.shade50,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ExpenseListScreen(),
                              ),
                            );
                          },
                        ),
                        _buildModernCard(
                          context,
                          'Kategori',
                          Icons.category_rounded,
                          Colors.purple.shade600,
                          Colors.purple.shade50,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoryScreen(),
                              ),
                            );
                          },
                        ),
                        _buildModernCard(
                          context,
                          'Statistik',
                          Icons.bar_chart_rounded,
                          Colors.purple.shade700,
                          Colors.purple.shade50,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StatisticsScreen(),
                              ),
                            );
                          },
                        ),
                        _buildModernCard(
                          context,
                          'Shared',
                          Icons.group_rounded,
                          Colors.deepPurple.shade500,
                          Colors.deepPurple.shade50,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const SharedExpenseScreen(),
                              ),
                            );
                          },
                        ),
                        _buildModernCard(
                          context,
                          'Pesan',
                          Icons.message_rounded,
                          Colors.pinkAccent.shade400,
                          Colors.pink.shade50,
                          null,
                        ),
                        _buildModernCard(
                          context,
                          'Profil',
                          Icons.person_rounded,
                          Colors.purple.shade400,
                          Colors.purple.shade50,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                        ),
                        _buildModernCard(
                          context,
                          'Pengaturan',
                          Icons.settings_rounded,
                          Colors.deepPurple.shade600,
                          Colors.deepPurple.shade50,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernCard(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    Color backgroundColor,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Fitur $title segera hadir!'),
                backgroundColor: Colors.deepPurple,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
