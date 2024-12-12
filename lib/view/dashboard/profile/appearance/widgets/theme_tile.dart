import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/view%20model/setting_controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ThemeTile extends StatelessWidget {
  const ThemeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingController>(
      builder: (context, settingController, child) {
        return Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Theme section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.brightness_6,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.theme,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
              // Theme menu
              PopupMenuButton<String>(
                onSelected: (value) {
                  // Update the theme in the SettingController
                  if (value == 'Light') {
                    settingController.setThemeMode(ThemeModeOption.light);
                  } else if (value == 'Dark') {
                    settingController.setThemeMode(ThemeModeOption.dark);
                  } else if (value == 'System') {
                    settingController.setThemeMode(
                      ThemeModeOption.system,
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'Light',
                    child: Text(AppLocalizations.of(context)!.light),
                  ),
                  PopupMenuItem(
                    value: 'Dark',
                    child: Text(AppLocalizations.of(context)!.dark),
                  ),
                  PopupMenuItem(
                    value: 'System',
                    child: Text(AppLocalizations.of(context)!.system),
                  ),
                ],
                icon: const Icon(Icons.arrow_forward_ios),
                offset: const Offset(0, -40),
              ),
            ],
          ),
        );
      },
    );
  }
}
