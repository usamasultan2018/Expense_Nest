import 'package:expense_tracker/components/custom_button.dart';
import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/repository/transaction_repo.dart';
import 'package:expense_tracker/utils/helpers/dialog.dart';
import 'package:expense_tracker/utils/helpers/snackbar_util.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/amount_field.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/category_widget.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/date_field.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/note_textfield.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/payment_field.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditTransaction extends StatefulWidget {
  final TransactionModel transaction; // The transaction to edit

  const EditTransaction({super.key, required this.transaction});

  @override
  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  @override
  void initState() {
    super.initState();
    // Load transaction for editing in initState
    Future.microtask(() {
      Provider.of<TransactionController>(context, listen: false)
          .loadTransactionForEditing(widget.transaction);
    });
  }

  Future<void> _deleteTransaction(BuildContext context) async {
    // Show confirmation dialog using the utility
    final confirmDelete = await showDeleteConfirmationDialog(
      context,
      AppLocalizations.of(context)!.deleteTransactionTitle,
      AppLocalizations.of(context)!.deleteTransactionMessage,
    );

    // Proceed with deletion if confirmed
    if (confirmDelete == true) {
      await TransactionRepository().deleteTransaction(widget.transaction);

      Navigator.pop(context); // Go back after deletion
      SnackbarUtil.showSuccessSnackbar(
          context, "Transaction Deleted Successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionType = widget.transaction.type; // Get the transaction type
    print("Hello ${widget.transaction.payMethod.displayName}");

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editTransaction),
        actions: [
          InkWell(
            onTap: () async {
              await _deleteTransaction(context);
            },
            child: Container(
                margin: EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).cardColor,
                ),
                child: const Icon(Icons.delete)),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: FadeTransitionEffect(
            child: Column(
              children: [
                const SizedBox(height: 30),
                TransactionTypeSegmentedControl(initialType: transactionType),
                SizedBox(height: 40),
                const AmountInput(),
                const SizedBox(height: 20),
                const DateField(),
                const SizedBox(height: 20),
                const NoteField(),
                const SizedBox(height: 20),
                const CategoryWidget(),
                const SizedBox(height: 20),
                const PaymentField(),
                const SizedBox(height: 40),
                Consumer<TransactionController>(
                  builder: (context, transactionController, child) {
                    return RoundButton(
                      loading: transactionController.isLoading,
                      title: AppLocalizations.of(context)!.update,
                      onPress: () async {
                        try {
                          await transactionController.modifyTransaction(
                              context, widget.transaction.id);
                          Navigator.pop(context); // Close the current screen
                        } catch (e) {
                          // Handle error (show dialog, snackbar, etc.)
                          print(e);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
