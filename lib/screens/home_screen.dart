import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../services/firebase_service.dart';
import '../services/ad_service.dart';
import '../widgets/expense_tile.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/notification_bridge.dart';
import '../services/auto_expense_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late FirebaseService _fs;
  bool _loading = true;
  late BannerAd _banner;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _fabController;
  final AutoExpenseService _auto = AutoExpenseService();

  @override
  void initState() {
    super.initState();
    _fs = FirebaseService();
    _fabController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _init();
    NotificationBridge.init((text, pkg) async {
      // when native notifies, process and save
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await _auto.processNotificationAndSave(text, uid);
      }
    });
  }

  Future<void> _init() async {
    await _fs.signInAnonymously();
    _fs.expensesStream().listen((list) {
      final prov = Provider.of<ExpenseProvider>(context, listen: false);
      prov.setItems(list);
      setState(() => _loading = false);
    });
    _banner = AdService().createBannerAd()..load();
  }

  @override
  void dispose() {
    try {
      _banner.dispose();
    } catch (_) {}
    _fabController.dispose();
    super.dispose();
  }

  void _openAddDialog() {
    _fabController.forward().then((_) => _fabController.reverse());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: AddExpenseForm(onAdd: (title, amount, category, date) {
          Provider.of<ExpenseProvider>(context, listen: false)
              .add(title, amount, category, date);
          Navigator.pop(ctx);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF5B8CFF), Color(0xFF8BD5FF)]),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black..withValues(alpha: 0.8),
                      blurRadius: 10,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Spent',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 6),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: prov.total),
                            duration: const Duration(milliseconds: 700),
                            builder: (context, value, child) {
                              return Text('₹${value.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold));
                            },
                          ),
                        ],
                      ),
                      CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white.withValues(alpha: 0.6),
                          child: const Icon(Icons.person, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        'All',
                        'Food',
                        'Transport',
                        'Study',
                        'Health',
                        'Recharge'
                      ]
                          .map((c) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOutCubic,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(c,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _openAddDialog,
                      child: ScaleTransition(
                        scale: Tween(begin: 1.0, end: 0.98).animate(
                            CurvedAnimation(
                                parent: _fabController, curve: Curves.easeOut)),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xFF5B8CFF), Color(0xFF8BD5FF)]),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue.withValues(alpha: 0.18),
                                  blurRadius: 8,
                                  offset: const Offset(0, 6))
                            ],
                          ),
                          child: const Center(
                              child: Text('Add Expense',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text('Recent Expenses',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _loading
                          ? const Center(child: CircularProgressIndicator())
                          : prov.items.isEmpty
                              ? const Center(
                                  child: Text(
                                      'No expenses yet. Start by adding one!'))
                              : AnimatedList(
                                  key: _listKey,
                                  initialItemCount: prov.items.length,
                                  itemBuilder: (ctx, i, anim) {
                                    final e = prov.items[i];
                                    return SizeTransition(
                                      sizeFactor: anim,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        child: ExpenseTile(expense: e),
                                      ),
                                    );
                                  },
                                ),
                    ),
                    SizedBox(
                      height: 50,
                      child: AdWidget(ad: _banner),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.9).animate(
            CurvedAnimation(parent: _fabController, curve: Curves.easeOut)),
        child: FloatingActionButton(
          onPressed: _openAddDialog,
          elevation: 8,
          backgroundColor: const Color(0xFF5B8CFF),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class AddExpenseForm extends StatefulWidget {
  final void Function(String, double, String, DateTime) onAdd;
  const AddExpenseForm({super.key, required this.onAdd});

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  String _category = 'Misc';
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title')),
          TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount')),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _category,
                  items: const [
                    DropdownMenuItem(value: 'Misc', child: Text('Misc')),
                    DropdownMenuItem(value: 'Food', child: Text('Food')),
                    DropdownMenuItem(
                        value: 'Transport', child: Text('Transport')),
                    DropdownMenuItem(value: 'Study', child: Text('Study')),
                  ],
                  onChanged: (v) => setState(() => _category = v ?? 'Misc'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final d = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now());
                  if (d != null) setState(() => _date = d);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final t = _title.text.trim();
              final a = double.tryParse(_amount.text) ?? 0;
              if (t.isEmpty || a <= 0) return;
              widget.onAdd(t, a, _category, _date);
            },
            child: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }
}
