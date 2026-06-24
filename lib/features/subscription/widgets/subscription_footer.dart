import 'package:flutter/material.dart';

import '../../subscription/controller/subscription_controller.dart';

class SubscriptionFooter extends StatelessWidget {
  final SubscriptionController controller;
  final VoidCallback onRestore;

  const SubscriptionFooter({
    super.key,
    required this.controller,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: controller.isLoading ? null : onRestore,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Restore purchases',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text('·',
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
          TextButton(
            onPressed: () {/* open privacy policy */},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Privacy',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
          ),
          Text('·',
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
          TextButton(
            onPressed: () {/* open terms */},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Terms',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}
