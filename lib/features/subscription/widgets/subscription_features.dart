import 'package:flutter/material.dart';

class SubscriptionFeatures extends StatelessWidget {
  const SubscriptionFeatures({super.key});

  static const _features = [
    (Icons.account_balance_wallet_rounded, 'Unlimited budgets'),
    (Icons.cloud_upload_rounded, 'Cloud backup & sync'),
    (Icons.repeat_rounded, 'Recurring transactions'),
    (Icons.bar_chart_rounded, 'Advanced analytics'),
    (Icons.file_download_rounded, 'PDF & CSV export'),
    (Icons.support_agent_rounded, 'Priority support'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Everything included',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 4.2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 4,
            children: _features
                .map((f) => _FeatureTile(icon: f.$1, label: f.$2))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: colorScheme.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
