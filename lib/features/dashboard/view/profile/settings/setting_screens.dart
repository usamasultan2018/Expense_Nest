import 'package:expense_tracker/core/components/custom_tile.dart';
import 'package:expense_tracker/core/components/fade_effect.dart';
import 'package:expense_tracker/core/theme/appColors.dart';
import 'package:expense_tracker/features/user/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: FadeTransitionEffect(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            children: [
              const SizedBox(height: 10),

              /// Info
              _sectionTitle(context, "Info"),

              const SizedBox(height: 10),

              CustomTile(
                onTap: () => _launchUrl(
                  "https://expensenest.netlify.app/privacy",
                ),
                title: "Privacy Policy",
                iconData: Icons.privacy_tip_sharp,
                bckColor: AppColors.blue,
              ),

              const SizedBox(height: 8),

              CustomTile(
                onTap: () => _launchUrl(
                  "https://expensenest.netlify.app/terms",
                ),
                title: "Terms of Service",
                iconData: Icons.description_outlined,
                bckColor: AppColors.darkGrey,
              ),

              const SizedBox(height: 8),

              CustomTile(
                onTap: () {
                  context.push("/contact");
                },
                title: "Contact",
                iconData: Icons.feedback_outlined,
              ),

              const SizedBox(height: 8),

              CustomTile(
                onTap: () {},
                title: "Version 1.0.0",
                iconData: Icons.info_outline,
                bckColor: AppColors.green,
              ),

              const SizedBox(height: 20),

              /// Session
              _sectionTitle(context, "Session"),

              const SizedBox(height: 10),

              Consumer<UserController>(
                builder: (
                  BuildContext context,
                  UserController value,
                  Widget? child,
                ) {
                  return CustomTile(
                    onTap: () async {
                      final shouldLogout = await _showConfirmationDialog(
                        context,
                        title: "Logout",
                        content: "Are you sure you want to logout?",
                        confirmText: "Logout",
                      );

                      if (shouldLogout == true) {
                        value.logout(context);
                      }
                    },
                    title: "Logout",
                    iconData: Icons.logout,
                    bckColor: AppColors.orange,
                  );
                },
              ),

              const SizedBox(height: 8),

              CustomTile(
                onTap: () async {
                  context.push("/delete-account");
                },
                title: "Delete Account",
                iconData: Icons.delete_forever,
                bckColor: AppColors.red,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Title Widget
  static Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  /// Launch URL
  static Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        debugPrint("Could not launch URL");
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  /// Confirmation Dialog
  static Future<bool?> _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmText,
    bool isDanger = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDanger ? Colors.red : null,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
