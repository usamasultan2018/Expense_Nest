import 'package:expense_tracker/components/no_transaction.dart';
import 'package:expense_tracker/components/transaction_tile.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/utils/helpers/geticons.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionFilter extends StatelessWidget {
  const TransactionFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, provider, child) {
        return StreamBuilder<List<TransactionModel>>(
          stream: provider.getTransactionsByType(provider.selectedType),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const NoTransaction();
            }

            final transactions = snapshot.data!;

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return TransactionTile(
                  transaction: transaction,
                  iconData: transactions[index].category,
                );
              },
            );
          },
        );
      },
    );
  }
}
