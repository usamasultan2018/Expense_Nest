import 'package:expense_tracker/core/components/fade_effect.dart';
import 'package:expense_tracker/core/components/profile_avatar.dart';
import 'package:expense_tracker/core/models/user.dart';
import 'package:expense_tracker/core/utils/helpers/date.dart';
import 'package:expense_tracker/features/dashboard/view/profile/my_account/widgets/edit_profile_sheet.dart';
import 'package:flutter/material.dart';

class UserInfoSection extends StatelessWidget {
  final UserModel userModel;

  const UserInfoSection({
    required this.userModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: FadeTransitionEffect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Section Title
            Text(
              "Login Information",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            /// Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.04,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// Username
                  _InfoTile(
                    title: "Nickname",
                    child: Row(
                      children: [
                        Hero(
                          tag: "profile",
                          child: ProfileAvatar(
                            networkImageUrl: userModel.profilePicture,
                            radius: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            userModel.username,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyLarge,
                          ),
                        ),
                        EditProfileSheet(
                          userModel: userModel,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// Email
                  _InfoTile(
                    title: "Connected Account",
                    child: Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            userModel.email,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// Created Date
                  _InfoTile(
                    title: "Registered On",
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            DateTimeUtils.formatDateMonthDayYear(
                              userModel.createdAt,
                            ),
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Info Tile
class _InfoTile extends StatelessWidget {
  final String title;

  final Widget child;

  const _InfoTile({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).hintColor,
              ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
