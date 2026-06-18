import 'package:expense_tracker/features/dashboard/view/profile/settings/controller/setting_controller.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget _buildColorSwatch(FlexSchemeColor colors) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: colors.primary,
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: colors.tertiary,
            ),
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: colors.secondary,
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
            ),
          ),
        ],
      ),
    ],
  );
}

class ColorSchemeTile extends StatelessWidget {
  const ColorSchemeTile({super.key});

  void _showColorSchemeBottomSheet(BuildContext context) {
    final controller = context.read<SettingController>();
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: controller,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.92,
            builder: (context, scrollController) {
              return Column(
                children: [
                  // Handle bar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // List of schemes
                  Expanded(
                    child: Consumer<SettingController>(
                      builder: (context, ctrl, _) {
                        final schemes = FlexScheme.values
                            .where((s) => FlexColor.schemes.containsKey(s))
                            .toList();

                        return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: schemes.length,
                          itemBuilder: (context, index) {
                            final scheme = schemes[index];
                            final data = FlexColor.schemes[scheme]!;
                            final selected = ctrl.currentScheme == scheme;

                            return ListTile(
                              onTap: () {
                                ctrl.setColorScheme(scheme);
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 4,
                              ),
                              leading: _buildColorSwatch(data.light),
                              title: Text(
                                data.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: selected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                              ),
                              trailing: Icon(
                                selected
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked,
                                color: selected
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.4),
                                size: 20,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingController>(
      builder: (context, controller, child) {
        final data = FlexColor.schemes[controller.currentScheme];
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _showColorSchemeBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                // Leading Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.palette_outlined,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 14),

                // Label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Color Scheme",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Choose your accent colors",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // 2x2 swatch + chevron
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (data != null)
                      Row(
                        children: [
                          _buildColorSwatch(data.light),
                          const SizedBox(width: 8),
                          Text(
                            "Colors",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
