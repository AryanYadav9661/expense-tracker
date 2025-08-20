import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/expense_provider.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ExpenseProvider>(context);
    final items = prov.items;

    final Map<String, double> catSum = {};
    for (var e in items) {
      catSum[e.category] = (catSum[e.category] ?? 0) + e.amount;
    }

    final spots = catSum.entries
        .map((e) => PieChartSectionData(
            value: e.value, title: '${e.key}\n₹${e.value.toStringAsFixed(0)}'))
        .toList();

    final now = DateTime.now();
    final months = List.generate(6, (i) => DateTime(now.year, now.month - i));
    final List<BarChartGroupData> bars = [];
    for (int i = 0; i < months.length; i++) {
      final m = months[i];
      final sum = items
          .where((e) => e.date.year == m.year && e.date.month == m.month)
          .fold(0.0, (s, k) => s + k.amount);
      bars.add(BarChartGroupData(x: i, barRods: [BarChartRodData(toY: sum)]));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Charts')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                  child: SizedBox(
                      height: 250,
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: PieChart(PieChartData(sections: spots))))),
              const SizedBox(height: 20),
              Card(
                  child: SizedBox(
                      height: 300,
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: BarChart(BarChartData(barGroups: bars))))),
            ],
          ),
        ),
      ),
    );
  }
}
