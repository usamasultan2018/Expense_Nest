import 'package:flutter/material.dart';

enum ChartType { line, bar, donut }

class ChartTypeToggle extends StatelessWidget {
  final ChartType selected;
  final ValueChanged<ChartType> onChanged;
  final bool isPremium;

  const ChartTypeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ChartToggleItem(
            icon: Icons.show_chart_rounded,
            isSelected: selected == ChartType.line,
            onTap: () => onChanged(ChartType.line),
          ),
          const SizedBox(width: 4),
          _ChartToggleItem(
            icon: Icons.bar_chart_rounded,
            isSelected: selected == ChartType.bar,
            isLocked: !isPremium, // ← show lock badge when not premium
            onTap: () => onChanged(ChartType.bar),
          ),
          const SizedBox(width: 4),
          _ChartToggleItem(
            icon: Icons.donut_large_rounded,
            isSelected: selected == ChartType.donut,
            onTap: () => onChanged(ChartType.donut),
          ),
        ],
      ),
    );
  }
}

class _ChartToggleItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  const _ChartToggleItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSelected
                  ? colorScheme.onPrimary
                  : isLocked
                      ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                      : colorScheme.onSurfaceVariant,
            ),
          ),

          // Premium lock badge — top-right corner of the button
          if (isLocked)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: 8,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
