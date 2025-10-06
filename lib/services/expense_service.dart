import '../models/expense.dart';
import '../models/category.dart';


class ExpenseService {
  // Simpan data sementara (in-memory)
  static final List<Expense> _expenses = [];

  // Ambil semua data (read-only)
  static List<Expense> getAll() => List.unmodifiable(_expenses);

  // Tambah expense baru
  static void addExpense(Expense expense) {
    _expenses.add(expense);
  }

  // Update expense berdasarkan id
  static void updateExpense(String id, Expense updatedExpense) {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
    }
  }

  // Hapus expense berdasarkan id
  static void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
  }

  // Cari expense berdasarkan id
  static Expense? findById(String id) {
    try {
      return _expenses.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  // (Opsional) Isi data awal (seed)
  static void seed(List<Expense> data) {
    _expenses.clear();
    _expenses.addAll(data);
  }

    static final List<Category> _categories = [
    Category(id: '1', name: 'Makanan'),
    Category(id: '2', name: 'Transportasi'),
    Category(id: '3', name: 'Utilitas'),
    Category(id: '4', name: 'Hiburan'),
    Category(id: '5', name: 'Pendidikan'),
  ];

  // Ambil semua kategori
  static List<Category> getAllCategories() => List.unmodifiable(_categories);

  // Tambah kategori baru
  static void addCategory(Category category) {
    _categories.add(category);
  }

  // Hapus kategori
  static void deleteCategory(String id) {
    _categories.removeWhere((cat) => cat.id == id);
  }

  // Update kategori
  static void updateCategory(String id, String newName) {
    final index = _categories.indexWhere((cat) => cat.id == id);
    if (index != -1) {
      _categories[index] = Category(id: id, name: newName);
    }
  }
}
