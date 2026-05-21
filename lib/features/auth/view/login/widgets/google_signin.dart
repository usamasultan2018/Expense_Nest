import 'package:expense_tracker/core/components/google_button.dart';
import 'package:expense_tracker/features/auth/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class GoogleSigninButton extends StatelessWidget {
  const GoogleSigninButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (BuildContext context, AuthController value, Widget? child) {
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
