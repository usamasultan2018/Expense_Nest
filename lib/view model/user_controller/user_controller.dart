import 'dart:io';
import 'package:expense_tracker/models/user.dart';
import 'package:expense_tracker/repository/auth_repository.dart';
import 'package:expense_tracker/repository/user_repositpory.dart';
import 'package:expense_tracker/utils/helpers/image_picker.dart';
import 'package:expense_tracker/utils/helpers/snackbar_util.dart';
import 'package:expense_tracker/utils/helpers/shared_preference.dart'; // For managing session
import 'package:expense_tracker/view/introduction/introduction.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserController extends ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File? selectedImage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Function to pick an image from gallery or camera
  Future<void> selectImage(BuildContext context, ImageSource source) async {
    try {
      File? image = await CustomImagePicker.pickImage(source: source);
      if (image != null) {
        selectedImage = image;
        notifyListeners();
      } else {
        SnackbarUtil.showErrorSnackbar(
            context, AppLocalizations.of(context)!.no_image_selected);
      }
    } catch (e) {
      SnackbarUtil.showErrorSnackbar(
          context, '${AppLocalizations.of(context)!.error_picking_image}: $e');
    }
  }

  Future<void> uploadProfilePictureAndUpdate(
      BuildContext context, UserModel userModel) async {
    setLoading(true);

    try {
      String profilePicUrl = userModel.profilePicture;

      // If a new image is selected, upload and get the new URL
      if (selectedImage != null) {
        profilePicUrl = await UserRepository().uploadProfilePicture(
              selectedImage!,
              userModel.id,
            ) ??
            profilePicUrl; // Fallback to old picture if upload fails
      }

      // Update user data with the new or old profile picture
      UserModel updatedUser = UserModel(
        id: userModel.id,
        username: usernameController.text.isNotEmpty
            ? usernameController.text
            : userModel.username, // Use entered or existing username
        email: userModel.email, // Email is read-only and not updated here
        profilePicture: profilePicUrl,
        createdAt: userModel.createdAt,
      );

      await UserRepository().updateUserData(updatedUser);

      SnackbarUtil.showSuccessSnackbar(
          context, AppLocalizations.of(context)!.profile_updated_successfully);

      Navigator.pop(context); // Close the screen after update
    } catch (e) {
      setLoading(false);
      SnackbarUtil.showErrorSnackbar(context,
          '${AppLocalizations.of(context)!.error_updating_profile}: $e');
    } finally {
      selectedImage = null;
      setLoading(false); // Stop loading
    }
  }

  // Reusable confirmation dialog
  Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                onConfirm(); // Execute the action
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        );
      },
    );
  }

  // Logout function with confirmation
  Future<void> logout(BuildContext context) async {
    showConfirmationDialog(
      context: context,
      title: AppLocalizations.of(context)!.logout_confirmation_title,
      message: AppLocalizations.of(context)!.logout_confirmation_message,
      onConfirm: () async {
        setLoading(true);
        try {
          await HTrackerSharedPreferences.removeKey(
              "userId"); // Clears session data
          SnackbarUtil.showSuccessSnackbar(
              context, AppLocalizations.of(context)!.logged_out_successfully);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
            return Introduction();
          }));
        } catch (e) {
          SnackbarUtil.showErrorSnackbar(context,
              '${AppLocalizations.of(context)!.error_during_logout}: $e');
        } finally {
          setLoading(false);
        }
      },
    );
  }

  // Delete account function with confirmation
  Future<void> deleteAccount(BuildContext context) async {
    showConfirmationDialog(
      context: context,
      title: AppLocalizations.of(context)!.delete_account,
      message: AppLocalizations.of(context)!.delete_account_confirmation,
      onConfirm: () async {
        setLoading(true);
        try {
          await AuthRepository().deleteAccount(context);

          SnackbarUtil.showSuccessSnackbar(context,
              AppLocalizations.of(context)!.account_deleted_successfully);
        } catch (e) {
          SnackbarUtil.showErrorSnackbar(context,
              '${AppLocalizations.of(context)!.error_deleting_account}: $e');
        } finally {
          setLoading(false);
        }
      },
    );
  }
}
