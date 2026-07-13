import 'package:flutter/material.dart';

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glowing circular design container
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.15),
                        colorScheme.primary.withValues(alpha: 0.0),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    size: 38,
                    color: colorScheme.primary,
                  ),
                ),
                // Tiny decorative floating badge
                Positioned(
                  right: 28,
                  top: 28,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.surface,
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'All Caught Up!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your inbox is empty. We will notify you here when transactions, budget alerts, or reminders occur.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
