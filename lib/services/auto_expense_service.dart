
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../utils/notification_parser.dart';

class AutoExpenseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> processNotificationAndSave(String text, String uid) async {
    final amount = NotificationParser.extractAmount(text) ?? 0.0;
    if (amount <= 0) return;
    final category = NotificationParser.categorize(text);
    final id = Uuid().v4();

    final e = Expense(id: id, title: text.length>40?text.substring(0,40):text, amount: amount, category: category, date: DateTime.now());

    await _db.collection('users').doc(uid).collection('expenses').doc(id).set({
      'id': e.id,
      'title': e.title,
      'amount': e.amount,
      'category': e.category,
      'date': FieldValue.serverTimestamp(),
    });
  }
}
