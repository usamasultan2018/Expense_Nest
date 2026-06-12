import 'package:expense_tracker/core/components/custom_tile.dart';
import 'package:expense_tracker/core/components/loading_widget.dart';
import 'package:expense_tracker/core/components/profile_avatar.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/setting_screens.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              tooltip: "Settings",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.settings),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<UserController>(
          builder: (context, userController, child) {
            final userModel = userController.currentUser;

            /// Loading State
            if (userController.isLoading) {
              return const Center(
                child: LoadingWidget(),
              );
            }

            /// Empty State
            if (userModel == null) {
              return const Center(
                child: Text(
                  "No user data available",
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              children: [
                const SizedBox(height: 10),

                /// Profile Avatar
                Center(
                  child: Hero(
                    tag: "profile",
                    child: ProfileAvatar(
                      networkImageUrl: userModel.profilePicture,
                      radius: 60,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Username
                Text(
                  userModel.username,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// Email
                Text(
                  userModel.email,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 20),

                /// Account Tile
                CustomTile(
                  onTap: () {
                    context.push("/my-account");
                  },
                  title: "My Account",
                  iconData: Icons.person_outline,
                  bckColor: Colors.blueAccent,
                ),

                const SizedBox(height: 10),

                /// Appearance Tile
                CustomTile(
                  onTap: () {
                    context.push("/appearance");
                  },
                  title: "Appearance",
                  iconData: Icons.color_lens_outlined,
                  bckColor: Colors.purpleAccent,
                ),

                const SizedBox(height: 10),

                /// Rate App Tile
                CustomTile(
                  onTap: () {
                    _showRateAppDialog(context);
                  },
                  title: "Rate App",
                  iconData: Icons.star_rate_rounded,
                  bckColor: Colors.amber,
                ),

                const SizedBox(height: 30),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Rate App Dialog
  static void _showRateAppDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: colorScheme.surface,
          title: Text(
            "Enjoying the app?",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Please take a moment to rate the app.",
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Later",
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                final Uri url = Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.softtures.expensenest',
                );

                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Rate Now"),
            ),
          ],
        );
      },
    );
  }
}
