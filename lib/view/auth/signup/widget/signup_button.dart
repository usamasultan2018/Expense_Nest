import 'package:expense_tracker/components/custom_button.dart';
import 'package:expense_tracker/view%20model/signup_controller/signup_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupController>(
      builder: (BuildContext context, SignupController value, Widget? child) {
        return RoundButton(
            loading: value.isLoadingEmail,
            title: AppLocalizations.of(context)!.register,
            onPress: () {
              value.register(context);
            });
      },
    );
    ;
  }
}
