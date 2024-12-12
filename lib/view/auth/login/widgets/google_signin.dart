import 'package:expense_tracker/components/custom_button.dart';
import 'package:expense_tracker/components/google_button.dart';
import 'package:expense_tracker/view%20model/login_controller/login_controller.dart';
import 'package:expense_tracker/view%20model/signup_controller/signup_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class GoogleSigninButton extends StatelessWidget {
  const GoogleSigninButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (BuildContext context, LoginController value, Widget? child) {
        return GoogleButton(
          onPressed: () async {
            await value.googleLogin(context: context);
          },
          loading: value.isGoogleLoading,
        );
      },
    );
  }
}
