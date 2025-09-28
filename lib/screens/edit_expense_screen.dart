import 'package:flutter/material.dart';
import '../models/expense.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _descriptionController =
        TextEditingController(text: widget.expense.description);
    _selectedCategory = widget.expense.category;
    _selectedDate = widget.expense.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
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

  void _saveExpense() {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan jumlah tidak boleh kosong')),
      );
      return;
    }

    final updatedExpense = Expense(
      id: widget.expense.id,
      title: _titleController.text,
      amount: double.tryParse(_amountController.text) ?? 0,
      category: _selectedCategory,
      date: _selectedDate,
      description: _descriptionController.text,
    );

    Navigator.pop(context, updatedExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pengeluaran'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: const [
                  'Makanan',
                  'Transportasi',
                  'Utilitas',
                  'Hiburan',
                  'Pendidikan',
                ].map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                      "Tanggal: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                  const Spacer(),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text("Pilih Tanggal"),
                  )
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveExpense,
                child: const Text("Simpan Perubahan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
