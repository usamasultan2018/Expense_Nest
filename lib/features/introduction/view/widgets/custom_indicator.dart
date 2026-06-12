import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {
  final int position;
  final int dotsCount;

  const CustomIndicator({
    super.key,
    required this.position,
    required this.dotsCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        dotsCount,
        (index) {
          final isActive = index == position;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(5),
            ),
          );
        },
      ),
    );
  }
}
