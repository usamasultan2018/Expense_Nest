import 'package:expense_tracker/repository/auth_repository.dart';
import 'package:expense_tracker/utils/helpers/firebase_exception_handler.dart';
import 'package:expense_tracker/utils/helpers/snackbar_util.dart';
import 'package:expense_tracker/view/auth/login/login.dart';
import 'package:expense_tracker/view/dashboard/bottom_nav/bottom_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoadingEmail = false; // Loading state for email/password registration
  bool _isLoadingGoogle = false; // Loading state for Google sign-up

  bool get isLoadingEmail => _isLoadingEmail;
  bool get isLoadingGoogle => _isLoadingGoogle;

  void setLoadingEmail(bool value) {
    _isLoadingEmail = value;
    notifyListeners();
  }

  void setLoadingGoogle(bool value) {
    _isLoadingGoogle = value;
    notifyListeners();
  }

  Future<void> register(BuildContext context) async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      SnackbarUtil.showErrorSnackbar(
          context, AppLocalizations.of(context)!.pleaseFillAllFields);
      return;
    }

    setLoadingEmail(true);

    try {
      User? user = await _authRepository.signUp(
        emailController.text,
        passwordController.text,
        usernameController.text,
      );

      if (user != null) {
        // Clear the fields and show success message
        usernameController.clear();
        emailController.clear();
        passwordController.clear();

        SnackbarUtil.showSuccessSnackbar(
            context, AppLocalizations.of(context)!.checkEmail);

        // Navigate to the login screen without popping the registration screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => const LoginScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = FirebaseExceptionHandler.handleException(e);
      SnackbarUtil.showErrorSnackbar(context, errorMessage);
    } catch (e) {
      SnackbarUtil.showErrorSnackbar(
          context, AppLocalizations.of(context)!.unexpectedError);
    } finally {
      setLoadingEmail(false);
    }
  }

  Future<void> registerWithGoogle(BuildContext context) async {
    setLoadingGoogle(true);

    try {
      User? user = await _authRepository.signUpWithGoogle();

      if (user != null) {
        SnackbarUtil.showSuccessSnackbar(
            context, AppLocalizations.of(context)!.googleLoginSuccessful);

        // Navigate to the login screen or home screen after successful sign-up
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (ctx) => const BottomNavigatorWidget(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      SnackbarUtil.showErrorSnackbar(context, e.toString());
    } finally {
      setLoadingGoogle(false);
    }
  }
}
