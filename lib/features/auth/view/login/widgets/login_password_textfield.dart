import 'package:expense_tracker/core/components/custom_textfield.dart';
import 'package:expense_tracker/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPasswordTextField extends StatelessWidget {
  const LoginPasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (BuildContext context, AuthController value, Widget? child) {
        return CustomTextField(
          suffixIcon: IconButton(
            icon: Icon(
              value.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              value.togglePasswordVisibility();
            },
          ),
          controller: value.passwordController,
          hintText: "Password",
          iconData:Icons.lock_outline,
          obscureText: value.isPasswordVisible,
        );
      },
    );
  }
}
