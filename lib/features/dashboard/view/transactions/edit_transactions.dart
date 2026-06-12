import 'package:expense_tracker/core/components/custom_button.dart';
import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/utils/dialog.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/amount_field.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/date_field.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/note_textfield.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/payment_field.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTransaction extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransaction({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<TransactionController>(
        context,
        listen: false,
      );

      controller.prepareForEditing(
        widget.transaction,
      );
    });
  }

  Future<void> _deleteTransaction(
    BuildContext context,
  ) async {
    ConfirmationDialogUtil.show(
      context: context,
      title: "Delete Transaction",
      message: "Are you sure you want to delete this transaction?",
      onConfirm: () async {
        /// close dialog first
        Navigator.pop(context);

        await Provider.of<TransactionController>(
          context,
          listen: false,
        ).deleteTransaction(
          context,
          widget.transaction,
        );

        /// close edit screen
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionController = context.watch<TransactionController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Transaction",
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(
                right: 12,
              ),
              child: transactionController.isDeleting
                  ? const Center(
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _deleteTransaction(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    )),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const SizedBox(height: 30),
              TransactionToggle(
                initialType: transactionController.selectedType,
              ),
              const SizedBox(height: 40),
              const AmountInput(),
              const SizedBox(height: 20),
              const DateField(),
              const SizedBox(height: 20),
              const NoteField(),
              const SizedBox(height: 20),
              const PaymentField(),
              const SizedBox(height: 40),
              RoundButton(
                loading: transactionController.isLoading,
                title: "Update",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await transactionController.modifyTransaction(
                      context,
                      widget.transaction,
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
