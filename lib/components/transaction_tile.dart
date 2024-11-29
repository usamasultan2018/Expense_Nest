import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/utils/helpers/date.dart';
import 'package:expense_tracker/utils/helpers/geticons.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final Function()? onPressed;
  final String iconData;
  final Color color;

  const TransactionTile({
    Key? key,
    required this.transaction,
    this.onPressed,
    required this.iconData,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.7),
                    ),
                    child: Center(
                      child: Icon(
                        getIconForCategory(transaction.category),
                        color: getCategoryDarkColor(transaction.category),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.category.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      Text(
                        DateTimeUtils.formatDateMonthDayYear(transaction.date),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              // Right Side: Amount and Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${transaction.type == TransactionType.income ? '+' : '-'} \$${transaction.amount}",
                    style: TextStyle(
                      color: transaction.type == TransactionType.income
                          ? AppColors.green
                          : AppColors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    DateTimeUtils.formatTime(transaction.time),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}