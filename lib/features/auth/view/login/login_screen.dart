import 'package:expense_tracker/app/routes/route_name.dart';
import 'package:expense_tracker/core/components/fade_effect.dart';
import 'package:expense_tracker/features/auth/controller/auth_controller.dart';
import 'package:expense_tracker/features/auth/view/login/widgets/dont_have_accout.dart';
import 'package:expense_tracker/features/auth/view/login/widgets/google_signin.dart';
import 'package:expense_tracker/features/auth/view/login/widgets/login_button.dart';
import 'package:expense_tracker/features/auth/view/login/widgets/login_emailTextfield.dart';
import 'package:expense_tracker/features/auth/view/login/widgets/login_password_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _loginController = AuthController();

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<AuthController>(
        create: (context) => _loginController,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
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
                    "Welcome back",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  FadeTransitionEffect(
                    child: Text(
                      "You've been missed",
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
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        context.push(RouteName.forgotPassword);
                      },
                      child: const Text("Forgot password"),
                    ),
                  ),
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
                  const GoogleSigninButton(),
                  const DontHaveAccount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
