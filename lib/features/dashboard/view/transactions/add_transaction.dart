import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/amount_field.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/date_field.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/note_textfield.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/payment_field.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/save_button.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/widget/transaction_type.dart';

// Import your controller
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Watch for changes in the transaction type
    final transactionController = context.watch<TransactionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
        centerTitle: true,
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
              const RoundSaveButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
