import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/view model/transaction_controller/transaction_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionTypeSegmentedControl extends StatelessWidget {
  final TransactionType initialType;

  const TransactionTypeSegmentedControl({Key? key, required this.initialType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate screen width and set segment width dynamically
    final screenWidth = MediaQuery.of(context).size.width;
    final segmentWidth =
        screenWidth * 0.4; // Each segment takes 40% of the screen width

    return Consumer<TransactionController>(
      builder: (context, transactionController, child) {
        final selectedIndex =
            transactionController.selectedType == TransactionType.income
                ? 1
                : 2;

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
            transactionController.setType(
              value == 1 ? TransactionType.income : TransactionType.expense,
            );
          },
        );
      },
    );
  }
}
