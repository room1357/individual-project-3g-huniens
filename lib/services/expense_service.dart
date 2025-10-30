import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import 'user_service.dart';

class ExpenseService {
  static Future<void> initialize() async {
    final user = UserService.loggedInUser;
    if (user != null) {
      _expenses.clear(); // clear data lama
      await _loadExpensesForUser(user.username);
      await _loadCategoriesForUser(user.username); // ✅ load kategori user
    }
  }

  // Cache in-memory
  static final List<Expense> _expenses = [];
  static final Map<String, List<String>> _userCategories = {}; // ✅ per user

  static String _prefsKeyFor(String username) => 'expenses_$username';
  static String _categoryKeyFor(String username) => 'categories_$username'; // ✅

  // ===================== EXPENSE SECTION =====================

  static Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    await _saveExpensesForUser(expense.usernameOwner);
  }

  static Future<List<Expense>> getUserExpenses() async {
    final user = UserService.loggedInUser;
    if (user == null) return [];
    await _loadExpensesForUser(user.username);
    return _expenses.where((e) => e.usernameOwner == user.username).toList();
  }

  static Future<List<Expense>> getAll() async {
    final user = UserService.loggedInUser;
    if (user == null) return [];
    await _loadExpensesForUser(user.username);
    return _expenses.where((e) => e.usernameOwner == user.username).toList();
  }

  static Future<void> _loadExpensesForUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _prefsKeyFor(username);
    final raw = prefs.getString(key);

    _expenses.removeWhere((e) => e.usernameOwner == username);
    if (raw != null) {
      final List<dynamic> list = json.decode(raw);
      for (final item in list) {
        final exp = Expense.fromJson(item);
        _expenses.add(exp);
      }
    }
  }

  static Future<void> _saveExpensesForUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _prefsKeyFor(username);
    final userExpenses =
        _expenses.where((e) => e.usernameOwner == username).toList();
    final jsonList = userExpenses.map((e) => e.toJson()).toList();
    await prefs.setString(key, json.encode(jsonList));
  }

  static Future<void> deleteExpense(String id) async {
    final idx = _expenses.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final username = _expenses[idx].usernameOwner;
    _expenses.removeAt(idx);
    await _saveExpensesForUser(username);
  }

  static Future<void> updateExpense(String id, Expense updatedExpense) async {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      await _saveExpensesForUser(updatedExpense.usernameOwner);
    }
  }

  // ===================== CATEGORY SECTION =====================

  // ✅ Ambil semua kategori milik user
  static List<String> getAllCategories() {
    final user = UserService.loggedInUser;
    if (user == null) return [];
    return _userCategories[user.username] ?? _defaultCategories;
  }

  // ✅ Kategori default (kalau user baru)
  static const List<String> _defaultCategories = [
    'Makanan',
    'Transportasi',
    'Utilitas',
    'Hiburan',
    'Pendidikan',
  ];

  // ✅ Tambah kategori baru
  static Future<void> addCategory(String category) async {
    final user = UserService.loggedInUser;
    if (user == null) return;

    final username = user.username;
    final categories = _userCategories.putIfAbsent(username, () => []);
    if (!categories.contains(category)) {
      categories.add(category);
      await _saveCategoriesForUser(username);
    }
  }

  // ✅ Hapus kategori
  static Future<void> deleteCategory(String category) async {
    final user = UserService.loggedInUser;
    if (user == null) return;

    final username = user.username;
    final categories = _userCategories[username];
    if (categories != null && categories.contains(category)) {
      categories.remove(category);
      await _saveCategoriesForUser(username);
    }
  }

  // ✅ Simpan kategori user
  static Future<void> _saveCategoriesForUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _categoryKeyFor(username);
    final categories = _userCategories[username] ?? [];
    await prefs.setString(key, json.encode(categories));
  }

  // ✅ Load kategori user
  static Future<void> _loadCategoriesForUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _categoryKeyFor(username);
    final raw = prefs.getString(key);

    if (raw == null) {
      // 🔥 Awal kosong (tidak set default)
      _userCategories[username] = [];
      await _saveCategoriesForUser(username);
      return;
    }

    final List<dynamic> list = json.decode(raw);
    _userCategories[username] = List<String>.from(list);
  }

  // ===================== UTILITIES =====================

  static Future<void> clearExpensesForUser(String username) async {
    _expenses.removeWhere((e) => e.usernameOwner == username);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKeyFor(username));
    await prefs.remove(_categoryKeyFor(username)); // ✅ clear kategori juga
  }

  static List<Expense> getExpensesByUser(String username) {
    return _expenses.where((e) => e.usernameOwner == username).toList();
  }
}
