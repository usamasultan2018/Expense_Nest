import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentField extends StatelessWidget {
  const PaymentField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, transactionController, child) {
        return CustomDropdown<String>(
          hintText: 'Select Payment Method',
          // Map PayMethod values to their display names
          items: PayMethod.values.map((method) => method.displayName).toList(),
          initialItem:
              transactionController.selectedPaymentMethod?.displayName ??
                  PayMethod.cash.displayName,
          onChanged: (value) {
            // Map the selected string back to the PayMethod enum
            final selectedMethod = PayMethod.values.firstWhere(
              (method) => method.displayName == value,
              orElse: () => PayMethod.cash, // Default to cash if no match
            );
            transactionController.updatePaymentMethod(selectedMethod);
          },
          closedHeaderPadding: const EdgeInsets.all(17),
          decoration: CustomDropdownDecoration(
            closedSuffixIcon: const Icon(
              Icons.arrow_drop_down,
              size: 20,
            ),
            closedFillColor: Theme.of(context).colorScheme.surface,
            expandedFillColor: Theme.of(context).colorScheme.surface,
            listItemStyle: Theme.of(context).textTheme.bodyLarge,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            headerStyle: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      },
    );
  }
}
