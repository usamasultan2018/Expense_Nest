import 'package:flutter/material.dart';

class CategoryEmptyCard extends StatelessWidget {
  const CategoryEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.grid_view_rounded,
            color: theme.colorScheme.primary,
            size: 50,
          ),
          const SizedBox(height: 16),
          Text(
            "There is no category\ncreated by you yet.\nClick (+) to add one!",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
