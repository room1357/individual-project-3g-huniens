import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import 'user_service.dart';

class ExpenseService {
  static Future<void> initialize() async {
    final user = UserService.loggedInUser;
    if (user != null) {
      await _loadExpensesForUser(user.username);
    }
  }

  // In-memory cache (digunakan saat runtime)
  static final List<Expense> _expenses = [];

  // Key prefix di SharedPreferences
  static String _prefsKeyFor(String username) => 'expenses_$username';

  // ✅ Tambah expense (save ke memory + persist)
  static Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    await _saveExpensesForUser(expense.usernameOwner);
  }

  // ✅ Ambil semua expense milik user yang login
  static Future<List<Expense>> getUserExpenses() async {
    final user = UserService.loggedInUser;
    if (user == null) return [];

    await _loadExpensesForUser(user.username);
    return _expenses.where((e) => e.usernameOwner == user.username).toList();
  }

  // ✅ Untuk kompatibilitas dengan screen yang pakai getAll()
  static Future<List<Expense>> getAll() async {
    final user = UserService.loggedInUser;
    if (user == null) return [];
    return await getUserExpenses();
  }

  // ✅ Load semua expense user dari SharedPreferences
  static Future<void> _loadExpensesForUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _prefsKeyFor(username);
    final raw = prefs.getString(key);
    if (raw == null) {
      _expenses.removeWhere((e) => e.usernameOwner == username);
      return;
    }

    final List<dynamic> list = json.decode(raw);
    _expenses.removeWhere((e) => e.usernameOwner == username);
    for (final item in list) {
      final exp = Expense.fromJson(item);
      _expenses.add(exp);
    }
  }

  // ✅ Simpan semua expense user ke SharedPreferences
  static Future<void> _saveExpensesForUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _prefsKeyFor(username);
    final userExpenses =
        _expenses.where((e) => e.usernameOwner == username).toList();
    final jsonList = userExpenses.map((e) => e.toJson()).toList();
    await prefs.setString(key, json.encode(jsonList));
  }

  // ✅ Hapus expense berdasarkan ID
  static Future<void> deleteExpense(String id) async {
    final idx = _expenses.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final username = _expenses[idx].usernameOwner;
    _expenses.removeAt(idx);
    await _saveExpensesForUser(username);
  }

  // ✅ Update expense berdasarkan ID
  static Future<void> updateExpense(String id, Expense updatedExpense) async {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      await _saveExpensesForUser(updatedExpense.usernameOwner);
    }
  }

  // ✅ Ambil semua kategori (dummy dulu)
  static List<String> getAllCategories() {
    return ['Makanan', 'Transportasi', 'Utilitas', 'Hiburan', 'Pendidikan'];
  }

  // ✅ Tambah kategori (placeholder)
  static void addCategory(String category) {
    // nanti bisa disimpan di DB atau prefs
  }

  // ✅ Hapus kategori (placeholder)
  static void deleteCategory(String category) {
    // nanti bisa disimpan di DB atau prefs
  }

  // ✅ (Opsional) Clear semua expense user — mis. saat hapus akun
  static Future<void> clearExpensesForUser(String username) async {
    _expenses.removeWhere((e) => e.usernameOwner == username);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKeyFor(username));
  }

  // ✅ Ambil expense milik user tertentu
  static List<Expense> getExpensesByUser(String username) {
    return _expenses.where((e) => e.usernameOwner == username).toList();
  }
}
