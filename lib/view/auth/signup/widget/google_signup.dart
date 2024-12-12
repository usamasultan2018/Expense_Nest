import 'package:expense_tracker/components/custom_button.dart';
import 'package:expense_tracker/components/google_button.dart';
import 'package:expense_tracker/view%20model/signup_controller/signup_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class GoogleSignupButton extends StatelessWidget {
  const GoogleSignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupController>(
      builder: (BuildContext context, SignupController value, Widget? child) {
        return GoogleButton(
          onPressed: () async {
            await value.registerWithGoogle(context);
          },
          loading: value.isLoadingGoogle,
        );
      },
    );
  }
}
