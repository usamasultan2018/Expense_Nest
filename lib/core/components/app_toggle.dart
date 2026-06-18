import 'package:flutter/material.dart';

class AppToggle<T> extends StatelessWidget {
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final List<ToggleOption<T>> options;

  const AppToggle({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 64,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: options.map((option) {
          return Expanded(
            child: _ToggleSegment(
              label: option.label,
              isSelected: selectedValue == option.value,
              onTap: () => onChanged(option.value),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ToggleOption<T> {
  final String label;
  final T value;

  const ToggleOption({
    required this.label,
    required this.value,
  });
}

class _ToggleSegment extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleSegment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.all(2),
        height: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
