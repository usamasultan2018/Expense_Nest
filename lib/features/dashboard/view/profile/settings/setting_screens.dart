import 'package:expense_tracker/core/components/custom_group_tiles.dart';
import 'package:expense_tracker/core/components/custom_tile.dart';
import 'package:expense_tracker/core/components/fade_effect.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/controller/app_info_controller.dart';
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: FadeTransitionEffect(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _sectionTitle(context, "Info"),
              const SizedBox(height: 10),
              CustomTileGroup(
                children: [
                  CustomTile(
                    title: "Privacy Policy",
                    subtitle: "Learn how we handle your data",
                    iconData: Icons.privacy_tip_outlined,
                    bckColor: Colors.green,
                    onTap: () => _launchUrl(
                      "https://expensenest.netlify.app/privacy",
                    ),
                  ),
                  CustomTile(
                    title: "Terms of Service",
                    subtitle: "Read the terms and conditions",
                    iconData: Icons.description_outlined,
                    bckColor: Colors.blue,
                    onTap: () => _launchUrl(
                      "https://expensenest.netlify.app/terms",
                    ),
                  ),
                  CustomTile(
                    title: "Contact",
                    subtitle: "Get help or send feedback",
                    iconData: Icons.feedback_outlined,
                    bckColor: Colors.orange,
                    onTap: () => context.push("/contact"),
                  ),
                  Consumer<AppInfoController>(
                    builder: (context, appInfo, _) {
                      return CustomTile(
                        title: "Version",
                        subtitle: appInfo.version.isEmpty
                            ? "Loading..."
                            : "App version ${appInfo.version}",
                        iconData: Icons.info_outline,
                        bckColor: Colors.grey,
                        onTap: null,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _sectionTitle(context, "Session"),
              const SizedBox(height: 10),
              CustomTileGroup(
                children: [
                  Consumer<UserController>(
                    builder: (context, value, _) {
                      return CustomTile(
                        title: "Logout",
                        subtitle: "Sign out from your account",
                        iconData: Icons.logout_rounded,
                        bckColor: Colors.brown,
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
                      );
                    },
                  ),
                  CustomTile(
                    title: "Delete Account",
                    subtitle: "Permanently remove your account",
                    iconData: Icons.delete_outline,
                    bckColor: Colors.red,
                    onTap: () async {
                      final shouldDelete = await _showConfirmationDialog(
                        context,
                        title: "Delete Account",
                        content: "This action cannot be undone. Are you sure?",
                        confirmText: "Delete",
                        isDanger: true,
                      );

                      if (shouldDelete == true) {
                        context.push("/delete-account");
                      }
                    },
                  ),
                ],
              ),
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
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: colorScheme.surface,
          title: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            content,
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDanger ? colorScheme.error : colorScheme.primary,
                foregroundColor:
                    isDanger ? colorScheme.onError : colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
