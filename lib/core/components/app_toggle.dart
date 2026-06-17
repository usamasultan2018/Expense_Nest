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
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected
                ? colorScheme.onPrimary
                : theme.textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}
