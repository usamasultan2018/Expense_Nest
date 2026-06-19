import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:expense_tracker/features/dashboard/view/home/view/widgets/recurring_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RecurringTransactionsScreen extends StatelessWidget {
  const RecurringTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<TransactionController>();

    final all = controller.allTransactions;
    final daily = all.where((t) => t.recurringInterval == 'daily').toList();
    final monthly = all.where((t) => t.recurringInterval == 'monthly').toList();
    final yearly = all.where((t) => t.recurringInterval == 'yearly').toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Recurring transactions',
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          RecurringSection(
            label: 'Daily',
            interval: 'daily',
            transactions: daily,
          ),
          const SizedBox(height: 24),
          RecurringSection(
            label: 'Monthly',
            interval: 'monthly',
            transactions: monthly,
          ),
          const SizedBox(height: 24),
          RecurringSection(
            label: 'Yearly',
            interval: 'yearly',
            transactions: yearly,
          ),
        ],
      ),
    );
  }
}

// ── Section ────────────────────────────────────────────────────────────────
