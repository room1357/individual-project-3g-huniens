class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String description;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });

  // 🔹 Format tampilan mata uang
  String get formattedAmount => 'Rp ${amount.toStringAsFixed(0)}';

  // 🔹 Format tampilan tanggal
  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  // 🔹 Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  // 🔹 Buat object dari JSON
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}
