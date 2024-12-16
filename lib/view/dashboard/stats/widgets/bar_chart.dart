import 'package:expense_tracker/components/no_graph_transaction.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/utils/helpers/constant.dart';
import 'package:expense_tracker/utils/helpers/shared_preference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/repository/transaction_repository.dart';

class MyBarChart extends StatefulWidget {
  final TransactionType transactionType;

  const MyBarChart({super.key, required this.transactionType});

  @override
  State<MyBarChart> createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
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

        List<TransactionModel> transactions = snapshot.data!
            .where((transaction) => transaction.type == widget.transactionType)
            .toList();

        if (transactions.isEmpty) {
          return const NoGraphTransaction();
        }

        return Padding(
          padding: const EdgeInsets.all(10),
          child: BarChart(
            _mainData(transactions),
          ),
        );
      },
    );
  }

  BarChartData _mainData(List<TransactionModel> transactions) {
    // Find the maximum value in the data to set maxY dynamically
    double maxAmount = transactions.fold(
        0.0,
        (max, transaction) =>
            (transaction.amount > max) ? transaction.amount : max);

    return BarChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) => const FlLine(
          color: Color(0xff37434d),
          strokeWidth: 0.5,
        ),
      ),
      titlesData: _titlesData(),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      maxY: maxAmount * 1.8,
      barGroups: _getBarChartGroups(transactions),
    );
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTitlesWidget: (value, meta) {
            List<String> daysOfWeek = [
              'Mon',
              'Tue',
              'Wed',
              'Thu',
              'Fri',
              'Sat',
              'Sun'
            ];
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text(
                daysOfWeek[value.toInt()],
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  List<BarChartGroupData> _getBarChartGroups(
      List<TransactionModel> transactions) {
    Map<int, double> dailyTotals = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};
    for (var transaction in transactions) {
      int weekday = transaction.date.weekday - 1; // Weekdays: 1=Mon, 7=Sun
      dailyTotals[weekday] = (dailyTotals[weekday] ?? 0) + transaction.amount;
    }

    List<BarChartGroupData> groups = [];
    dailyTotals.forEach((dayIndex, amount) {
      groups.add(
        BarChartGroupData(
          x: dayIndex,
          barRods: [
            BarChartRodData(
              toY: amount,
              gradient: AppColors.primaryGradient,
              width: 23,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
          ],
        ),
      );
    });

    return groups;
  }
}
