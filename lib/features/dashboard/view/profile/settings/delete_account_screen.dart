import 'package:expense_tracker/core/components/custom_button.dart';
import 'package:expense_tracker/core/components/custom_textfield.dart';
import 'package:expense_tracker/core/components/fade_effect.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
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
        body: Center(child: Text("User is not logged in.")),
      );
    }

    final providers = user.providerData.map((e) => e.providerId).toList();
    final bool isGoogleUser = providers.contains('google.com');
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Delete Account"),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Consumer<UserController>(
            builder: (context, controller, child) {
              return RoundButton(
                loading: controller.isLoading,
                title: "Delete My Account",
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: FadeTransitionEffect(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ── HERO BANNER ──────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Animated icon container
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withValues(alpha: 0.12),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.25),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.delete_forever_rounded,
                            size: 38,
                            color: Colors.red,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Delete Your Account?",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "This action is permanent and cannot be undone.",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// ── WHAT WILL BE DELETED ─────────────────────────────
                  Text(
                    "What will be deleted",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        _buildDeletionItem(
                          context: context,
                          icon: Icons.receipt_long_rounded,
                          label: "All transactions & history",
                          isLast: false,
                        ),
                        _buildDeletionItem(
                          context: context,
                          icon: Icons.person_rounded,
                          label: "Profile & personal data",
                          isLast: false,
                        ),
                        _buildDeletionItem(
                          context: context,
                          icon: Icons.settings_rounded,
                          label: "Preferences & settings",
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// ── CONFIRM IDENTITY ─────────────────────────────────
                  Text(
                    "Confirm your identity",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// EMAIL FIELD
                  CustomTextField(
                    controller: emailController,
                    readOnly: true,
                    labelText: "Email Address",
                    iconData: Icons.email_outlined,
                  ),

                  /// PASSWORD FIELD
                  if (!isGoogleUser) ...[
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      labelText: "Confirm Password",
                      iconData: Icons.lock_outline_rounded,
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
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeletionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isLast,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 18,
            endIndent: 18,
            color: theme.dividerColor.withValues(alpha: 0.5),
          ),
      ],
    );
  }
}
