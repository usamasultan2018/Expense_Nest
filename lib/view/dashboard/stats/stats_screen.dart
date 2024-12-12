import 'package:expense_tracker/view/dashboard/stats/widgets/pie_chart.dart';
import 'package:expense_tracker/view/dashboard/stats/widgets/transaction_filter.dart';
import 'package:expense_tracker/view/dashboard/stats/widgets/transactiontype.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // StatsTransactionType with callback to update transaction type
                Transactiontype(),
                const SizedBox(height: 20),
                // Chart Widget, passing the selected transaction type from provider

                const SizedBox(height: 20),
                PieChartTransaction(),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.transaction,
                  style: Theme.of(context)!.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: 10,
                ),
                TransactionFilter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
