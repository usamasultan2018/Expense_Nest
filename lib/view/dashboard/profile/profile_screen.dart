import 'package:expense_tracker/components/custom_tile.dart';
import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/components/loading_widget.dart';
import 'package:expense_tracker/models/user.dart';
import 'package:expense_tracker/repository/user_repositpory.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/view/dashboard/profile/my_account/my_account_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/setting_screens.dart';
import 'package:expense_tracker/view/dashboard/profile/appearance/appearance_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("No user is currently logged in."));
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return SettingsScreen();
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
              stream: UserRepository().streamUserData(currentUser.uid),
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
                        SizedBox(
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
                        SizedBox(
                          height: 20,
                        ),
                        CustomTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return MyAccountScreen();
                            }));
                          },
                          title: AppLocalizations.of(context)!.my_account,
                          iconData: Icons.person,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return AppearanceScreen();
                            }));
                          },
                          title: AppLocalizations.of(context)!.appearance,
                          iconData: FontAwesomeIcons.paintRoller,
                          bckColor: AppColors.yellow,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
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
