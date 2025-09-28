import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../screens/edit_expense_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  // Data sample menggunakan List<Expense>
  final List<Expense> expenses = [
    Expense(
      id: '1',
      title: 'Belanja Bulanan',
      amount: 150000,
      category: 'Makanan',
      date: DateTime(2024, 9, 15),
      description: 'Belanja kebutuhan bulanan di supermarket',
    ),
    Expense(
      id: '2',
      title: 'Bensin Motor',
      amount: 50000,
      category: 'Transportasi',
      date: DateTime(2024, 9, 14),
      description: 'Isi bensin motor untuk transportasi',
    ),
    Expense(
      id: '3',
      title: 'Kopi di Cafe',
      amount: 25000,
      category: 'Makanan',
      date: DateTime(2024, 9, 14),
      description: 'Ngopi pagi dengan teman',
    ),
    Expense(
      id: '4',
      title: 'Tagihan Internet',
      amount: 300000,
      category: 'Utilitas',
      date: DateTime(2024, 9, 13),
      description: 'Tagihan internet bulanan',
    ),
    Expense(
      id: '5',
      title: 'Tiket Bioskop',
      amount: 100000,
      category: 'Hiburan',
      date: DateTime(2024, 9, 12),
      description: 'Nonton film weekend bersama keluarga',
    ),
    Expense(
      id: '6',
      title: 'Beli Buku',
      amount: 75000,
      category: 'Pendidikan',
      date: DateTime(2024, 9, 11),
      description: 'Buku pemrograman untuk belajar',
    ),
    Expense(
      id: '7',
      title: 'Makan Siang',
      amount: 35000,
      category: 'Makanan',
      date: DateTime(2024, 9, 11),
      description: 'Makan siang di restoran',
    ),
    Expense(
      id: '8',
      title: 'Ongkos Bus',
      amount: 10000,
      category: 'Transportasi',
      date: DateTime(2024, 9, 10),
      description: 'Ongkos perjalanan harian ke kampus',
    ),
  ];

  List<Expense> filteredExpenses = [];
  String selectedCategory = 'Semua';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredExpenses = expenses; // default tampil semua
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengeluaran'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // 🔎 Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Cari pengeluaran...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _filterExpenses(),
            ),
          ),

          // 🔖 Category filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['Semua', 'Makanan', 'Transportasi', 'Utilitas', 'Hiburan', 'Pendidikan']
                  .map((category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                              _filterExpenses();
                            });
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),

          // 📊 Statistik
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', _calculateTotal(filteredExpenses)),
                _buildStatCard('Jumlah', '${filteredExpenses.length} item'),
                _buildStatCard('Rata-rata', _calculateAverage(filteredExpenses)),
              ],
            ),
          ),

          // 📋 ListView
          Expanded(
            child: filteredExpenses.isEmpty
                ? const Center(child: Text('Tidak ada pengeluaran ditemukan'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(expense.category),
                            child: Icon(
                              _getCategoryIcon(expense.category),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            expense.title,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text('${expense.category} • ${expense.formattedDate}'),
                          trailing: Text(
                            expense.formattedAmount,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red[600],
                            ),
                          ),
                          onTap: () => _showExpenseDetails(context, expense),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 🔹 Filter data
  void _filterExpenses() {
    setState(() {
      filteredExpenses = expenses.where((expense) {
        bool matchesSearch = searchController.text.isEmpty ||
            expense.title.toLowerCase().contains(searchController.text.toLowerCase()) ||
            expense.description.toLowerCase().contains(searchController.text.toLowerCase());

        bool matchesCategory = selectedCategory == 'Semua' || expense.category == selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  // 🔹 Statistik card
  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

String _calculateTotal(List<Expense> expenses) {
  double total = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  return 'Rp ${total.toStringAsFixed(0)}';
}

String _calculateAverage(List<Expense> expenses) {
  if (expenses.isEmpty) return 'Rp 0';
  double avg = expenses.fold(0.0, (sum, expense) => sum + expense.amount) / expenses.length;
  return 'Rp ${avg.toStringAsFixed(0)}';
}


  // 🔹 Helper kategori
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Colors.orange;
      case 'transportasi':
        return Colors.green;
      case 'utilitas':
        return Colors.purple;
      case 'hiburan':
        return Colors.pink;
      case 'pendidikan':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Icons.restaurant;
      case 'transportasi':
        return Icons.directions_car;
      case 'utilitas':
        return Icons.home;
      case 'hiburan':
        return Icons.movie;
      case 'pendidikan':
        return Icons.school;
      default:
        return Icons.attach_money;
    }
  }

  // 🔹 Dialog detail
void _showExpenseDetails(BuildContext context, Expense expense) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(expense.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Jumlah: ${expense.formattedAmount}'),
          const SizedBox(height: 8),
          Text('Kategori: ${expense.category}'),
          const SizedBox(height: 8),
          Text('Tanggal: ${expense.formattedDate}'),
          const SizedBox(height: 8),
          Text('Deskripsi: ${expense.description}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context); // tutup dialog dulu
            final updatedExpense = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditExpenseScreen(expense: expense),
              ),
            );

            if (updatedExpense != null) {
              setState(() {
                final index = expenses.indexWhere((e) => e.id == updatedExpense.id);
                if (index != -1) {
                  expenses[index] = updatedExpense;
                  _filterExpenses(); // refresh tampilan
                }
              });
            }
          },
          child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}
