import 'package:expense_tracker/core/components/profile_avatar.dart';
import 'package:expense_tracker/core/utils/skeleton_loading.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, controller, child) {
        /// Loading State
        if (controller.isLoading && controller.currentUser == null) {
          return const WelcomeSkeleton();
        }

        final user = controller.currentUser;

        /// Empty State
        if (user == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              /// Avatar
              GestureDetector(
                onTap: () => context.push('/profile'),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.25),
                      width: 2,
                    ),
                  ),
                  child: ProfileAvatar(
                    radius: 24,
                    networkImageUrl: user.profilePicture,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// Greeting + Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back 👋',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),

              // /// Notification Bell
              // GestureDetector(
              //   onTap: () => context.push('/notifications'),
              //   child: Container(
              //     width: 40,
              //     height: 40,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color:
              //           Theme.of(context).colorScheme.surfaceContainerHighest,
              //       border: Border.all(
              //         color: Theme.of(context)
              //             .dividerColor
              //             .withValues(alpha: 0.15),
              //         width: 0.5,
              //       ),
              //     ),
              //     child: Stack(
              //       alignment: Alignment.center,
              //       children: [
              //         Icon(
              //           Icons.notifications_outlined,
              //           size: 20,
              //           color: Theme.of(context).colorScheme.onSurface,
              //         ),

              //         /// Unread badge — hide if no notifications
              //         Positioned(
              //           top: 8,
              //           right: 9,
              //           child: Container(
              //             width: 7,
              //             height: 7,
              //             decoration: BoxDecoration(
              //               color: Theme.of(context).colorScheme.error,
              //               shape: BoxShape.circle,
              //               border: Border.all(
              //                 color: Theme.of(context).scaffoldBackgroundColor,
              //                 width: 1.5,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
