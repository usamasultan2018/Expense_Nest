import 'package:expense_tracker/components/fade_effect.dart';
import 'package:expense_tracker/repository/user_repositpory.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/utils/helpers/skeleton.dart';
import 'package:expense_tracker/view/dashboard/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:firebase_auth/firebase_auth.dart';

class UserData extends StatelessWidget {
  const UserData({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("No user is currently logged in."));
    }

    return StreamBuilder<UserModel?>(
      stream: UserRepository().streamUserData(currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const WelcomeSkeleton();
        } else if (snapshot.hasError) {
          return const Center(
              child: Text("An error occurred. Please try again."));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("No user data found."));
        } else {
          final userModel = snapshot.data!; // No need to check for null here

          return FadeTransitionEffect(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return const ProfileScreen();
                    }));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: AppColors.primary,
                        )),
                    child: CircleAvatar(
                      radius: 25, // Adjust the radius as needed
                      backgroundImage: userModel.profilePicture.isNotEmpty
                          ? NetworkImage(userModel.profilePicture)
                          : const AssetImage(
                                  'assets/images/boy.png') // Default image
                              as ImageProvider<Object>, // Cast to ImageProvider
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome back",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                    Text(
                        AppLocalizations.of(context)!
                            .username(userModel.username),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
