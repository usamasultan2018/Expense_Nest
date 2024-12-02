import 'package:expense_tracker/repository/auth_repository.dart';
import 'package:expense_tracker/utils/helpers/firebase_exception_handler.dart';
import 'package:expense_tracker/utils/helpers/snackbar_util.dart';
import 'package:expense_tracker/view/dashboard/bottom_nav/bottom_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

      if (!user!.emailVerified) {
        SnackbarUtil.showErrorSnackbar(
            context, AppLocalizations.of(context)!.verifyEmail);
      }

      if (user != null && user.emailVerified) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) {
            return const BottomNavigatorWidget();
          }),
          (route) => false,
        );
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

      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) {
            return const BottomNavigatorWidget();
          }),
          (route) => false,
        );
        SnackbarUtil.showSuccessSnackbar(
            context, AppLocalizations.of(context)!.googleLoginSuccessful);
      } else {
        SnackbarUtil.showErrorSnackbar(
            context, AppLocalizations.of(context)!.loginCanceled);
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
