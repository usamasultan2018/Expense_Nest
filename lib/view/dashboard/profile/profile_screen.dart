import 'package:expense_tracker/components/custom_tile.dart';
import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/components/loading_widget.dart';
import 'package:expense_tracker/models/user.dart';
import 'package:expense_tracker/repository/auth_repository.dart';
import 'package:expense_tracker/repository/user_repositpory.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/utils/helpers/shared_preference.dart';
import 'package:expense_tracker/view/dashboard/profile/my_account/my_account_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/setting_screens.dart';
import 'package:expense_tracker/view/dashboard/profile/appearance/appearance_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = UserPreferences.getUser();

    if (user == null) {
      return const Center(
        child: Text("User is not logged in."),
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return const SettingsScreen();
                }));
              },
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).cardColor,
                  ),
                  child: const Icon(Icons.settings)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<UserModel?>(
              stream: UserRepository().streamUserData(user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text("No user data available."));
                }
                final UserModel userModel = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FadeTransitionEffect(
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color: AppColors.primary,
                                )),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: userModel
                                      .profilePicture.isNotEmpty
                                  ? NetworkImage(userModel.profilePicture)
                                  : const AssetImage('assets/images/boy.png')
                                      as ImageProvider<Object>,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          userModel.username,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(userModel.email),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTile(
                          onTap: () {
                            (context).push("/my-account");
                          },
                          title: AppLocalizations.of(context)!.my_account,
                          iconData: Icons.person,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTile(
                          onTap: () {
                            (context).push("/appearance");
                          },
                          title: AppLocalizations.of(context)!.appearance,
                          iconData: FontAwesomeIcons.paintRoller,
                          bckColor: AppColors.yellow,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTile(
                          title: AppLocalizations.of(context)!.rate_app,
                          iconData: Icons.star,
                          bckColor: AppColors.green,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
