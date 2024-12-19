import 'package:expense_tracker/components/custom_button.dart';
import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/utils/helpers/shared_preference.dart';
import 'package:expense_tracker/view%20model/user_controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = UserPreferences.getUser();

    if (user == null) {
      return const Center(
        child: Text("User is not logged in."),
      );
    }
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer<UserController>(builder:
            (BuildContext context, UserController value, Widget? child) {
          return RoundButton(
              loading: value.isLoading,
              title: AppLocalizations.of(context)!.delete_account,
              onPress: () async {
                await value.deleteAccount(
                  context,
                );
              });
        }),
      ),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.delete_account,
        ),
      ),
      body: SingleChildScrollView(
        child: FadeTransitionEffect(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text("${user.username}"),
              SizedBox(
                height: 5,
              ),
              Text(
                AppLocalizations.of(context)!.delete_account_details,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.delete_account_warning,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                AppLocalizations.of(context)!.delete_account_details,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
