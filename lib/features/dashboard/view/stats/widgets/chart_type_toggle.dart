// chart_type_toggle.dart

import 'package:flutter/material.dart';

enum ChartType { line, bar, donut }

class ChartTypeToggle extends StatelessWidget {
  final ChartType selected;
  final ValueChanged<ChartType> onChanged;

  const ChartTypeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
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
  final VoidCallback onTap;

  const _ChartToggleItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color:
              isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
