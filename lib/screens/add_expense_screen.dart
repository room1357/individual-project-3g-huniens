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

  // 🔥 Tambahan untuk fitur Shared Expense
  bool _isShared = false;
  List<String> _selectedUsers = [];
  List<String> _allUsers = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadUsers();
  }

  void _loadCategories() {
    final categoryList = ExpenseService.getAllCategories();
    setState(() {
      _categories = categoryList.toList();
      _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
    });
  }

  // 🔥 Ambil semua user yang terdaftar
  void _loadUsers() {
    final users = UserService.getAllUsernames();
    final currentUser = UserService.loggedInUser?.username;
    setState(() {
      _allUsers = users.where((u) => u != currentUser).toList();
    });
  }

  /// ✅ Fungsi untuk menyimpan data expense
  void _saveExpense() async {
    final currentUser = UserService.loggedInUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu!')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    // 🔥 Buat objek expense baru
    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      category: _selectedCategory ?? 'Lainnya',
      date: _selectedDate,
      description: _descriptionController.text,
      usernameOwner: currentUser.username,
      isShared: _isShared,
      sharedWith: _selectedUsers,
    );

    // Simpan ke service
    await ExpenseService.addExpense(newExpense);

    // 🔥 Kalau bukan shared, simpan ke expense pribadi
    if (!_isShared) {
      await ExpenseService.addExpense(newExpense);
    } else {
      // ✅ Kalau shared, simpan ke shared_expenses_<username>
      await ExpenseService.addSharedExpense(newExpense);

      // 🔥 Simpan juga ke akun teman yang ikut patungan
      if (_selectedUsers.isNotEmpty) {
        for (final friend in _selectedUsers) {
          final sharedCopy = Expense(
            id: newExpense.id,
            title: newExpense.title,
            amount: newExpense.amount / (_selectedUsers.length + 1),
            category: newExpense.category,
            date: newExpense.date,
            description:
                "${newExpense.description} (Patungan bareng ${currentUser.username})",
            usernameOwner: friend,
            isShared: true,
            sharedWith: [currentUser.username, ..._selectedUsers],
          );
          // ✅ simpan di folder shared juga
          await ExpenseService.addExpense(sharedCopy);
        }
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengeluaran berhasil disimpan!')),
    );
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
                value: _selectedCategory,
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

              // 🔥 Shared Expense Toggle
              SwitchListTile(
                title: const Text("Shared Expense (Patungan)"),
                value: _isShared,
                onChanged: (value) {
                  setState(() => _isShared = value);
                },
              ),

              // 🔥 Daftar user yang bisa dipilih
              if (_isShared && _allUsers.isNotEmpty) ...[
                const Text("Pilih teman yang ikut patungan:"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children:
                      _allUsers
                          .map(
                            (u) => FilterChip(
                              label: Text(u),
                              selected: _selectedUsers.contains(u),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedUsers.add(u);
                                  } else {
                                    _selectedUsers.remove(u);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                ),
              ],

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
