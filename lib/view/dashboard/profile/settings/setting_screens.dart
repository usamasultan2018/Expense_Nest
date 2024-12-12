import 'package:expense_tracker/components/custom_button.dart';
import 'package:expense_tracker/components/custom_tile.dart';
import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/repository/user_repositpory.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/utils/helpers/dialog.dart';
import 'package:expense_tracker/utils/helpers/snackbar_util.dart';
import 'package:expense_tracker/view%20model/user_controller/user_controller.dart';
import 'package:expense_tracker/view/auth/login/login.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/delete_account_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/feedback_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/privacy_policy_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/terms_of_services_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/widgets/language_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart'; // Import the localization package

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
                  LanguageTile(),
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
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return PrivacyPolicyScreen();
                      }));
                    },
                    title: AppLocalizations.of(context)!.privacy_policy,
                    iconData: Icons.privacy_tip_sharp,
                    bckColor: AppColors.blue,
                  ),
                  const SizedBox(height: 5),
                  CustomTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return TermsAndServicesScreen();
                      }));
                    },
                    title: AppLocalizations.of(context)!.terms_of_service,
                    iconData: Icons.terminal_sharp,
                    bckColor: AppColors.darkGrey,
                  ),
                  const SizedBox(height: 5),
                  CustomTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return FeedBackScreen();
                      }));
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
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return DeleteAccountScreen();
                      }));
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
}
