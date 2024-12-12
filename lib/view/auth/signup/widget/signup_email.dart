import 'package:expense_tracker/components/custom_textfield.dart';
import 'package:expense_tracker/view%20model/signup_controller/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupEmail extends StatelessWidget {
  const SignupEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupController>(
      builder: (BuildContext context, SignupController value, Widget? child) {
        return CustomTextField(
          hintText: AppLocalizations.of(context)!.emailHint,
          controller: value.emailController,
          iconData: FontAwesomeIcons.envelope,
          obscureTxt: false,
        );
      },
    );
    ;
  }
}
