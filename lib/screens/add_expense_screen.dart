import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import '../services/user_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  List<String> _categories = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    final categoryList = ExpenseService.getAllCategories();
    setState(() {
      // langsung ambil data dari service tanpa fallback dummy
      _categories = categoryList.toList();
      _selectedCategory =
          _categories.isNotEmpty ? _categories.first : null; // boleh null
    });
  }

  /// ✅ Fungsi untuk menyimpan data expense
  void _saveExpense() async {
    // Ambil user yang sedang login
    final currentUser = UserService.loggedInUser;

    // Jika belum login, tampilkan pesan
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu!')),
      );
      return;
    }

    // Validasi form
    if (!_formKey.currentState!.validate()) return;

    // Buat objek expense baru, kaitkan dengan user login
    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      category: _selectedCategory ?? 'Lainnya',
      date: _selectedDate,
      description: _descriptionController.text,
      usernameOwner: currentUser.username, // 🔥 penting untuk filter per user
    );

    // Simpan ke service
    await ExpenseService.addExpense(newExpense);
    if (!mounted) return;
    // Tampilkan notifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengeluaran berhasil disimpan!')),
    );

    // Kembali ke halaman sebelumnya
    Navigator.pop(context, newExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pengeluaran"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Judul"),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Judul wajib diisi"
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: "Jumlah"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Jumlah wajib diisi";
                  }
                  if (double.tryParse(value) == null) return "Harus angka";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: "Kategori"),
                items:
                    _categories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                },
              ),

              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Tanggal: ${_selectedDate.toLocal()}".split(' ')[0],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: const Text("Pilih Tanggal"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveExpense,
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
