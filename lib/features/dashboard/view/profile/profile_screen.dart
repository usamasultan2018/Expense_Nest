import 'package:expense_tracker/app/routes/route_name.dart';
import 'package:expense_tracker/core/components/app_app_bar.dart';
import 'package:expense_tracker/core/components/custom_group_tiles.dart';
import 'package:expense_tracker/core/components/custom_tile.dart';
import 'package:expense_tracker/core/components/loading_widget.dart';
import 'package:expense_tracker/core/components/profile_avatar.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/setting_screens.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppAppBar.title(
        'Profile',
        showBack: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  context.push(RouteName.settings);
                },
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
                Column(
                  children: [
                    Hero(
                      tag: "profile",
                      child: ProfileAvatar(
                        networkImageUrl: userModel.profilePicture,
                        radius: 55,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userModel.username,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userModel.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _sectionTitle(context, "Account"),
                CustomTileGroup(
                  children: [
                    CustomTile(
                      title: "My Account",
                      subtitle: "View and edit your account details",
                      iconData: Icons.person_outline,
                      bckColor: Colors.blueAccent,
                      onTap: () => context.push(RouteName.myAccount),
                    ),
                    CustomTile(
                      title: "Categories",
                      subtitle: "Manage your expense categories",
                      iconData: Icons.category_outlined,
                      bckColor: Colors.green,
                      onTap: () => context.push(RouteName.categories),
                    ),
                    CustomTile(
                      title: "Appearance",
                      subtitle: "Customize the look and feel of the app",
                      iconData: Icons.palette_outlined,
                      bckColor: Colors.orange,
                      onTap: () => context.push(RouteName.appearance),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _sectionTitle(context, "More"),
                CustomTileGroup(
                  children: [
                    CustomTile(
                      title: "Rate App",
                      subtitle: "Enjoying the app? Please rate us!",
                      iconData: Icons.star_rate_rounded,
                      bckColor: Colors.amber,
                      onTap: () => _showRateAppDialog(context),
                    ),
                    CustomTile(
                      title: "Share App",
                      subtitle: "Tell your friends about ExpenseNest",
                      iconData: Icons.share_outlined,
                      bckColor: Colors.purple,
                      onTap: () async {
                        await Share.share(
                          '''
📊 ExpenseNest

Track expenses, manage budgets, and stay in control of your money.

Download now:
https://play.google.com/store/apps/details?id=com.softtures.expensenest
''',
                          subject: 'ExpenseNest',
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
