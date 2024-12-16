import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/utils/helpers/skeleton_loading.dart';
import 'package:expense_tracker/view/dashboard/home/all_transaction/widget/search_field.dart';
import 'package:expense_tracker/view/dashboard/home/all_transaction/widget/time_period_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expense_tracker/view/dashboard/transactions/edit_transactions.dart';
import 'package:expense_tracker/components/no_transaction.dart';
import 'package:expense_tracker/components/transaction_tile.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';

class AllTransaction extends StatefulWidget {
  const AllTransaction({super.key});

  @override
  _AllTransactionState createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction> {
  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Transactions"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          TimePeriodSelector(),
          const SizedBox(height: 20),
          SearchField(),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<TransactionModel>>(
              stream: transactionController.transactionsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.all(10),
                      child: FadeTransitionEffect(
                        child: TileSkeleton(
                          height: 50,
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const FadeTransitionEffect(child: NoTransaction());
                } else {
                  List<TransactionModel> transactions = snapshot.data!;
                  List<TransactionModel> filteredTransactions =
                      transactionController.filterTransactions(transactions);

                  if (filteredTransactions.isEmpty) {
                    return const FadeTransitionEffect(child: NoTransaction());
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: FadeTransitionEffect(
                      child: ListView.builder(
                        key: ValueKey(filteredTransactions.length),
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TransactionTile(
                              onPressed: () {
                                transactionController.loadTransactionForEditing(
                                    filteredTransactions[index]);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (ctx) {
                                  return EditTransaction(
                                      transaction: filteredTransactions[index]);
                                }));
                              },
                              transaction: filteredTransactions[index],
                              iconData: filteredTransactions[index].category,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
