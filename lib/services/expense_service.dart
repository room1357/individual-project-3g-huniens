import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import '../models/category.dart';

class ExpenseService {
  static final List<Expense> _expenses = [];

  // 🔹 Load data dari shared preferences saat app dibuka
  static Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('expenses');

    if (data != null) {
      final decoded = jsonDecode(data) as List;
      _expenses.clear();
      _expenses.addAll(decoded.map((e) => Expense.fromJson(e)));
    }
  }

  // 🔹 Simpan data ke shared preferences
  static Future<void> saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_expenses.map((e) => e.toJson()).toList());
    await prefs.setString('expenses', encoded);
  }

  // 🔹 Tambah expense baru dan langsung simpan
  static void addExpense(Expense expense) {
    _expenses.add(expense);
    saveExpenses();
  }

  static List<Expense> getAll() => List.unmodifiable(_expenses);

  static void updateExpense(String id, Expense updatedExpense) {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      saveExpenses();
    }
  }

  static void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    saveExpenses();
  }

  // 🔹 Kategori default
  static final List<Category> _categories = [
    Category(id: '1', name: 'Makanan'),
    Category(id: '2', name: 'Transportasi'),
    Category(id: '3', name: 'Utilitas'),
    Category(id: '4', name: 'Hiburan'),
    Category(id: '5', name: 'Pendidikan'),
  ];

  static List<Category> getAllCategories() => List.unmodifiable(_categories);

    // Tambah kategori baru
  static void addCategory(Category category) {
    _categories.add(category);
  }

  // Hapus kategori
  static void deleteCategory(String id) {
    _categories.removeWhere((cat) => cat.id == id);
  }

  // 🟢 Fungsi untuk mengisi data awal (opsional)
  static void seed(List<Expense> data) {
    _expenses.clear();
    _expenses.addAll(data);
  }

}
