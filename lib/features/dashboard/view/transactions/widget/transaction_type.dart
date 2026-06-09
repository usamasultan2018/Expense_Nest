import 'package:expense_tracker/core/utils/helpers/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';

class TransactionToggle extends StatelessWidget {
  final TransactionType initialType;

  const TransactionToggle({Key? key, required this.initialType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<TransactionController>(
      builder: (context, controller, _) {
        final isIncome = controller.selectedType == TransactionType.income;

        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _ToggleSegment(
                label: "Income",
                isSelected: isIncome,
                onTap: () => controller.setType(TransactionType.income),
              ),
              _ToggleSegment(
                label: "Expense",
                isSelected: !isIncome,
                onTap: () => controller.setType(TransactionType.expense),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleSegment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInToLinear,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? colorScheme.onPrimary
                  : theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ),
    );
  }
}
