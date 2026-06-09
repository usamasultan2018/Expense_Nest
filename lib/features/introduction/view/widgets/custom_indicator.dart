import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {
  final int position;
  final int dotsCount;

  const CustomIndicator({
    required this.position,
    required this.dotsCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DotsIndicator(
      dotsCount: dotsCount,
      position: position,
      decorator: DotsDecorator(
        color: colorScheme.onSurfaceVariant.withOpacity(0.4),
        size: const Size.square(8.0),
        activeSize: const Size(20.0, 8.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        activeColor: colorScheme.primary,
      ),
    );
  }
}
