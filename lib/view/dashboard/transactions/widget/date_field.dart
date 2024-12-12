import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DateField extends StatelessWidget {
  const DateField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    return Consumer<TransactionController>(
        builder: (context, transactionController, child) {
      return TextFormField(
        controller: transactionController.dateEditingController,
        onTap: () => transactionController.selectDate(context),
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor:
              theme.colorScheme.surface, // Change fill color based on readOnly
          prefixIcon: Icon(
            Icons.calendar_month,
            size: 16,
            color: theme.colorScheme.onSurface
                .withOpacity(0.6), // Use theme color for icon
          ),
          hintText: AppLocalizations.of(context)!.date_hint_text,

          hintStyle: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface
                  .withOpacity(0.6)), // Adjust hint text color
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
        ),
      );
    });
  }
}
