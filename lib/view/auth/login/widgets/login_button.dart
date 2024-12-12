import 'package:expense_tracker/components/custom_button.dart';
import 'package:expense_tracker/view%20model/login_controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (BuildContext context, LoginController value, Widget? child) {
        return RoundButton(
            loading: value.isEmailLoading,
            title: AppLocalizations.of(context)!.loginButton,
            onPress: () {
              value.login(context: context);
            });
      },
    );
  }
}
