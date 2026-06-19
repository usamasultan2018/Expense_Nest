import 'package:expense_tracker/core/components/transaction_tile.dart';
import 'package:expense_tracker/features/dashboard/view/home/view/widgets/recurring_empty_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecurringSection extends StatelessWidget {
  final String label;
  final String interval;
  final List transactions;

  const RecurringSection({
    super.key,
    required this.label,
    required this.interval,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        transactions.isEmpty
            ? RecurringEmptyCard(label: label)
            : Column(
                children: transactions
                    .map((t) => TransactionTile(
                          transaction: t,
                          onPressed: () =>
                              context.push('/edit-transaction', extra: t),
                        ))
                    .toList(),
              ),
      ],
    );
  }
}

// ── Empty card ─────────────────────────────────────────────────────────────
