import 'package:expense_tracker/core/components/fade_effect.dart';
import 'package:expense_tracker/features/auth/controller/auth_controller.dart';
import 'package:expense_tracker/features/auth/view/signup/widget/already_have_account.dart';
import 'package:expense_tracker/features/auth/view/signup/widget/google_signup.dart';
import 'package:expense_tracker/features/auth/view/signup/widget/signup_button.dart';
import 'package:expense_tracker/features/auth/view/signup/widget/signup_email.dart';
import 'package:expense_tracker/features/auth/view/signup/widget/signup_password.dart';
import 'package:expense_tracker/features/auth/view/signup/widget/signup_username.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthController _signupController = AuthController();

  @override
  void dispose() {
    _signupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ChangeNotifierProvider<AuthController>(
            create: (context) => _signupController,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Image.asset(
                      "assets/images/appp_logo.png",
                      width: 70,
                      height: 70,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Create account",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FadeTransitionEffect(
                      child: Text(
                        "Sign up to get started",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SignupUsername(),
                    const SizedBox(
                      height: 20,
                    ),
                    const SignupEmail(),
                    const SizedBox(
                      height: 20,
                    ),
                    const SignupPassword(),
                    const SizedBox(
                      height: 30,
                    ),
                    const SignupButton(),
                    const SizedBox(
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
                    const GoogleSignupButton(),
                    const AlreadyHaveAccount(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
