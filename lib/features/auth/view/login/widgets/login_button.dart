import 'package:expense_tracker/core/components/custom_button.dart';
import 'package:expense_tracker/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (BuildContext context, AuthController value, Widget? child) {
        return RoundButton(
            loading: value.isEmailLoading,
            title: "Login",
            onPressed: () {
              value.login(context: context);
            });
      },
    );
  }
}
