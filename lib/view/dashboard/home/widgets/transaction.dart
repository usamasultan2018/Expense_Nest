import 'dart:math';
import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/components/no_transaction.dart';
import 'package:expense_tracker/components/transaction_tile.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/repository/transaction_repository.dart';
import 'package:expense_tracker/utils/helpers/skeleton.dart';
import 'package:expense_tracker/view/dashboard/transactions/edit_transactions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    return StreamBuilder<List<TransactionModel>>(
        stream: TransactionRepository().getTransactions(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    const TransactionCardSkeleton(),
                itemCount: 4);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Check for no data or empty list
            return const Center(child: NoTransaction());
          } else {
            List<TransactionModel> transactions = snapshot.data!;
            int itemCount = min(transactions.length, 4); // Adjust itemCount
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return FadeTransitionEffect(
                  child: TransactionTile(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return EditTransaction(
                            transaction: transactions[index]);
                      }));
                    },
                    transaction: transactions[index],
                    iconData: transactions[index].category,
                  ),
                );
              },
            );
          }
        });
  }
}
