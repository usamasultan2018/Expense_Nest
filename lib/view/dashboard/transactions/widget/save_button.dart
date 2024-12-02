// components/round_save_button.dart
import 'package:expense_tracker/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoundSaveButton extends StatelessWidget {
  const RoundSaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, transactionController, child) {
        return RoundButton(
          loading: transactionController.isLoading,
          title: AppLocalizations.of(context)!.save_button,
          onPress: () async {
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
