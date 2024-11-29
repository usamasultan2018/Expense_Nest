import 'package:expense_tracker/view/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.alreadyHaveAccount,
          style: TextStyle(
            fontSize: 14, // Adjust font size
            color: theme.colorScheme.onSurface.withOpacity(0.7), // Softer color
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return LoginScreen();
            }));
          },
          child: Text(
            AppLocalizations.of(context)!.loginButton,
            style: TextStyle(
              fontSize: 15, // Slightly larger for emphasis
              color: theme.colorScheme.primary, // Primary color for button
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}