import 'package:expense_tracker/core/components/fade_effect.dart';
import 'package:expense_tracker/core/components/no_transaction.dart';
import 'package:expense_tracker/core/components/transaction_tile.dart';
import 'package:expense_tracker/core/utils/skeleton_loading.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, controller, child) {
        if (controller.isLoadingTransactions) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) => const TransactionCardSkeleton(),
          );
        }

        // Error State
        if (controller.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${controller.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadTransactions,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final transactions = controller.allTransactions;

        if (transactions.isEmpty) {
          return const SizedBox(
            height: 250,
            child: NoTransaction(),
          );
        }

        return Column(
          children: transactions.map((transaction) {
            return FadeTransitionEffect(
              child: TransactionTile(
                transaction: transaction,
                onPressed: () {
                  context.push(
                    '/edit-transaction',
                    extra: transaction,
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
