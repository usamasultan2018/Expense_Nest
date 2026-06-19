import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecurringEmptyCard extends StatelessWidget {
  final String label;
  const RecurringEmptyCard({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push('/add-transaction'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You don't have any\n$label recurring transactions.",
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to create one now',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.update_rounded,
              size: 48,
              color: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
