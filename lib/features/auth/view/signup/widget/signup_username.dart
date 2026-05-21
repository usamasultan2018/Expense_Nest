import 'package:expense_tracker/core/components/custom_textfield.dart';
import 'package:expense_tracker/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SignupUsername extends StatelessWidget {
  const SignupUsername({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (BuildContext context, AuthController value, Widget? child) {
        return CustomTextField(
          hintText: "Username",
          controller: value.usernameController,
          iconData: Icons.person,
          obscureText: false,
        );
      },
    );
  }
}
