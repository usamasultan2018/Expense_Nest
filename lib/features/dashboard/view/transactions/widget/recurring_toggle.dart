// recurring_toggle.dart
// Drop-in widget. Place it in:
// lib/features/dashboard/view/transactions/widget/recurring_toggle.dart
//
// Usage in add_transaction.dart:
//   RecurringToggle(
//     selected: context.watch<TransactionController>().recurringInterval,
//     onChanged: (v) => context.read<TransactionController>().setRecurringInterval(v),
//   )

import 'package:flutter/material.dart';

// ─── Enum ────────────────────────────────────────────────────────────────────

enum RecurringInterval { never, daily, weekly, monthly, yearly }

extension RecurringIntervalLabel on RecurringInterval {
  String get label {
    switch (this) {
      case RecurringInterval.never:
        return 'Never';
      case RecurringInterval.daily:
        return 'Daily';
      case RecurringInterval.weekly:
        return 'Weekly';
      case RecurringInterval.monthly:
        return 'Monthly';
      case RecurringInterval.yearly:
        return 'Yearly';
    }
  }

  IconData get icon {
    switch (this) {
      case RecurringInterval.never:
        return Icons.block_rounded;
      case RecurringInterval.daily:
        return Icons.today_rounded;
      case RecurringInterval.weekly:
        return Icons.view_week_rounded;
      case RecurringInterval.monthly:
        return Icons.calendar_month_rounded;
      case RecurringInterval.yearly:
        return Icons.event_repeat_rounded;
    }
  }

  // Serialize to/from Firestore
  String get firestoreValue => name; // 'never', 'daily', 'monthly', 'yearly'

  static RecurringInterval fromString(String? value) {
    return RecurringInterval.values.firstWhere(
      (e) => e.name == value,
      orElse: () => RecurringInterval.never,
    );
  }
}

// ─── Widget ──────────────────────────────────────────────────────────────────

class RecurringToggle extends StatelessWidget {
  const RecurringToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final RecurringInterval selected;
  final ValueChanged<RecurringInterval> onChanged;

  static const _options = RecurringInterval.values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            // Fit all 4 chips in a single row; let them share the available width.
            final chipWidth =
                (constraints.maxWidth - (_options.length - 1) * 8) /
                    _options.length;

            return Row(
              children: [
                for (int i = 0; i < _options.length; i++) ...[
                  if (i != 0) const SizedBox(width: 8),
                  _Chip(
                    interval: _options[i],
                    isSelected: selected == _options[i],
                    width: chipWidth,
                    onTap: () => onChanged(_options[i]),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

// ─── Single chip ─────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  const _Chip({
    required this.interval,
    required this.isSelected,
    required this.width,
    required this.onTap,
  });

  final RecurringInterval interval;
  final bool isSelected;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final selectedBg = colorScheme.primary;
    final unselectedBg = colorScheme.surfaceVariant;
    final selectedFg = colorScheme.onPrimary;
    final unselectedFg = colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(
                  color: colorScheme.outline.withOpacity(0.3),
                  width: 1,
                ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                interval.icon,
                key: ValueKey(isSelected),
                size: 18,
                color: isSelected ? selectedFg : unselectedFg,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              interval.label,
              style: textTheme.labelSmall?.copyWith(
                color: isSelected ? selectedFg : unselectedFg,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
