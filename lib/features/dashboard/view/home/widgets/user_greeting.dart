import 'package:expense_tracker/core/components/profile_avatar.dart';
import 'package:expense_tracker/core/utils/helpers/skeleton_loading.dart';
import 'package:expense_tracker/features/user/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    print("Rebuilding UserGreeting");

    return Consumer<UserController>(
      builder: (context, controller, child) {
        /// Loading State
        if (controller.isLoading && controller.currentUser == null) {
          return const WelcomeSkeleton();
        }

        final user = controller.currentUser;

        /// Empty State
        if (user == null) {
          return const SizedBox.shrink();
        }

        print("User data: ${user.username}, ${user.profilePicture}");
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.push('/profile');
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: ProfileAvatar(
                    radius: 25,
                    networkImageUrl: user.profilePicture,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back 👋',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
