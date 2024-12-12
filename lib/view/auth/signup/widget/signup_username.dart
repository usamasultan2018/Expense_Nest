import 'package:expense_tracker/components/custom_textfield.dart';
import 'package:expense_tracker/view%20model/signup_controller/signup_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';

class SignupUsername extends StatelessWidget {
  const SignupUsername({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupController>(
      builder: (BuildContext context, SignupController value, Widget? child) {
        return CustomTextField(
          hintText: AppLocalizations.of(context)!.usernameHint,
          controller: value.usernameController,
          iconData: Icons.person,
          obscureTxt: false,
        );
      },
    );
  }
}
