import 'package:expense_tracker/core/utils/google_fonts_helper.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FontTile extends StatelessWidget {
  const FontTile({super.key});
  void _showFonts(BuildContext context) {
    final controller = context.read<SettingController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: controller,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Choose Font",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Consumer<SettingController>(
                      builder: (context, ctrl, _) {
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: FontOption.values.length,
                          itemBuilder: (context, index) {
                            final font = FontOption.values[index];
                            final selected = ctrl.currentFont == font;

                            return ListTile(
                              title: Text(
                                font.label,
                                style: AppFonts.getTextTheme(font)
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                              trailing: Icon(
                                selected
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked,
                                color: selected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                              ),
                              onTap: () {
                                ctrl.setFont(font);
                                Navigator.pop(context);
                              },
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
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _showFonts(context),
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
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.font_download_rounded,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),

                const SizedBox(width: 14),

                // Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Font",
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                // Current Font + Chevron
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.currentFont.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.getTextTheme(
                          controller.currentFont,
                        ).bodyMedium?.fontFamily,
                      ),
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
