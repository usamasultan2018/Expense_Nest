import 'dart:io';

import 'package:expense_tracker/core/models/account.dart';
import 'package:expense_tracker/core/models/user.dart';
import 'package:expense_tracker/core/repository/auth_repository.dart';
import 'package:expense_tracker/core/repository/user_repositpory.dart';
import 'package:expense_tracker/core/utils/image_picker.dart';
import 'package:expense_tracker/core/utils/snackbar_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends ChangeNotifier {
  UserController({
    UserRepository? userRepository,
    AuthRepository? authRepository,
  })  : _userRepository = userRepository ?? UserRepository(),
        _authRepository = authRepository ?? AuthRepository() {
    fetchUser();
  }

  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  /// Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  /// State
  File? selectedImage;
  bool isLoading = false;
  bool isTransactionCountLoading = false;
  UserModel? currentUser;
  AccountModel? currentAccount;
  int _incomeTransactionCount = 0;
  int _expenseTransactionCount = 0;

  /// Getters
  int get incomeTransactionCount => _incomeTransactionCount;
  int get expenseTransactionCount => _expenseTransactionCount;

  /// Fetch User + Account + Transaction Counts
  Future<void> fetchUser() async {
    isLoading = true;
    notifyListeners();

    final authUser = FirebaseAuth.instance.currentUser;

    if (authUser != null) {
      try {
        final fetchedUser = await _userRepository.getUserData(authUser.uid);

        if (fetchedUser != null) {
          currentUser = fetchedUser; // isPremium comes from Firestore as-is
          usernameController.text = fetchedUser.username;
          emailController.text = fetchedUser.email;
        }

        final fetchedAccount =
            await _userRepository.getAccountData(authUser.uid);
        if (fetchedAccount != null) {
          currentAccount = fetchedAccount;
        }

        await fetchTransactionCounts();
      } catch (e) {
        debugPrint('Error fetching user: $e');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// Fetch Transaction Counts
  Future<void> fetchTransactionCounts() async {
    try {
      isTransactionCountLoading = true;
      notifyListeners();

      final user = currentUser;
      if (user == null) return;

      final counts = await _userRepository.getTransactionCounts(user.id);
      _incomeTransactionCount = counts['income'] ?? 0;
      _expenseTransactionCount = counts['expense'] ?? 0;
    } catch (e) {
      debugPrint('Error fetching transaction counts: $e');
    } finally {
      isTransactionCountLoading = false;
      notifyListeners();
    }
  }

  /// Select Image
  Future<void> selectImage(
    BuildContext context,
    ImageSource source,
  ) async {
    final image = await CustomImagePicker.pickImage(source: source);
    if (image != null) {
      selectedImage = image;
      notifyListeners();
    }
  }

  /// Update Profile — preserves isPremium via toProfileUpdateMap()
  Future<void> uploadProfilePictureAndUpdate(
    BuildContext context,
    UserModel currentUser,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      String profilePictureUrl = currentUser.profilePicture;

      if (selectedImage != null) {
        final uploaded = await _userRepository.uploadProfilePicture(
          selectedImage!,
          currentUser.id,
        );
        if (uploaded != null && uploaded.isNotEmpty) {
          profilePictureUrl = uploaded;
        }
      }

      /// copyWith preserves isPremium and subscriptionStatus
      final updatedUser = currentUser.copyWith(
        username: usernameController.text.trim().isEmpty
            ? currentUser.username
            : usernameController.text.trim(),
        profilePicture: profilePictureUrl,
      );

      /// updateUserData uses toProfileUpdateMap() — never writes isPremium
      await _userRepository.updateUserData(updatedUser);

      this.currentUser = updatedUser;
      selectedImage = null;

      if (context.mounted) {
        Navigator.of(context).pop();
        SnackbarUtil.showSuccessSnackbar(
          context,
          'Profile updated successfully',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(context, e.toString());
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Delete Account
  Future<void> deleteAccount(
    BuildContext context, {
    required String password,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      SnackbarUtil.showErrorSnackbar(context, 'User not found');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final providers = user.providerData.map((e) => e.providerId).toList();
      final bool isGoogleUser = providers.contains('google.com');
      final bool isAppleUser = providers.contains('apple.com');

      if (isGoogleUser) {
        final googleSignIn = GoogleSignIn();
        final googleUser = await googleSignIn.signInSilently();
        if (googleUser != null) {
          final googleAuth = await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await user.reauthenticateWithCredential(credential);
        }
      } else if (isAppleUser) {
        final appleProvider = AppleAuthProvider();
        await user.reauthenticateWithProvider(appleProvider);
      } else {
        final credential = EmailAuthProvider.credential(
          email: user.email ?? '',
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      }

      await _userRepository.deleteUserData(user.uid);
      await user.delete();

      currentUser = null;
      currentAccount = null;
      selectedImage = null;
      _incomeTransactionCount = 0;
      _expenseTransactionCount = 0;

      if (context.mounted) {
        SnackbarUtil.showSuccessSnackbar(
          context,
          'Account deleted successfully',
        );
        context.go('/introduction');
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(
          context,
          e.message ?? 'Authentication failed',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(context, e.toString());
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      await _authRepository.signOut();

      currentUser = null;
      currentAccount = null;
      _incomeTransactionCount = 0;
      _expenseTransactionCount = 0;
      selectedImage = null;

      if (context.mounted) {
        context.go('/introduction');
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(context, e.toString());
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
