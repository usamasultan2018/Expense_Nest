import 'dart:io';
import 'package:expense_tracker/components/custom_button.dart';
import 'package:expense_tracker/components/custom_textfield.dart';
import 'package:expense_tracker/models/user.dart';
import 'package:expense_tracker/utils/appColors.dart';
import 'package:expense_tracker/view%20model/user_controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart'; // To use Provider for UserController
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // For localization

class EditProfileSheet extends StatefulWidget {
  final UserModel userModel;
  const EditProfileSheet({super.key, required this.userModel});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget is first built
    final userController = Provider.of<UserController>(context, listen: false);
    userController.usernameController.text = widget.userModel.username;
    userController.emailController.text = widget.userModel.email;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, _) {
        return IconButton(
          icon: const Icon(Icons.edit),
          iconSize: 17,
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Theme.of(context).cardColor,
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return FractionallySizedBox(
                  heightFactor: 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 20.0,
                        bottom: MediaQuery.of(context)
                            .viewInsets
                            .bottom, // Adjust for keyboard
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                  ),
                                ),
                              ),
                            ),
                            Stack(
                              children: [
                                Consumer<UserController>(
                                  builder: (BuildContext context,
                                      UserController value, Widget? child) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.primary,
                                            width: 2,
                                          )),
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundImage: userController
                                                    .selectedImage !=
                                                null
                                            ? FileImage(
                                                userController.selectedImage!)
                                            : widget.userModel.profilePicture
                                                    .isNotEmpty
                                                ? NetworkImage(widget.userModel
                                                        .profilePicture)
                                                    as ImageProvider
                                                : AssetImage(
                                                    'assets/images/boy.png'), // Replace with your asset image path
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: InkWell(
                                    onTap: () => userController.selectImage(
                                        context, ImageSource.gallery),
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        gradient: AppColors.primaryGradient,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            CustomTextField(
                              controller: userController.usernameController,
                              hintText:
                                  AppLocalizations.of(context)!.usernameHint,
                              iconData: FontAwesomeIcons.user,
                              obscureTxt: false,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: userController.emailController,
                              readOnly: true,
                              hintText: AppLocalizations.of(context)!.email,
                              iconData: FontAwesomeIcons.envelope,
                              obscureTxt: false,
                            ),
                            const SizedBox(height: 20),
                            Consumer<UserController>(
                              builder:
                                  (BuildContext context, value, Widget? child) {
                                return RoundButton(
                                  loading: value.isLoading,
                                  title: AppLocalizations.of(context)!
                                      .updateProfile, // Localized string
                                  onPress: () {
                                    userController
                                        .uploadProfilePictureAndUpdate(
                                      context,
                                      widget.userModel,
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
