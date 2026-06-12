import 'package:expense_tracker/core/models/account.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:flutter/material.dart';

class BalanceCardTile extends StatefulWidget {
  final AccountModel accountModel;

  const BalanceCardTile({
    Key? key,
    required this.accountModel,
  }) : super(key: key);

  @override
  State<BalanceCardTile> createState() => _BalanceCardTileState();
}

class _BalanceCardTileState extends State<BalanceCardTile> {
  bool _isVisible = true;

  void _toggleVisibility() {
    setState(() => _isVisible = !_isVisible);
  }

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
            colorScheme.primary.withValues(alpha: 0.75),
            colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Balance",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.70),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _MaskedText(
                    visible: _isVisible,
                    value:
                        "PKR ${formatLargeNumber(widget.accountModel.balance)}",
                    maskedValue: "PKR ••••••••",
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    maskedStyle: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),

              /// Visibility Toggle
              GestureDetector(
                onTap: _toggleVisibility,
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _isVisible
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      key: ValueKey(_isVisible),
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Divider(
            color: colorScheme.onPrimary.withValues(alpha: 0.12),
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 20),

          /// INCOME & EXPENSE
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  colorScheme: colorScheme,
                  icon: Icons.arrow_downward_rounded,
                  title: "Income",
                  value: formatLargeNumber(widget.accountModel.totalIncome),
                  iconColor: Colors.greenAccent.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoCard(
                  colorScheme: colorScheme,
                  icon: Icons.arrow_upward_rounded,
                  title: "Expense",
                  value: formatLargeNumber(widget.accountModel.totalExpense),
                  iconColor: Colors.redAccent.withValues(alpha: 0.85),
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
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.onPrimary.withValues(alpha: 0.12),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onPrimary.withValues(alpha: 0.65),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                _MaskedText(
                  visible: _isVisible,
                  value: value,
                  maskedValue: "••••••",
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  maskedStyle: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    letterSpacing: 3,
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

class _MaskedText extends StatelessWidget {
  final bool visible;
  final String value;
  final String maskedValue;
  final TextStyle style;
  final TextStyle maskedStyle;

  const _MaskedText({
    required this.visible,
    required this.value,
    required this.maskedValue,
    required this.style,
    required this.maskedStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: Text(value, style: style, overflow: TextOverflow.ellipsis),
        ),
        AnimatedOpacity(
          opacity: visible ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 250),
          child: Text(maskedValue, style: maskedStyle),
        ),
      ],
    );
  }
}
