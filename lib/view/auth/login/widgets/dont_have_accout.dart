import 'package:expense_tracker/view/auth/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class DontHaveAccount extends StatelessWidget {
  const DontHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.noAccountPrompt,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        TextButton(
          onPressed: () {
            context.go('/signup');
          },
          child: Text(
            AppLocalizations.of(context)!.register,
            style: TextStyle(
              fontSize: 15, // Slightly larger font size for emphasis
              color: theme.colorScheme.primary, // Primary theme color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
