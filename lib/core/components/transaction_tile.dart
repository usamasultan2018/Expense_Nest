import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/core/utils/date.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/controller/currency_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final Function()? onPressed;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isIncome = transaction.type == TransactionType.income;
    final transactionColor = isIncome ? colorScheme.primary : colorScheme.error;
    final category = transaction.category;

    // ✅ reads currency reactively
    final currency = context.watch<CurrencyController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: (category?.color ?? transactionColor)
                        .withValues(alpha: 0.12),
                  ),
                  child: Icon(
                    category?.icon ??
                        (isIncome
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded),
                    color: category?.color ?? transactionColor,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 12),

                // Category + date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: category.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: category.color,
                            ),
                          ),
                        ),
                      const SizedBox(height: 3),
                      Text(
                        DateTimeUtils.formatDateMonthDayYear(
                            transaction.dateTime),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Amount + time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      // ✅ dynamic symbol instead of hardcoded "PKR"
                      "${isIncome ? '+' : '-'} ${currency.symbol}${formatLargeNumber(transaction.amount)}",
                      style: TextStyle(
                        color: transactionColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      DateTimeUtils.formatTime(transaction.dateTime),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
