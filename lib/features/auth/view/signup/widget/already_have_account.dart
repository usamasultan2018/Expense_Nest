import 'package:expense_tracker/app/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/features/auth/view/widgets/auth_account_prompt.dart';

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthAccountPrompt(
      message: 'Already have an account?',
      actionText: 'Log In',
      onPressed: () {
        context.goNamed(RouteName.login);
      },
    );
  }
}
