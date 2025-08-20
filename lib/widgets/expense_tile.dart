import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class ExpenseTile extends StatefulWidget {
  final Expense expense;
  const ExpenseTile({super.key, required this.expense});

  @override
  State<ExpenseTile> createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _colorForCategory(String c) {
    switch (c) {
      case 'Food':
        return const Color(0xFFFFC107);
      case 'Transport':
        return const Color(0xFF4CAF50);
      case 'Study':
        return const Color(0xFF673AB7);
      case 'Health':
        return const Color(0xFFEF5350);
      case 'Recharge':
        return const Color(0xFF29B6F6);
      default:
        return const Color(0xFF90A4AE);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expense = widget.expense;
    final color = _colorForCategory(expense.category);

    return FadeTransition(
      opacity: CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
      child: ScaleTransition(
        scale: CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
        child: Dismissible(
          key: ValueKey(expense.id),
          background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.delete, color: Colors.white)),
          direction: DismissDirection.startToEnd,
          onDismissed: (_) =>
              Provider.of<ExpenseProvider>(context, listen: false)
                  .delete(expense.id),
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(expense.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                        '₹${expense.amount.toStringAsFixed(2)} · ${expense.category}'),
                    const SizedBox(height: 12),
                    Text(DateFormat.yMMMd().format(expense.date)),
                  ]),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  color.withValues(alpha: 0.14),
                  color.withValues(alpha: 0.04)
                ]),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.5)),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: color,
                      child: Text(expense.category[0],
                          style: const TextStyle(color: Colors.white))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(expense.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(DateFormat.yMMMd().format(expense.date),
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('₹${expense.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.withValues(alpha: 0.9))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
