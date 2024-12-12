import 'package:expense_tracker/components/custom_textfield.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AmountInput extends StatelessWidget {
  const AmountInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder:
          (BuildContext context, TransactionController value, Widget? child) {
        return CustomTextField(
          controller: value.amountController,
          iconData: Icons.money,
          textInputType: TextInputType.number,
          hintText: "0.0",
          obscureTxt: false,
        );
      },
    );
  }
}
