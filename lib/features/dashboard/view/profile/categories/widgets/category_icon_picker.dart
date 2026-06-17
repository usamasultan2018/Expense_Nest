import 'package:flutter/material.dart';

class CategoryIconField extends StatelessWidget {
  final Color selectedColor;
  final IconData selectedIcon;
  final VoidCallback onTap;

  const CategoryIconField({
    super.key,
    required this.selectedIcon,
    required this.onTap, required this.selectedColor,
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
            Icon(
              selectedIcon,
              size: 24,
              color: selectedColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Category icon',
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
