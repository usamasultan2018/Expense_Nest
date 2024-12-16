import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/components/no_graph_transaction.dart';
import 'package:expense_tracker/components/no_transaction.dart';
import 'package:expense_tracker/utils/helpers/constant.dart';
import 'package:expense_tracker/utils/helpers/geticons.dart';
import 'package:expense_tracker/utils/helpers/shared_preference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/repository/transaction_repository.dart';

class MyPieChartWithLegend extends StatelessWidget {
  final TransactionType transactionType;

  const MyPieChartWithLegend({super.key, required this.transactionType});

  @override
  Widget build(BuildContext context) {
    var user = UserPreferences.getUser();

    if (user == null) {
      return const Center(
        child: Text("User is not logged in."),
      );
    }
    final transactionRepository = TransactionRepository();

    return StreamBuilder<List<TransactionModel>>(
      stream: transactionRepository.getTransactions(user.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const NoGraphTransaction();
        }

        List<TransactionModel> transactions = snapshot.data!;

        transactions = transactions
            .where((transaction) => transaction.type == transactionType)
            .toList();

        if (transactions.isEmpty) {
          return const NoGraphTransaction();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: FadeTransitionEffect(
                child: PieChart(
                  swapAnimationCurve: Curves.bounceOut,
                  PieChartData(
                    sections: _buildPieChartSections(transactions),
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: 60,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLegend(transactions),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
      List<TransactionModel> transactions) {
    final categoryTotals = <String, double>{};

    // Sum the amounts by category
    for (var transaction in transactions) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    final totalSum = categoryTotals.values.fold(0.0, (sum, item) => sum + item);

    // Generate PieChart sections
    return categoryTotals.entries.map((entry) {
      final percentage = (entry.value / totalSum * 100).toStringAsFixed(1);
      return PieChartSectionData(
        value: entry.value,
        title: '$percentage%',
        color: getColorsForTile(entry.key).withOpacity(0.7),
        radius: 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(List<TransactionModel> transactions) {
    final categoryTotals = <String, double>{};

    for (var transaction in transactions) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    // Generate legend items
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categoryTotals.entries.map((entry) {
            return _LegendItem(
              color: getColorsForTile(entry.key),
              label: entry.key,
              amount: entry.value,
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Custom widget for a legend item
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final double amount;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
