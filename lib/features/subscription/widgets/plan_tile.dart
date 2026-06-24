import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../helpers/subscription_helpers.dart';

class PlanTile extends StatelessWidget {
  final Package package;
  final bool isSelected;
  final bool isBestValue;
  final IntroductoryPrice? trial;
  final VoidCallback onTap;

  const PlanTile({
    super.key,
    required this.package,
    required this.isSelected,
    required this.isBestValue,
    required this.trial,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasFreeTrial = trial != null && trial!.price == 0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? colorScheme.primaryContainer.withValues(alpha: 0.35)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: isSelected ? 1.5 : 0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (isBestValue)
              Positioned(
                top: -24,
                left: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.tertiary],
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    '🏆 Best value · Save 40%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                      width: isSelected ? 0 : 1.5,
                    ),
                    color:
                        isSelected ? colorScheme.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded,
                          size: 13, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.storeProduct.title
                            .replaceAll(RegExp(r'\s*\(.*?\)\s*$'), '')
                            .trim(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isSelected ? colorScheme.primary : null,
                        ),
                      ),
                      const SizedBox(height: 3),
                      if (hasFreeTrial)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            '🎁 ${trialLabel(trial!)}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onTertiaryContainer,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      else
                        Text(
                          periodLabel(package),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      package.storeProduct.priceString,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected ? colorScheme.primary : null,
                      ),
                    ),
                    Text(
                      periodLabel(package),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
