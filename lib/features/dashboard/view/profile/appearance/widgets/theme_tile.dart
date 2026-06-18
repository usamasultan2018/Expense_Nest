import 'package:expense_tracker/features/dashboard/view/profile/settings/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeTile extends StatelessWidget {
  const ThemeTile({super.key});

  void _showThemeSelector(BuildContext context) {
    final controller = context.read<SettingController>();

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: controller,
          child: Consumer<SettingController>(
            builder: (context, ctrl, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(height: 20),
                  Text(
                    "Choose Theme",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.light_mode),
                    title: const Text("Light"),
                    trailing: ctrl.themeModeOption == ThemeModeOption.light
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      ctrl.setThemeMode(
                        ThemeModeOption.light,
                      );
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text("Dark"),
                    trailing: ctrl.themeModeOption == ThemeModeOption.dark
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      ctrl.setThemeMode(
                        ThemeModeOption.dark,
                      );
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone_android),
                    title: const Text("System"),
                    trailing: ctrl.themeModeOption == ThemeModeOption.system
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      ctrl.setThemeMode(
                        ThemeModeOption.system,
                      );
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
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
      builder: (context, settingController, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _showThemeSelector(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.light_mode,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Theme",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Light, Dark or System",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _getThemeLabel(
                    settingController.themeModeOption,
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _getThemeLabel(
    ThemeModeOption themeMode,
  ) {
    switch (themeMode) {
      case ThemeModeOption.light:
        return "Light";
      case ThemeModeOption.dark:
        return "Dark";
      case ThemeModeOption.system:
        return "System";
    }
  }
}
