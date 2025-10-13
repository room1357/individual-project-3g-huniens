import 'package:flutter/material.dart';
import '../models/expense.dart';
//import '../models/category.dart';
import '../services/expense_service.dart';


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
    // Ambil kategori dari ExpenseService
    final categoryList = ExpenseService.getAllCategories();

    setState(() {
      _categories = categoryList.isEmpty
          ? ['Makanan', 'Transportasi', 'Utilitas', 'Hiburan', 'Pendidikan']
          : categoryList.map((c) => c.name).toList();

      _selectedCategory = _categories.first;
    });
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
                validator: (value) =>
                    value == null || value.isEmpty ? "Judul wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: "Jumlah"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Jumlah wajib diisi";
                  if (double.tryParse(value) == null) return "Harus angka";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 🔽 Dropdown kategori yang sudah dinamis
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: "Kategori"),
                items: _categories
                    .map((cat) =>
                        DropdownMenuItem(value: cat, child: Text(cat)))
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
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newExpense = Expense(
                      id: DateTime.now().toString(),
                      title: _titleController.text,
                      amount: double.parse(_amountController.text),
                      category: _selectedCategory!,
                      date: _selectedDate,
                      description: _descriptionController.text,
                    );

                    // 🟢 Tambahkan baris ini biar data masuk ke service
                    ExpenseService.addExpense(newExpense);

                    Navigator.pop(context, newExpense);
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
