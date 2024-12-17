import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

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
            context.go('/login'); // Navigates to '/login' path
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
