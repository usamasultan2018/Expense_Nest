import 'package:expense_tracker/app/routes/route_name.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/features/auth/view/widgets/auth_account_prompt.dart';
import 'package:flutter/material.dart';

class DontHaveAccount extends StatelessWidget {
  const DontHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthAccountPrompt(
      message: "Don't have an account?",
      actionText: 'Sign Up',
      onPressed: () {
        context.pushNamed(RouteName.signup);
      },
    );
  }
}
