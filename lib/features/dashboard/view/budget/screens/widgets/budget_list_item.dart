import 'package:expense_tracker/core/utils/constant.dart';
import 'package:flutter/material.dart';

/// Richer budget card: category icon, progress bar, remaining / spent amounts,
/// over-budget badge and an optional alert indicator.
class BudgetListItem extends StatelessWidget {
  const BudgetListItem({
    super.key,
    required this.categoryTitle,
    required this.categoryColor,
    required this.categoryIcon,
    required this.amount,
    required this.spent,
    required this.currencySymbol,
    this.receiveAlert = false,
    this.alertThresholdPercent = 80,
    this.onTap,
  });

  final String categoryTitle;
  final int categoryColor;
  final int categoryIcon;
  final double amount;
  final double spent;
  final String currencySymbol;
  final bool receiveAlert;
  final double alertThresholdPercent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = Color(categoryColor);

    final double progress = amount > 0 ? (spent / amount).clamp(0.0, 1.0) : 0;
    final double remaining = (amount - spent).clamp(0, double.infinity);
    final bool isOverBudget = spent > amount;
    final bool nearThreshold = receiveAlert &&
        !isOverBudget &&
        (progress * 100) >= alertThresholdPercent;

    // Progress bar colour logic
    final Color barColor = isOverBudget
        ? colorScheme.error
        : nearThreshold
            ? Colors.orange
            : color;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOverBudget
                    ? colorScheme.error.withValues(alpha: 0.35)
                    : nearThreshold
                        ? Colors.orange.withValues(alpha: 0.35)
                        : colorScheme.outline.withValues(alpha: 0.12),
                width: isOverBudget || nearThreshold ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row ────────────────────────────────────────────────────
                Row(
                  children: [
                    // Category icon bubble
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: color.withValues(alpha: 0.13),
                      ),
                      child: Icon(
                        IconData(categoryIcon, fontFamily: 'MaterialIcons'),
                        color: color,
                        size: 22,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Category label + budget limit
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Limit: $currencySymbol${formatLargeNumber(amount)}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status badges + chevron
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isOverBudget) _StatusBadge.overBudget(colorScheme),
                        if (!isOverBudget && nearThreshold)
                          _StatusBadge.nearLimit(colorScheme),
                        if (receiveAlert && !isOverBudget && !nearThreshold)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.notifications_active_outlined,
                              size: 16,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.35),
                            ),
                          ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: colorScheme.onSurface.withValues(alpha: 0.35),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ── Progress bar ───────────────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor:
                        colorScheme.onSurface.withValues(alpha: 0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  ),
                ),

                const SizedBox(height: 10),

                // ── Bottom row: spent / remaining ──────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _AmountLabel(
                      label: 'Spent',
                      value: '$currencySymbol${formatLargeNumber(spent)}',
                      valueColor: colorScheme.error,
                    ),
                    _AmountLabel(
                      label: isOverBudget ? 'Over by' : 'Remaining',
                      value: isOverBudget
                          ? '$currencySymbol${formatLargeNumber(spent - amount)}'
                          : '$currencySymbol${formatLargeNumber(remaining)}',
                      valueColor: isOverBudget ? colorScheme.error : color,
                      alignRight: true,
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

// ── Helper widgets ─────────────────────────────────────────────────────────────

class _AmountLabel extends StatelessWidget {
  const _AmountLabel({
    required this.label,
    required this.value,
    required this.valueColor,
    this.alignRight = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cross =
        alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: cross,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.bg, required this.fg});

  factory _StatusBadge.overBudget(ColorScheme cs) => _StatusBadge(
        label: 'Over budget',
        bg: cs.error.withValues(alpha: 0.12),
        fg: cs.error,
      );

  factory _StatusBadge.nearLimit(ColorScheme cs) => _StatusBadge(
        label: 'Near limit',
        bg: Colors.orange.withValues(alpha: 0.12),
        fg: Colors.orange,
      );

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
