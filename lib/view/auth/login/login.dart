import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/components/google_button.dart';
import 'package:expense_tracker/view/auth/login/widgets/dont_have_accout.dart';
import 'package:expense_tracker/view/auth/login/widgets/google_signin.dart';
import 'package:expense_tracker/view/auth/login/widgets/login_button.dart';
import 'package:expense_tracker/view/auth/login/widgets/login_emailTextfield.dart';
import 'package:expense_tracker/view/auth/login/widgets/login_password_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Image.asset(
                  "assets/images/appp_logo.png",
                  width: 70,
                  height: 70,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                FadeTransitionEffect(
                  child: Text(
                    AppLocalizations.of(context)!.youveBeenMissed,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const LoginEmailTextField(),
                const SizedBox(
                  height: 20,
                ),
                const LoginPasswordTextField(),
                const SizedBox(
                  height: 30,
                ),
                const LoginButton(),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).cardColor,
                        height: 0.5,
                        endIndent: 10,
                        indent: 10,
                      ),
                    ),
                    const Text("OR"),
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).cardColor,
                        height: 0.5,
                        endIndent: 10,
                        indent: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GoogleSigninButton(),
                const DontHaveAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
