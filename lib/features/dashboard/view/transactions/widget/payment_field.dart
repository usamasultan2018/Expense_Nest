import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';

class PaymentField extends StatelessWidget {
  const PaymentField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PayMethod>(
                  value: controller.selectedPaymentMethod,
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Theme.of(context).hintColor,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  hint: Text(
                    'Payment Method',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                  ),
                  items: PayMethod.values.map((method) {
                    return DropdownMenuItem<PayMethod>(
                      value: method,
                      child: Text(method.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.updatePaymentMethod(value);
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
