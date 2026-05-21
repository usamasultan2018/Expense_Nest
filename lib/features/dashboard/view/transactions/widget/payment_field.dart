import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:expense_tracker/core/utils/helpers/constant.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentField extends StatelessWidget {
  const PaymentField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, controller, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.15),
            ),
          ),
          child: CustomDropdown<String>(
            hintText: 'Payment Method',
            items: PayMethod.values
                .map(
                  (method) => method.displayName,
                )
                .toList(),
            initialItem: controller.selectedPaymentMethod?.displayName,
            onChanged: (value) {
              final selectedMethod = PayMethod.values.firstWhere(
                (method) => method.displayName == value,
                orElse: () => PayMethod.cash,
              );

              controller.updatePaymentMethod(
                selectedMethod,
              );
            },
            closedHeaderPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            decoration: CustomDropdownDecoration(
              closedBorderRadius: BorderRadius.circular(20),
              expandedBorderRadius: BorderRadius.circular(20),
              closedFillColor: Colors.transparent,
              expandedFillColor: Theme.of(context).cardColor,
              closedSuffixIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Theme.of(context).hintColor,
              ),
              expandedSuffixIcon: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Theme.of(context).hintColor,
              ),
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
              headerStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              listItemStyle: Theme.of(context).textTheme.bodyLarge,
              listItemDecoration: ListItemDecoration(
                selectedColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.08),
              ),
            ),
          ),
        );
      },
    );
  }
}
