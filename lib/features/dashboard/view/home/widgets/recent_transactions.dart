import 'package:expense_tracker/core/components/fade_effect.dart';
import 'package:expense_tracker/core/components/no_transaction.dart';
import 'package:expense_tracker/core/components/transaction_tile.dart';
import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/utils/date.dart';
import 'package:expense_tracker/core/utils/skeleton_loading.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  List<Object> _groupByDate(List<TransactionModel> transactions) {
    final Map<String, List<TransactionModel>> grouped = {};
    for (final t in transactions) {
      final key = DateTimeUtils.formatDateMonthDayYear(t.dateTime);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    final List<Object> items = [];
    for (final entry in grouped.entries) {
      items.add(entry.key); // just the date string as header
      items.addAll(entry.value);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<TransactionController>(
      builder: (context, controller, child) {
        if (controller.isLoadingTransactions) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (_, __) => const TransactionCardSkeleton(),
          );
        }

        if (controller.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${controller.error}', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadTransactions,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final all = List<TransactionModel>.from(controller.allTransactions)
          ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
        final recent = all.take(5).toList();

        if (recent.isEmpty) {
          return const SizedBox(height: 250, child: NoTransaction());
        }

        final items = _groupByDate(recent);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) {
            if (item is String) {
              return Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(
                  item,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            final t = item as TransactionModel;
            return FadeTransitionEffect(
              child: TransactionTile(
                transaction: t,
                onPressed: () => context.push('/edit-transaction', extra: t),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
