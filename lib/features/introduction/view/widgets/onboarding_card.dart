import 'package:animate_do/animate_do.dart';
import 'package:expense_tracker/core/models/onboarding.dart';
import 'package:flutter/material.dart';

class OnBoardingCard extends StatelessWidget {
  final Onboarding onboarding;
  final int index;

  const OnBoardingCard({
    super.key,
    required this.onboarding,
    required this.index,
  });

  IconData get _icon {
    switch (index % 3) {
      case 0:
        return Icons.track_changes_rounded;
      case 1:
        return Icons.grid_view_rounded;
      case 2:
      default:
        return Icons.insights_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon in a soft tinted circle
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.08),
            ),
            child: Icon(
              _icon,
              size: 44,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(height: 40),

          Text(
            onboarding.title1,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
          ),

          const SizedBox(height: 12),

          Text(
            onboarding.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                ),
          ),
        ],
      ),
    );
  }
}
