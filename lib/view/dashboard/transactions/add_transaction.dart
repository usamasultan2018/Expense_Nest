import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/repository/category_repository.dart';
import 'package:expense_tracker/utils/helpers/constant.dart';
import 'package:expense_tracker/view%20model/category_controller/category_controller.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/add_picture_field.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/amount_field.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/category_widget.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/payment_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/date_field.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/note_textfield.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/save_button.dart';
import 'package:expense_tracker/view/dashboard/transactions/widget/transaction_type.dart';
import 'package:expense_tracker/repository/transaction_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionController(
        transactionRepository: TransactionRepository(),
        categoryController: CategoryController(
            categoryRepository: CategoryRepository(),
            transactionRepository: TransactionRepository()),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addTransaction),
        ),
        resizeToAvoidBottomInset: true,
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: FadeTransitionEffect(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  TransactionTypeSegmentedControl(
                      initialType: TransactionType.income),
                  SizedBox(height: 40),
                  AmountInput(),
                  SizedBox(height: 20),
                  DateField(),
                  SizedBox(height: 20),
                  NoteField(),
                  SizedBox(height: 20),
                  CategoryWidget(),
                  SizedBox(height: 20),
                  PaymentField(),
                  SizedBox(height: 20),
                  AddPictureField(),
                  SizedBox(height: 40),
                  RoundSaveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
