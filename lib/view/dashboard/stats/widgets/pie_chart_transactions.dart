import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:expense_tracker/view/dashboard/stats/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PieChartTransaction extends StatelessWidget {
  const PieChartTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: MyPieChartWithLegend(
              transactionType: provider.selectedType,
            ),
          ),
        );
      },
    );
  }
}
