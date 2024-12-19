import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/components/no_graph_transaction.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/repository/transaction_repository.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/utils/helpers/constant.dart';
import 'package:expense_tracker/utils/helpers/shared_preference.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyLineChart extends StatefulWidget {
  final TransactionType transactionType;
  const MyLineChart({super.key, required this.transactionType});

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
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

        // Generate data points for the chart
        List<FlSpot> spots = [];
        List<String> bottomTitles = [];
        double maxY = double.minPositive;
        double minY = double.maxFinite;

        // Prepare data for the graph
        for (var i = 0; i < transactions.length; i++) {
          final transaction = transactions[i];
          spots.add(FlSpot(i.toDouble(), transaction.amount));

          // Adjust Y-axis bounds
          maxY = transaction.amount > maxY ? transaction.amount : maxY;
          minY = transaction.amount < minY ? transaction.amount : minY;

          // Format dates for X-axis titles
          bottomTitles.add(
              DateFormat('MMM d').format(transaction.date)); // Format as needed
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: FadeTransitionEffect(
            child: LineChartGraphWidget(
              spots: spots,
              maxY: maxY,
              minY: minY,
              bottomTitles: bottomTitles,
            ),
          ),
        );
      },
    );
  }
}

class LineChartGraphWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final double maxY;
  final double minY;
  final List<String> bottomTitles;

  const LineChartGraphWidget({
    super.key,
    required this.spots,
    required this.maxY,
    required this.minY,
    required this.bottomTitles,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false), // Disable grid
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              interval: (maxY - minY) / 5, // Adjust intervals
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(value.toInt().toString(), style: style),
                );
              },
              reservedSize: 35,
            ),
          ),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)), // Hide right titles
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)), // Hide top titles
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                if (value.toInt() < bottomTitles.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(bottomTitles[value.toInt()], style: style),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false, // Remove the border
        ),

        minX: 0,
        maxX: (bottomTitles.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 1.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true), // Hide dots
            color: AppColors.secondary, // Line color
            belowBarData: BarAreaData(
              show: true,
              color:
                  AppColors.secondary.withOpacity(0.2), // Below line area color
            ),
          ),
        ],
      ),
    );
  }
}
