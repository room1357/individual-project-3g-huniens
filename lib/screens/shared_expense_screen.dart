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

    final categories = ExpenseService.getAllCategories();
    final allUsers = UserService.getAllUsernames();
    final selectableUsers =
        allUsers.where((u) => u != currentUser.username).toList();

    String selectedCategory = categories.isNotEmpty ? categories.first : 'Umum';
    final List<String> selectedUsers = [];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.group_add_rounded,
                      color: Colors.deepPurple.shade400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Tambah Patungan',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Judul',
                        prefixIcon: Icon(
                          Icons.title_rounded,
                          color: Colors.deepPurple.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.deepPurple.shade400,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                        prefixIcon: Icon(
                          Icons.description_rounded,
                          color: Colors.deepPurple.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.deepPurple.shade400,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Jumlah (Rp)',
                        prefixIcon: Icon(
                          Icons.attach_money_rounded,
                          color: Colors.deepPurple.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.deepPurple.shade400,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        prefixIcon: Icon(
                          Icons.category_rounded,
                          color: Colors.deepPurple.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.deepPurple.shade400,
                            width: 2,
                          ),
                        ),
                      ),
                      items: (categories.isNotEmpty ? categories : ['Umum'])
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setStateDialog(() => selectedCategory = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    if (selectableUsers.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              Icons.people_rounded,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Pilih teman yang ikut:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectableUsers.map((u) {
                          final selected = selectedUsers.contains(u);
                          return FilterChip(
                            label: Text(u),
                            selected: selected,
                            selectedColor: Colors.deepPurple.shade100,
                            checkmarkColor: Colors.deepPurple.shade600,
                            backgroundColor: Colors.grey.shade100,
                            labelStyle: TextStyle(
                              color: selected
                                  ? Colors.deepPurple.shade600
                                  : Colors.grey.shade700,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Belum ada user lain terdaftar.',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final desc = descriptionController.text.trim();
                    final amountText = amountController.text.trim();

                    if (title.isEmpty || amountText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Judul dan jumlah wajib diisi'),
                          backgroundColor: Colors.deepPurple,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    final amount = double.tryParse(amountText) ?? 0;

                    final newExpense = Expense(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: title,
                      description: desc,
                      amount: amount,
                      category:
                          selectedCategory.isEmpty ? 'Umum' : selectedCategory,
                      date: DateTime.now(),
                      usernameOwner: currentUser.username,
                      isShared: true,
                      sharedWith: List<String>.from(selectedUsers),
                    );

                    await ExpenseService.addSharedExpense(newExpense);

                    if (!context.mounted) return;

                    Navigator.pop(context);
                    _loadSharedExpenses();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Patungan berhasil ditambahkan'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shared Expenses',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Pengeluaran patungan',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content Container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: RefreshIndicator(
                    onRefresh: _loadSharedExpenses,
                    color: Colors.deepPurple.shade400,
                    child: sharedExpenses.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.group_rounded,
                                  size: 64,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Belum ada pengeluaran bersama',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: sharedExpenses.length,
                            itemBuilder: (context, index) {
                              final expense = sharedExpenses[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: Colors.purple.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              Icons.group_rounded,
                                              color: Colors.deepPurple.shade400,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  expense.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  '${expense.category} • ${expense.formattedDate}',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            expense.formattedAmount,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.red.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.person_rounded,
                                                  size: 14,
                                                  color: Colors.purple.shade600,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Dibuat oleh: ${expense.usernameOwner}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        Colors.purple.shade600,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.people_rounded,
                                                  size: 14,
                                                  color: Colors.purple.shade600,
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    'Dengan: ${expense.sharedWith.join(", ")}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors
                                                          .purple.shade600,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSharedExpenseDialog,
        backgroundColor: Colors.deepPurple.shade400,
        child: const Icon(Icons.add),
      ),
    );
  }
}