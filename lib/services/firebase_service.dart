
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User> signInAnonymously() async {
    final user = _auth.currentUser;
    if (user != null) return user;
    final cred = await _auth.signInAnonymously();
    return cred.user!;
  }

  Stream<List<Expense>> expensesStream() {
    final uid = _auth.currentUser?.uid;
    return _db
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Expense.fromDoc(d)).toList());
  }

  Future<void> addExpense(Expense e) async {
    final uid = _auth.currentUser!.uid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .doc(e.id)
        .set(e.toMap());
  }

  Future<void> deleteExpense(String id) async {
    final uid = _auth.currentUser!.uid;
    await _db.collection('users').doc(uid).collection('expenses').doc(id).delete();
  }
}
