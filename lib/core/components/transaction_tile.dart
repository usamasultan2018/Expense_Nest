import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/core/utils/date.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final Function()? onPressed;

  const TransactionTile({
    Key? key,
    required this.transaction,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isIncome = transaction.type == TransactionType.income;
    final transactionColor = isIncome ? colorScheme.primary : colorScheme.error;

    final category = transaction.category;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onPressed,
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                /// CATEGORY ICON
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: category?.color.withValues(alpha: 0.15) ??
                        transactionColor.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    category?.icon ??
                        (isIncome
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded),
                    color: category?.color ?? transactionColor,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                /// TITLE + DATE + CATEGORY
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.note.isNotEmpty
                            ? transaction.note
                            : category?.title ??
                                (isIncome ? "Income" : "Expense"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 13,
                            color: theme.hintColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateTimeUtils.formatDateMonthDayYear(
                              transaction.dateTime,
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                      if (category != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: category.color.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: category.color,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                /// AMOUNT + TIME
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${isIncome ? '+' : '-'} PKR ${formatLargeNumber(transaction.amount)}",
                      style: TextStyle(
                        color: transactionColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        DateTimeUtils.formatTime(
                          transaction.dateTime,
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
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
