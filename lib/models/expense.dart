import 'package:intl/intl.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String description;
  final String usernameOwner;

  // 🆕 Tambahan untuk fitur Shared Expense
  final List<String> sharedWith; // daftar orang yang diajak patungan
  final bool isShared; // apakah ini pengeluaran bersama

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
    required this.usernameOwner,
    this.sharedWith = const [],
    this.isShared = false,
  });

  String get formattedDate => DateFormat('dd MMM yyyy').format(date);
  String get formattedAmount =>
      NumberFormat.currency(locale: 'id', symbol: 'Rp').format(amount);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
        'description': description,
        'usernameOwner': usernameOwner,
        'sharedWith': sharedWith, // 🆕
        'isShared': isShared, // 🆕
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['id'],
        title: json['title'],
        amount: (json['amount'] as num).toDouble(),
        category: json['category'],
        date: DateTime.parse(json['date']),
        description: json['description'],
        usernameOwner: json['usernameOwner'],
        sharedWith: List<String>.from(json['sharedWith'] ?? []), // 🆕
        isShared: json['isShared'] ?? false, // 🆕
      );
}
