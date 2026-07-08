import 'package:flutter/material.dart';

import '../constants/budget_form_constants.dart';

/// Card showing the alert threshold slider plus quick-pick preset chips.
/// Shown/hidden by the parent based on the "receive alert" toggle.
class AlertThresholdCard extends StatelessWidget {
  final double percent;
  final ValueChanged<double> onChanged;

  const AlertThresholdCard({
    super.key,
    required this.percent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Alert threshold",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Text(
                "${percent.round()}%",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: percent,
              min: 0,
              max: 100,
              divisions: 20,
              label: "${percent.round()}%",
              activeColor: colorScheme.primary,
              inactiveColor: colorScheme.onSurface.withValues(alpha: 0.15),
              onChanged: onChanged,
            ),
          ),
          Wrap(
              spacing: 8,
              children: kAlertPresets.map((preset) {
                final isSelected = percent == preset;
                return ChoiceChip(
                  label: Text("${preset.round()}%"),
                  selected: isSelected,
                  onSelected: (_) => onChanged(preset),
                  selectedColor: colorScheme.primary,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide.none,
                  ),
                );
              }).toList()),
        ],
      ),
    );
  }
}
