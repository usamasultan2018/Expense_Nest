import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/components/google_button.dart';
import 'package:expense_tracker/view%20model/signup_controller/signup_controller.dart';
import 'package:expense_tracker/view/auth/signup/widget/already_have_account.dart';
import 'package:expense_tracker/view/auth/signup/widget/google_signup.dart';
import 'package:expense_tracker/view/auth/signup/widget/signup_button.dart';
import 'package:expense_tracker/view/auth/signup/widget/signup_email.dart';
import 'package:expense_tracker/view/auth/signup/widget/signup_password.dart';

import 'package:expense_tracker/view/auth/signup/widget/signup_username.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Consumer<SignupController>(
            builder:
                (BuildContext context, SignupController value, Widget? child) {
              return SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 80,
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
                        AppLocalizations.of(context)!.createAccount,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FadeTransitionEffect(
                        child: Text(
                          AppLocalizations.of(context)!.registerDescription,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SignupUsername(),
                      SizedBox(
                        height: 20,
                      ),
                      SignupEmail(),
                      SizedBox(
                        height: 20,
                      ),
                      SignupPassword(),
                      SizedBox(
                        height: 30,
                      ),
                      SignupButton(),
                      SizedBox(
                        height: 20,
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
                          Text("OR"),
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
                      SizedBox(
                        height: 20,
                      ),
                      GoogleSignupButton(),
                      AlreadyHaveAccount(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
