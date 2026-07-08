import 'package:expense_tracker/features/dashboard/view/budget/screens/utils/month_grid_delegate.dart';
import 'package:flutter/material.dart';

import '../constants/budget_form_constants.dart';
import 'sheet_handle.dart';

/// Modal bottom sheet listing months to choose from.
///
/// Call [show] to display it; it returns the picked month string,
/// or null if the user dismissed it without picking.
class MonthPickerSheet extends StatelessWidget {
  final String? selected;

  const MonthPickerSheet({super.key, required this.selected});

  static Future<String?> show(
    BuildContext context, {
    required String? selected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => MonthPickerSheet(selected: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const SheetHandle(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select month",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              gridDelegate: const MonthGridDelegate(),
              itemCount: kMonths.length,
              itemBuilder: (context, index) {
                final month = kMonths[index];
                final isSelected = month == selected;
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.pop(context, month),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                    ),
                    child: Text(
                      month.substring(0, 3),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
