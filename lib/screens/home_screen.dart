import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'expense_list_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'add_expense_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              // Logout dengan pushAndRemoveUntil
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false, // Hapus semua route sebelumnya
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    'Pengeluaran',
                    Icons.attach_money,
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExpenseListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    'Profil',
                    Icons.person,
                    Colors.blue,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    'Pesan',
                    Icons.message,
                    Colors.orange,
                    null, // belum ada screen, tampil snackbar
                  ),
                  _buildDashboardCard(
                    'Pengaturan',
                    Icons.settings,
                    Colors.purple,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                    _buildDashboardCard(
                    'Tambah Pengeluaran',
                    Icons.add_circle,
                    Colors.red,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return Card(
      elevation: 4,
      child: Builder(
        builder: (context) => InkWell(
          onTap: onTap ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur $title segera hadir!')),
                );
              },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: color),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
