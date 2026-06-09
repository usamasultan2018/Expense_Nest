import 'package:expense_tracker/core/components/custom_textfield.dart';
import 'package:expense_tracker/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignupEmail extends StatelessWidget {
  const SignupEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (BuildContext context, AuthController value, Widget? child) {
        return CustomTextField(
          hintText: "Email",
          controller: value.emailController,
          iconData: Icons.email_outlined,
          obscureText: false,
        );
      },
    );
  }
}
