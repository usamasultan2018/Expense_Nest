import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/view%20model/setting_controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingController>(
      builder: (context, languageProvider, child) {
        return Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.language,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!
                        .language, // Correct usage of localization for "language"
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  // Handle the selected value and change the language
                  if (value == 'English') {
                    languageProvider.setLanguage('en');
                  } else if (value == 'Spanish') {
                    languageProvider.setLanguage('es');
                  } else if (value == 'Urdu') {
                    languageProvider.setLanguage('ur');
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'English',
                    child: Text(AppLocalizations.of(context)!
                        .english), // Correct usage of localization for "English"
                  ),
                  PopupMenuItem(
                    value: 'Spanish',
                    child: Text(AppLocalizations.of(context)!
                        .spanish), // Correct usage of localization for "Spanish"
                  ),
                  PopupMenuItem(
                    value: 'Urdu',
                    child: Text(AppLocalizations.of(context)!.urdu),
                  ),
                ],
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        );
      },
    );
  }
}
