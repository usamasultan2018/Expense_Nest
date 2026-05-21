import 'package:expense_tracker/core/components/loading_widget.dart';
import 'package:expense_tracker/core/components/transaction_count_tile.dart';
import 'package:expense_tracker/features/user/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionCountsSection extends StatefulWidget {
  const TransactionCountsSection({
    super.key,
  });

  @override
  State<TransactionCountsSection> createState() =>
      _TransactionCountsSectionState();
}

class _TransactionCountsSectionState extends State<TransactionCountsSection> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().fetchTransactionCounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (
        context,
        userController,
        child,
      ) {
        if (userController.isTransactionCountLoading) {
          return const Center(
            child: LoadingWidget(),
          );
        }

        final incomeCount = userController.incomeTransactionCount;

        final expenseCount = userController.expenseTransactionCount;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Transactions",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TransactionCountTile(
                      title: "Recorded Incomes",
                      count: incomeCount,
                      icon: const Icon(
                        Icons.trending_up,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TransactionCountTile(
                      title: "Recorded Expenses",
                      count: expenseCount,
                      icon: const Icon(
                        Icons.trending_down,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
