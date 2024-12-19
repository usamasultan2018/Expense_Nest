import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/view/dashboard/stats/widgets/bar_chart_transactions.dart';
import 'package:expense_tracker/view/dashboard/stats/widgets/line_chart_transactions.dart';
import 'package:expense_tracker/view/dashboard/stats/widgets/pie_chart_transactions.dart';
import 'package:expense_tracker/view/dashboard/stats/widgets/transaction_filter.dart';
import 'package:expense_tracker/view/dashboard/stats/widgets/transactiontype.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  List<bool> isSelected = [true, false, false];

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

                // Transaction Type
                const Transactiontype(),
                const SizedBox(height: 20),

                // Chart Toggle Buttons
                Align(
                  alignment: Alignment.topRight,
                  child: ToggleButtons(
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    fillColor: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    isSelected: isSelected,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    onPressed: (int index) {
                      setState(() {
                        isSelected = [false, false, false];
                        isSelected[index] =
                            true; // Activate the selected button
                      });
                    },
                    children: const [
                      Icon(Icons.pie_chart),
                      Icon(Icons.bar_chart),
                      Icon(FontAwesomeIcons.lineChart),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Chart Display
                if (isSelected[0]) const PieChartTransaction(),
                if (isSelected[1]) const BarChartTransaction(),
                if (isSelected[2]) const LineChartTransactions(),

                const SizedBox(height: 20),

                // Transaction Label
                Text(
                  AppLocalizations.of(context)!.transaction,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ) ??
                      const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Transaction Filter Widget
                const TransactionFilter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
