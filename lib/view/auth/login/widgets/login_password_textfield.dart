import 'package:expense_tracker/components/custom_textfield.dart';
import 'package:expense_tracker/view%20model/login_controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPasswordTextField extends StatelessWidget {
  const LoginPasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (BuildContext context, LoginController value, Widget? child) {
        return CustomTextField(
          controller: value.passwordController,
          hintText: AppLocalizations.of(context)!.passwordHint,
          iconData: FontAwesomeIcons.lock,
          obscureTxt: true,
        );
      },
    );
  }
}
