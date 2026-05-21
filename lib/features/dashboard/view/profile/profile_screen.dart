import 'package:expense_tracker/core/components/banner_ad_widget.dart';
import 'package:expense_tracker/core/components/custom_tile.dart';
import 'package:expense_tracker/core/components/fade_effect.dart';
import 'package:expense_tracker/core/components/loading_widget.dart';
import 'package:expense_tracker/core/components/profile_avatar.dart';
import 'package:expense_tracker/core/theme/appColors.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/setting_screens.dart';
import 'package:expense_tracker/features/user/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  color: Theme.of(context).cardColor,
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 6),

                /// Email
                Text(
                  userModel.email,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
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
                ),

                const SizedBox(height: 10),

                /// Appearance Tile
                CustomTile(
                  onTap: () {
                    context.push("/appearance");
                  },
                  title: "Appearance",
                  iconData: FontAwesomeIcons.paintRoller,
                  bckColor: AppColors.yellow,
                ),

                const SizedBox(height: 10),

                /// Rate App Tile
                CustomTile(
                  onTap: () {
                    _showRateAppDialog(context);
                  },
                  title: "Rate App",
                  iconData: Icons.star_rate_rounded,
                  bckColor: AppColors.green,
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
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Enjoying the app?"),
          content: const Text(
            "Please take a moment to rate the app.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Later"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                /// TODO:
                /// Add Play Store / App Store launch
              },
              child: const Text("Rate Now"),
            ),
          ],
        );
      },
    );
  }
}
