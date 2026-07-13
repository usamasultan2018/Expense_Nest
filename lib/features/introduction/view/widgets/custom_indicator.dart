import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {
  final int position;
  final int dotsCount;
  final Color? activeColor;

  const CustomIndicator({
    super.key,
    required this.position,
    required this.dotsCount,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final active = activeColor ?? colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(dotsCount, (i) {
        final isActive = i == position;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? active : colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
