// add_transaction.dart

import 'package:expense_tracker/core/components/app_app_bar.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/controller/category_controller.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/amount_field.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/category_selector.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/date_field.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/note_textfield.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/payment_field.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/receipt_attachment.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/recurring_toggle.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/save_button.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTransaction extends StatefulWidget {
    final TransactionType? initialType;

  const AddTransaction({super.key, this.initialType});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

   WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<TransactionController>();
      controller.resetForm();
      if (widget.initialType != null) {
        controller
            .setType(widget.initialType!); // or whatever your setter is named
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar.title('Add Transaction', showBack: true),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const SizedBox(height: 30),
              TransactionToggle(
                initialType: context.read<TransactionController>().selectedType,
              ),
              const SizedBox(height: 40),
              const AmountInput(),
              const SizedBox(height: 20),
              const DateField(),
              const SizedBox(height: 20),
              CategorySelector(
                selectedType:
                    context.watch<TransactionController>().selectedType,
                selectedCategory:
                    context.watch<TransactionController>().selectedCategory,
                onCategorySelected: (cat) {
                  context.read<TransactionController>().selectCategory(cat);
                },
              ),
              const SizedBox(height: 20),
              RecurringToggle(
                selected:
                    context.watch<TransactionController>().recurringInterval,
                onChanged: (v) => context
                    .read<TransactionController>()
                    .setRecurringInterval(v),
              ),
              const SizedBox(height: 20),
              const NoteField(),
              const SizedBox(height: 20),
              const PaymentField(),
              const SizedBox(height: 20),
              ReceiptAttachment(
                imageFile: context.watch<TransactionController>().receiptFile,
                imageUrl: context.watch<TransactionController>().receiptUrl,
                onImagePicked: (file) =>
                    context.read<TransactionController>().setReceipt(file),
                onRemove: () =>
                    context.read<TransactionController>().removeReceipt(),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 40),
              const RoundSaveButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
