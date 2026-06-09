import 'package:expense_tracker/core/models/account.dart';
import 'package:expense_tracker/core/utils/helpers/constant.dart';
import 'package:flutter/material.dart';

class BalanceCardTile extends StatelessWidget {
  final AccountModel accountModel;

  const BalanceCardTile({
    Key? key,
    required this.accountModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Balance",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withOpacity(0.75),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "PKR ${formatLargeNumber(accountModel.balance)}",
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),

              /// Wallet Icon
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: colorScheme.onPrimary,
                  size: 28,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          /// INCOME & EXPENSE
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  colorScheme: colorScheme,
                  icon: Icons.arrow_downward_rounded,
                  title: "Income",
                  amount: formatLargeNumber(accountModel.totalIncome),
                  iconColor: colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _infoCard(
                  colorScheme: colorScheme,
                  icon: Icons.arrow_upward_rounded,
                  title: "Expense",
                  amount: formatLargeNumber(accountModel.totalExpense),
                  iconColor: colorScheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required ColorScheme colorScheme,
    required IconData icon,
    required String title,
    required String amount,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.onPrimary.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onPrimary.withOpacity(0.75),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
