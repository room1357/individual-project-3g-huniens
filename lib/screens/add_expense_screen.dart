import 'package:flutter/material.dart';
import '../models/expense.dart';
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

  String _selectedCategory = 'Makanan';
  DateTime _selectedDate = DateTime.now();

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
        description: _descriptionController.text,
      );

      ExpenseService.addExpense(expense);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pengeluaran berhasil ditambahkan")),
      );

      Navigator.pop(context);
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pengeluaran"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  if (double.tryParse(value) == null) return "Masukkan angka valid";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ["Makanan", "Transportasi", "Utilitas", "Hiburan", "Pendidikan"]
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Kategori"),
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
                    child: Text("Tanggal: ${_selectedDate.toLocal()}".split(' ')[0]),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text("Pilih Tanggal"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
