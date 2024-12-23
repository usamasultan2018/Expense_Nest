import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:expense_tracker/view/dashboard/stats/widgets/bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarChartTransaction extends StatelessWidget {
  const BarChartTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, provider, child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: MyBarChart(
              transactionType: provider.selectedType,
            ),
          ),
        );
      },
    );
  }
}
