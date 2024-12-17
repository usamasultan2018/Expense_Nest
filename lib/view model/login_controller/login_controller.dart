import 'package:expense_tracker/repository/auth_repository.dart';
import 'package:expense_tracker/utils/helpers/firebase_exception_handler.dart';
import 'package:expense_tracker/utils/helpers/snackbar_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart'; // Add go_router

class LoginController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isEmailLoading = false; // Loading for email/password login
  bool _isGoogleLoading = false; // Loading for Google login

  bool get isEmailLoading => _isEmailLoading;
  bool get isGoogleLoading => _isGoogleLoading;

  void setEmailLoading(bool value) {
    _isEmailLoading = value;
    notifyListeners();
  }

  void setGoogleLoading(bool value) {
    _isGoogleLoading = value;
    notifyListeners();
  }

  Future<void> login({required BuildContext context}) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      SnackbarUtil.showErrorSnackbar(
          context, AppLocalizations.of(context)!.pleaseFillAllFields);
      return;
    }

    setEmailLoading(true); // Set email loading to true

    try {
      User? user = await _authRepository.signIn(
        emailController.text,
        passwordController.text,
      );

      // If user is null, don't proceed further
      if (user == null) {
        SnackbarUtil.showErrorSnackbar(
            context, AppLocalizations.of(context)!.unexpectedError);
        return;
      }

      if (!user.emailVerified) {
        SnackbarUtil.showErrorSnackbar(
            context, AppLocalizations.of(context)!.verifyEmail);
        return;
      }

      // Navigate to the home screen (Ensure this doesn't call itself)
      if (context.mounted) {
        context.go('/bottom-nav');
        SnackbarUtil.showSuccessSnackbar(
            context, AppLocalizations.of(context)!.loginSuccessful);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = FirebaseExceptionHandler.handleException(e);
      SnackbarUtil.showErrorSnackbar(context, errorMessage);
    } catch (e) {
      SnackbarUtil.showErrorSnackbar(
          context, AppLocalizations.of(context)!.unexpectedError);
    } finally {
      setEmailLoading(false); // Ensure that email loading is stopped
    }
  }

  Future<void> googleLogin({required BuildContext context}) async {
    setGoogleLoading(true); // Set Google loading to true

    try {
      User? user = await _authRepository.signUpWithGoogle();

      // If user is null, don't proceed further
      if (user == null) {
        SnackbarUtil.showErrorSnackbar(
            context, AppLocalizations.of(context)!.loginCanceled);
        return;
      }

      // Navigate to the home screen (Ensure this doesn't call itself)
      if (context.mounted) {
        context.go('/home');
        SnackbarUtil.showSuccessSnackbar(
            context, AppLocalizations.of(context)!.googleLoginSuccessful);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = FirebaseExceptionHandler.handleException(e);
      SnackbarUtil.showErrorSnackbar(context, errorMessage);
    } catch (e) {
      SnackbarUtil.showErrorSnackbar(
          context, AppLocalizations.of(context)!.unexpectedError);
    } finally {
      setGoogleLoading(false); // Ensure that Google loading is stopped
    }
  }
}
