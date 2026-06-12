import 'package:expense_tracker/features/dashboard/view/profile/settings/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeTile extends StatelessWidget {
  const ThemeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingController>(
      builder: (context, settingController, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final currentTheme = settingController.themeModeOption;

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Leading Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.light_mode,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),

              const SizedBox(width: 14),

              /// Title + Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Theme",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              /// Popup Menu
              PopupMenuButton<ThemeModeOption>(
                tooltip: "Change Theme",
                onSelected: (ThemeModeOption value) {
                  settingController.setThemeMode(value);
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: ThemeModeOption.light,
                    child: Row(
                      children: [
                        const Icon(Icons.light_mode),
                        const SizedBox(width: 10),
                        const Text("Light"),
                        const Spacer(),
                        if (currentTheme == ThemeModeOption.light)
                          Icon(
                            Icons.check,
                            color: colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: ThemeModeOption.dark,
                    child: Row(
                      children: [
                        const Icon(Icons.dark_mode),
                        const SizedBox(width: 10),
                        const Text("Dark"),
                        const Spacer(),
                        if (currentTheme == ThemeModeOption.dark)
                          Icon(
                            Icons.check,
                            color: colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: ThemeModeOption.system,
                    child: Row(
                      children: [
                        const Icon(Icons.phone_android),
                        const SizedBox(width: 10),
                        const Text("System"),
                        const Spacer(),
                        if (currentTheme == ThemeModeOption.system)
                          Icon(
                            Icons.check,
                            color: colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.scaffoldBackgroundColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getThemeLabel(currentTheme),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
