import 'package:expense_tracker/components/custom_tile.dart';
import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/repository/auth_repository.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/view%20model/user_controller/user_controller.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/delete_account_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/feedback_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/widgets/language_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings), // Localized title
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: FadeTransitionEffect(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.account, // Localized text
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 5),
                  const LanguageTile(),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.info,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  CustomTile(
                    onTap: () {
                      _launchUrl("https://expensenest.netlify.app/privacy");
                    },
                    title: AppLocalizations.of(context)!.privacy_policy,
                    iconData: Icons.privacy_tip_sharp,
                    bckColor: AppColors.blue,
                  ),
                  const SizedBox(height: 5),
                  CustomTile(
                    onTap: () {
                      _launchUrl("https://expensenest.netlify.app/terms");
                    },
                    title: AppLocalizations.of(context)!.terms_of_service,
                    iconData: Icons.terminal_sharp,
                    bckColor: AppColors.darkGrey,
                  ),
                  const SizedBox(height: 5),
                  CustomTile(
                    onTap: () {
                      (context).push("/contact");
                    },
                    title: AppLocalizations.of(context)!.contact,
                    iconData: Icons.feedback,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.session,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Consumer<UserController>(builder: (BuildContext context,
                      UserController value, Widget? child) {
                    return CustomTile(
                      onTap: () {
                        value.logout(context);
                      },
                      title: AppLocalizations.of(context)!.logout,
                      iconData: Icons.logout,
                      bckColor: AppColors.orange,
                    );
                  }),
                  const SizedBox(height: 5),
                  CustomTile(
                    onTap: () {
                      (context).push("/delete-account");
                    },
                    title: AppLocalizations.of(context)!.delete_account,
                    iconData: Icons.delete,
                    bckColor: AppColors.red,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch the URL');
    } else {
      print("No Internet");
    }
  }
}
