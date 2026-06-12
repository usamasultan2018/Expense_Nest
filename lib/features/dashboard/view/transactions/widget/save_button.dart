// components/round_save_button.dart
import 'package:expense_tracker/core/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';

class RoundSaveButton extends StatelessWidget {
  const RoundSaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, transactionController, child) {
        return RoundButton(
          loading: transactionController.isLoading,
          title: "Save",
          onPressed: () async {
            try {
              await transactionController.createNewTransaction(context);
            } catch (e) {
              print(e);
            }
          },
        );
      },
    );
  }
}
