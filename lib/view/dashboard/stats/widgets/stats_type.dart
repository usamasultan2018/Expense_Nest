import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/utils/helpers/constant.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatsTransactionType extends StatelessWidget {
  final Function(TransactionType) onTransactionTypeChanged; // Callback function

  const StatsTransactionType(
      {super.key, required this.onTransactionTypeChanged});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, provider, child) {
        final selectedIndex =
            provider.selectedType == TransactionType.income ? 1 : 2;

        final screenWidth = MediaQuery.of(context).size.width;
        final segmentWidth = screenWidth * 0.43;

        return CustomSlidingSegmentedControl<int>(
          fixedWidth: segmentWidth,
          initialValue: selectedIndex,
          children: {
            1: Text(
              AppLocalizations.of(context)!.income,
              style: TextStyle(
                color: selectedIndex == 1
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            2: Text(
              AppLocalizations.of(context)!.expense,
              style: TextStyle(
                color: selectedIndex == 2
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          },
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          thumbDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: AppColors.primaryGradient,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInToLinear,
          onValueChanged: (value) {
            // Notify the provider of the selected transaction type
            final transactionType =
                value == 1 ? TransactionType.income : TransactionType.expense;
            provider.setType(transactionType);

            // Optionally, notify the parent widget
            onTransactionTypeChanged(transactionType);
          },
        );
      },
    );
  }
}
