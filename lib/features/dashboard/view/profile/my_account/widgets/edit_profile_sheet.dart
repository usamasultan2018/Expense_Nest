import 'package:animate_do/animate_do.dart';
import 'package:expense_tracker/core/components/custom_button.dart';
import 'package:expense_tracker/core/components/custom_textfield.dart';
import 'package:expense_tracker/core/components/profile_avatar.dart';
import 'package:expense_tracker/core/models/user.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileSheet extends StatelessWidget {
  final UserModel userModel;

  const EditProfileSheet({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Edit Profile",
      icon: const Icon(
        Icons.edit_outlined,
        size: 20,
      ),
      onPressed: () {
        final userController = context.read<UserController>();

        /// Prefill
        userController.usernameController.text = userModel.username;

        userController.emailController.text = userModel.email;

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) {
            return FadeInUp(
              duration: const Duration(milliseconds: 250),
              child: _EditProfileContent(
                userModel: userModel,
              ),
            );
          },
        );
      },
    );
  }
}

class _EditProfileContent extends StatelessWidget {
  final UserModel userModel;

  const _EditProfileContent({
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userController = context.watch<UserController>();

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// Drag Handle
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 25),

            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Edit Profile",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Hero(
                  tag: "profile",
                  child: ProfileAvatar(
                    networkImageUrl: userModel.profilePicture,
                    localImage: userController.selectedImage,
                    radius: 55,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    userController.selectImage(
                      context,
                      ImageSource.gallery,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

                /// Username
                CustomTextField(
                  controller: userController.usernameController,
                  hintText: "Username",
                  iconData: Icons.person_outline,
                  obscureText: false,
                ),

            const SizedBox(height: 16),

                /// Email
                CustomTextField(
                  controller: userController.emailController,
                  readOnly: true,
                  hintText: "Email",
                  iconData: Icons.email_outlined,
                  obscureText: false,
                ),

            const SizedBox(height: 30),

            /// Update Button
            SizedBox(
              width: double.infinity,
              child: RoundButton(
                loading: userController.isLoading,
                title: "Update Profile",
                onPressed: () async {
                  await userController.uploadProfilePictureAndUpdate(
                    context,
                    userModel,
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
