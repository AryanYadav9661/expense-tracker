
import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String id;
  String title;
  double amount;
  String category;
  DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
      };

  factory Expense.fromMap(Map<String, dynamic> m) {
    return Expense(
      id: m['id'] ?? '',
      title: m['title'] ?? '',
      amount: (m['amount'] ?? 0).toDouble(),
      category: m['category'] ?? 'Misc',
      date: DateTime.parse(m['date'] ?? DateTime.now().toIso8601String()),
    );
  }

  factory Expense.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return Expense.fromMap(m);
  }
}
