import 'package:expense_tracker/core/components/custom_button.dart';
import 'package:expense_tracker/core/components/custom_textfield.dart';
import 'package:expense_tracker/app/routes/route_name.dart';
import 'package:expense_tracker/core/utils/snackbar_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> sendEmailForgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      SnackbarUtil.showErrorSnackbar(context, 'Email is required');
      return;
    }

    try {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (!mounted) return;

      SnackbarUtil.showSuccessSnackbar(context, 'Password reset email sent');

      if (context.canPop()) {
        context.pop();
      } else {
        context.goNamed(RouteName.login);
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtil.showErrorSnackbar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Forgot password"), // Use localized string
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Enter email", // Localized text
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
                controller: emailController,
                hintText: "Email", // Localized text
                iconData: Icons.email,
                obscureText: false),
            const SizedBox(
              height: 20,
            ),
            RoundButton(
              title: "Reset password", // Localized text
              onPressed: () => sendEmailForgotPassword(),
              loading: isLoading,
            ),
          ]),
        ));
  }
}
