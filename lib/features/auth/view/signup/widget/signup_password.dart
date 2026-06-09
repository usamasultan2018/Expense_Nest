import 'package:expense_tracker/core/components/custom_textfield.dart';
import 'package:expense_tracker/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPassword extends StatelessWidget {
  const SignupPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (BuildContext context, AuthController value, Widget? child) {
        return CustomTextField(
          hintText: "Password",
          controller: value.passwordController,
          iconData:Icons.lock_outline,
          obscureText: value.isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              value.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              value.togglePasswordVisibility();
            },
          ),
        );
      },
    );
  }
}
