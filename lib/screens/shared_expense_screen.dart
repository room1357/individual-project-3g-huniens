import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import '../services/user_service.dart';

class SharedExpenseScreen extends StatefulWidget {
  const SharedExpenseScreen({super.key});

  @override
  State<SharedExpenseScreen> createState() => _SharedExpenseScreenState();
}

class _SharedExpenseScreenState extends State<SharedExpenseScreen> {
  List<Expense> sharedExpenses = [];

  @override
  void initState() {
    super.initState();
    _loadSharedExpenses();
  }

  Future<void> _loadSharedExpenses() async {
    final shared = await ExpenseService.getSharedExpenses();
    setState(() {
      sharedExpenses = shared;
    });
  }

  Future<void> _showAddSharedExpenseDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();

    final currentUser = UserService.loggedInUser;
    if (currentUser == null) return;

    // Ambil kategori & users (synchronous sesuai implementasimu)
    final categories = ExpenseService.getAllCategories();
    final allUsers = UserService.getAllUsernames();
    final selectableUsers = allUsers.where((u) => u != currentUser.username).toList();

    String selectedCategory = categories.isNotEmpty ? categories.first : 'Umum';
    final List<String> selectedUsers = [];

    await showDialog(
      context: context,
      builder: (context) {
        // gunakan StatefulBuilder supaya state lokal dialog bisa berubah (selected users/category)
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Tambah Shared Expense'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Judul Pengeluaran'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
                  ),
                  const SizedBox(height: 12),
                  // Dropdown kategori berdasarkan data dari ExpenseService
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: (categories.isNotEmpty ? categories : ['Umum'])
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setStateDialog(() => selectedCategory = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  // Multi-select chips untuk pilih user
                  if (selectableUsers.isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Pilih teman yang ikut (tap untuk pilih):'),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: selectableUsers.map((u) {
                        final selected = selectedUsers.contains(u);
                        return FilterChip(
                          label: Text(u),
                          selected: selected,
                          onSelected: (val) {
                            setStateDialog(() {
                              if (val) {
                                selectedUsers.add(u);
                              } else {
                                selectedUsers.remove(u);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ] else
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('Belum ada user lain terdaftar.'),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Batal'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text('Simpan'),
                onPressed: () async {
                  final title = titleController.text.trim();
                  final desc = descriptionController.text.trim();
                  final amountText = amountController.text.trim();

                  if (title.isEmpty || amountText.isEmpty) {
                    // kamu bisa ganti dengan validasi lebih bagus
                    return;
                  }

                  final amount = double.tryParse(amountText) ?? 0;

                  // Buat objek Expense (nominal tetap sama, tidak dibagi)
                  final newExpense = Expense(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    description: desc,
                    amount: amount,
                    category: selectedCategory.isEmpty ? 'Umum' : selectedCategory,
                    date: DateTime.now(),
                    usernameOwner: currentUser.username,
                    isShared: true,
                    sharedWith: List<String>.from(selectedUsers),
                  );

                  // Simpan shared expense (akan tersimpan di shared_expenses_<user>)
                  await ExpenseService.addSharedExpense(newExpense);

                  // Tutup dialog dan refresh list
                  Navigator.pop(context);
                  await _loadSharedExpenses();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Expenses"),
        backgroundColor: Colors.teal,
      ),
      body: RefreshIndicator(
        onRefresh: _loadSharedExpenses,
        child: sharedExpenses.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada pengeluaran bersama.',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: sharedExpenses.length,
                itemBuilder: (context, index) {
                  final expense = sharedExpenses[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: const Icon(Icons.group, color: Colors.white),
                      ),
                      title: Text(expense.title),
                      subtitle: Text(
                        "${expense.category} • ${expense.formattedDate}\n"
                        "Dibuat oleh: ${expense.usernameOwner}\n"
                        "Dibagikan ke: ${expense.sharedWith.join(', ')}",
                      ),
                      trailing: Text(
                        expense.formattedAmount,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSharedExpenseDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
