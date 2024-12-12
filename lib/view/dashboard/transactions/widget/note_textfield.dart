import 'package:expense_tracker/components/custom_textfield.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoteField extends StatelessWidget {
  const NoteField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, transactionController, child) {
        return CustomTextField(
          controller: transactionController.noteController,
          iconData: Icons.note,
          obscureTxt: false,
          hintText: AppLocalizations.of(context)!.note_hint_text,
        );
      },
    );
  }
}
