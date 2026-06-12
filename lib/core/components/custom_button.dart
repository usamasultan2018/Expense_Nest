import 'package:flutter/material.dart';
import 'package:expense_tracker/core/components/loading_widget.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool loading;
  final double height;
  final double borderRadius;
  final double width;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.loading = false,
    this.height = 50,
    this.width = double.infinity,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDisabled = loading || onPressed == null;

    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isDisabled ? null : onPressed,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: isDisabled
                  ? colorScheme.primary.withValues(alpha: 0.6)
                  : colorScheme.primary,
            ),
            child: Center(
              child: loading
                  ? const LoadingWidget()
                  : Text(
                      title,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
