
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../services/firebase_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final FirebaseService _fs;
  List<Expense> _items = [];

  ExpenseProvider(this._fs);

  List<Expense> get items => _items;

  void setItems(List<Expense> items) {
    _items = items;
    notifyListeners();
  }

  double get total => _items.fold(0.0, (s, e) => s + e.amount);

  Future<void> add(String title, double amount, String category, DateTime date) async {
    final id = const Uuid().v4();
    final e = Expense(id: id, title: title, amount: amount, category: category, date: date);
    await _fs.addExpense(e);
  }

  Future<void> delete(String id) async {
    await _fs.deleteExpense(id);
  }
}
