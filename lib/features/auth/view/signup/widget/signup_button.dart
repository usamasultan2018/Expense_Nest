import 'package:expense_tracker/core/components/custom_button.dart';
import 'package:expense_tracker/features/auth/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (BuildContext context, AuthController value, Widget? child) {
        return RoundButton(
            loading: value.isLoadingEmail,
            title: "Sign Up",
            onPressed: () {
              value.register(context);
            });
      },
    );
  }
}
