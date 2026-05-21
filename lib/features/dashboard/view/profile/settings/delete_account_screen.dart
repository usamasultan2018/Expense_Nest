import 'package:expense_tracker/core/components/custom_button.dart';
import 'package:expense_tracker/core/components/custom_textfield.dart';
import 'package:expense_tracker/core/components/fade_effect.dart';
import 'package:expense_tracker/features/user/controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    emailController.text = user?.email ?? '';
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "User is not logged in.",
          ),
        ),
      );
    }

    final providers = user.providerData.map((e) => e.providerId).toList();

    final bool isGoogleUser = providers.contains('google.com');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Delete Account",
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          25,
        ),
        child: Consumer<UserController>(
          builder: (
            context,
            controller,
            child,
          ) {
            return RoundButton(
              loading: controller.isLoading,
              title: "Delete Account",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await controller.deleteAccount(
                    context,
                    password: passwordController.text,
                  );
                }
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: FadeTransitionEffect(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// WARNING CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(
                      22,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(
                        24,
                      ),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(
                            18,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(
                              0.12,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delete_forever,
                            size: 40,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          "Delete Your Account",
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "This action is permanent and cannot be undone.",
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 35,
                  ),

                  /// EMAIL FIELD
                  CustomTextField(
                    controller: emailController,
                    readOnly: true,
                    labelText: "Email Address",
                    iconData: Icons.email,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  /// PASSWORD FIELD
                  if (!isGoogleUser)
                    CustomTextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      labelText: "Confirm Password",
                      iconData: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }

                        return null;
                      },
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),

                  const SizedBox(
                    height: 25,
                  ),

                  Text(
                    "Deleting your account will permanently remove all your transactions, profile data, and settings.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.5,
                          color: Theme.of(
                            context,
                          ).hintColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
