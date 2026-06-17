import 'package:flutter/material.dart';

class CategoryColorField extends StatelessWidget {
  final Color selectedColor;
  final VoidCallback onTap;

  const CategoryColorField({
    super.key,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.dividerColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: selectedColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Category color',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFFA8A0A0),
            ),
          ],
        ),
      ),
    );
  }
}
