import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/view/dashboard/stats/widgets/bar_chart_transactions.dart';
import 'package:expense_tracker/view/dashboard/stats/widgets/pie_chart_transactions.dart';
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
  List<bool> isSelected = [
    true,
    false,
  ];

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
                const Transactiontype(),
                const SizedBox(height: 20),
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
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                        }
                      });
                    },
                    children: const [
                      Icon(Icons.pie_chart),
                      Icon(Icons.bar_chart),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (isSelected[0]) ...[
                  const PieChartTransaction(),
                ] else if (isSelected[1]) ...[
                  const BarChartTransaction(),
                ],

                const SizedBox(height: 20),

                // Transaction label
                Text(
                  AppLocalizations.of(context)!.transaction,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),

                // Transaction filter widget
                const TransactionFilter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
