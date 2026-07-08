import 'package:flutter/material.dart';

/// A tappable field styled like a dropdown, used for "Category" and
/// "Month" selection. Opens whatever picker is passed via [onTap].
class SelectField extends StatelessWidget {
  final String hint;
  final String? value;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final VoidCallback onTap;

  const SelectField({
    super.key,
    required this.hint,
    required this.value,
    required this.onTap,
    this.leadingIcon,
    this.leadingIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEmpty = value == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEmpty
                ? colorScheme.outline.withValues(alpha: 0.4)
                : colorScheme.primary.withValues(alpha: 0.5),
          ),
          color: isEmpty
              ? Colors.transparent
              : colorScheme.primaryContainer.withValues(alpha: 0.15),
        ),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                color: leadingIconColor ?? colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isEmpty
                      ? colorScheme.onSurface.withValues(alpha: 0.5)
                      : colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
