import 'package:expense_tracker/core/components/app_toggle.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';

class TransactionToggle extends StatelessWidget {
  final TransactionType initialType;

  const TransactionToggle({Key? key, required this.initialType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<TransactionController>(
      builder: (context, controller, _) {
        return AppToggle<TransactionType>(
          selectedValue: controller.selectedType,
          onChanged: controller.setType,
          options: const [
            ToggleOption(
              label: 'Income',
              value: TransactionType.income,
            ),
            ToggleOption(
              label: 'Expense',
              value: TransactionType.expense,
            ),
          ],
        );
      },
    );
  }
}
