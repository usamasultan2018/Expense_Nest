import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../subscription/controller/subscription_controller.dart';

class SubscriptionActions extends StatelessWidget {
  final SubscriptionController controller;
  final Package? selectedPackage;
  final VoidCallback onPurchase;

  const SubscriptionActions({
    super.key,
    required this.controller,
    required this.selectedPackage,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasTrial = selectedPackage != null &&
        controller.trialFor(selectedPackage!) != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: controller.isLoading
                    ? null
                    : LinearGradient(
                        colors: [colorScheme.primary, colorScheme.tertiary],
                      ),
                boxShadow: controller.isLoading
                    ? null
                    : [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor:
                      controller.isLoading ? null : Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: controller.isLoading ? null : onPurchase,
                icon: controller.isLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Icon(
                        hasTrial
                            ? Icons.play_circle_outline_rounded
                            : Icons.lock_open_rounded,
                        size: 18,
                      ),
                label: Text(
                  controller.isLoading
                      ? 'Processing...'
                      : hasTrial
                          ? 'Start Free Trial'
                          : 'Unlock Premium',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (hasTrial)
            Text(
              'No charge during trial · Cancel any time',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
