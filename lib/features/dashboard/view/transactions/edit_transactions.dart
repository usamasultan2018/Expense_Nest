import 'package:expense_tracker/core/components/app_app_bar.dart';
import 'package:expense_tracker/core/components/custom_button.dart';
import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/utils/dialog.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/amount_field.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/category_selector.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/date_field.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/note_textfield.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/payment_field.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/receipt_attachment.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/recurring_toggle.dart';
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
      context.read<TransactionController>().prepareForEditing(
            widget.transaction,
          );
    });
  }

  Future<void> _deleteTransaction(BuildContext context) async {
    ConfirmationDialogUtil.show(
      context: context,
      title: "Delete Transaction",
      message: "Are you sure you want to delete this transaction?",
      onConfirm: () async {
        Navigator.pop(context); // close dialog
        await context.read<TransactionController>().deleteTransaction(
              context,
              widget.transaction,
            );
        if (mounted) Navigator.pop(context); // close edit screen
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TransactionController>();

    return Scaffold(
      appBar: AppAppBar.title(
        'Edit Transaction',
        showBack: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ctrl.isDeleting
                ? const Center(
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    tooltip: 'Delete transaction',
                    onPressed: () => _deleteTransaction(context),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.errorContainer,
                      foregroundColor:
                          Theme.of(context).colorScheme.onErrorContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 22),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const SizedBox(height: 30),

              TransactionToggle(
                initialType: ctrl.selectedType,
              ),

              const SizedBox(height: 40),
              const AmountInput(),
              const SizedBox(height: 20),
              const DateField(),
              const SizedBox(height: 20),

              CategorySelector(
                selectedType: ctrl.selectedType,
                selectedCategory: ctrl.selectedCategory,
                onCategorySelected: (cat) => ctrl.selectCategory(cat),
              ),

              const SizedBox(height: 20),
              // ── Recurring ──
              RecurringToggle(
                selected: ctrl.recurringInterval,
                onChanged: ctrl.setRecurringInterval,
              ),

              const SizedBox(height: 20),
              const NoteField(),
              const SizedBox(height: 20),
              const PaymentField(),
              const SizedBox(height: 20),

              // ── Receipt ──
              ReceiptAttachment(
                imageFile: ctrl.receiptFile,
                imageUrl: ctrl.receiptUrl,
                onImagePicked: (file) => ctrl.setReceipt(file),
                onRemove: ctrl.removeReceipt,
              ),

              const SizedBox(height: 40),

              RoundButton(
                loading: ctrl.isLoading,
                title: "Update",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await ctrl.modifyTransaction(context, widget.transaction);
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
