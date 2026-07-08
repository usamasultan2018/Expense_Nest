import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BudgetEmptyCard extends StatelessWidget {
  const BudgetEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Illustration bubble ─────────────────────────────────────────
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer.withValues(alpha: 0.55),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Faint ring
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.18),
                      width: 2,
                    ),
                  ),
                ),
                Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 44,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Headline ────────────────────────────────────────────────────
          Text(
            'No budgets yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Set a spending limit for each category\nand stay on top of your finances.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),

          const SizedBox(height: 28),

          // ── CTA button ──────────────────────────────────────────────────
          FilledButton.icon(
            onPressed: () => context.push('/add-budget'),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text(
              'Create a budget',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Tips row ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Tip(
                icon: Icons.track_changes_rounded,
                label: 'Track spending',
                color: colorScheme.primary,
              ),
              const SizedBox(width: 16),
              _Tip(
                icon: Icons.notifications_active_outlined,
                label: 'Get alerts',
                color: Colors.orange,
              ),
              const SizedBox(width: 16),
              _Tip(
                icon: Icons.savings_outlined,
                label: 'Save more',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
