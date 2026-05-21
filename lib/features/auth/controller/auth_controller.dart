import 'package:expense_tracker/core/repository/auth_repository.dart';
import 'package:expense_tracker/core/utils/helpers/snackbar_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/app/routes/route_name.dart';

/// Controller for authentication-related UI logic
class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;

  // Form controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // UI state
  bool _isPasswordVisible = false;
  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;

  AuthController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  // Getters
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isEmailLoading => _isEmailLoading;
  bool get isGoogleLoading => _isGoogleLoading;
  bool get isLoading => _isEmailLoading || _isGoogleLoading;

  // Backwards-compatible aliases
  bool get isLoadingEmail => _isEmailLoading;
  bool get isLoadingGoogle => _isGoogleLoading;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  /// Clear all form fields
  void clearFields() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  /// Sign in with email and password
  Future<void> login({required BuildContext context}) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    // Validation
    if (email.isEmpty || password.isEmpty) {
      SnackbarUtil.showErrorSnackbar(
        context,
        'Email and password are required',
      );
      return;
    }

    if (!_isValidEmail(email)) {
      SnackbarUtil.showErrorSnackbar(context, 'Please enter a valid email');
      return;
    }

    _setEmailLoading(true);

    try {
      final User? user = await _authRepository.signIn(
        email: email,
        password: password,
      );

      if (user != null && context.mounted) {
        clearFields();
        context.goNamed(RouteName.bottomNavBar);
        SnackbarUtil.showSuccessSnackbar(context, 'Welcome back!');
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(
          context,
          _getAuthErrorMessage(e.code),
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(
          context,
          'An unexpected error occurred. Please try again.',
        );
      }
      debugPrint('❌ Login error: $e');
    } finally {
      _setEmailLoading(false);
    }
  }

  /// Register new user with email and password
  Future<void> register(BuildContext context) async {
    final String username = usernameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    // Validation
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      SnackbarUtil.showErrorSnackbar(
        context,
        'All fields are required',
      );
      return;
    }

    if (!_isValidEmail(email)) {
      SnackbarUtil.showErrorSnackbar(context, 'Please enter a valid email');
      return;
    }

    if (password.length < 6) {
      SnackbarUtil.showErrorSnackbar(
        context,
        'Password must be at least 6 characters',
      );
      return;
    }

    _setEmailLoading(true);

    try {
      final User? user = await _authRepository.signUp(
        email: email,
        password: password,
        username: username,
      );

      if (user != null && context.mounted) {
        clearFields();
        SnackbarUtil.showSuccessSnackbar(
          context,
          'Account created! Please verify your email.',
        );
        context.goNamed(RouteName.bottomNavBar);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(
          context,
          _getAuthErrorMessage(e.code),
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(
          context,
          'Registration failed. Please try again.',
        );
      }
      debugPrint('❌ Registration error: $e');
    } finally {
      _setEmailLoading(false);
    }
  }

  /// Sign in or sign up with Google
  Future<void> googleLogin({required BuildContext context}) async {
    _setGoogleLoading(true);

    try {
      final User? user = await _authRepository.signUpWithGoogle();

      if (user != null && context.mounted) {
        clearFields();
        context.goNamed(RouteName.bottomNavBar);
        SnackbarUtil.showSuccessSnackbar(context, 'Welcome!');
      } else if (context.mounted) {
        // User cancelled the sign-in
        SnackbarUtil.showErrorSnackbar(
          context,
          'Google sign-in was cancelled',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(
          context,
          _getAuthErrorMessage(e.code),
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(
          context,
          'Google sign-in failed. Please try again.',
        );
      }
      debugPrint('❌ Google login error: $e');
    } finally {
      _setGoogleLoading(false);
    }
  }

  /// Alias for semantic compatibility
  Future<void> registerWithGoogle(BuildContext context) async {
    await googleLogin(context: context);
  }

  /// Send password reset email
  Future<void> forgotPassword({required BuildContext context}) async {
    final String email = emailController.text.trim();

    // Validation
    if (email.isEmpty) {
      SnackbarUtil.showErrorSnackbar(context, 'Email is required');
      return;
    }

    if (!_isValidEmail(email)) {
      SnackbarUtil.showErrorSnackbar(context, 'Please enter a valid email');
      return;
    }

    _setEmailLoading(true);

    try {
      await _authRepository.sendPasswordResetEmail(email);

      if (context.mounted) {
        clearFields();
        SnackbarUtil.showSuccessSnackbar(
          context,
          'Password reset email sent. Please check your inbox.',
        );

        // Navigate back or to login
        if (context.canPop()) {
          context.pop();
        } else {
          context.goNamed(RouteName.login);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(
          context,
          _getAuthErrorMessage(e.code),
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtil.showErrorSnackbar(
          context,
          'Failed to send reset email. Please try again.',
        );
      }
      debugPrint('❌ Password reset error: $e');
    } finally {
      _setEmailLoading(false);
    }
  }

  // Private helper methods

  void _setEmailLoading(bool value) {
    _isEmailLoading = value;
    notifyListeners();
  }

  void _setGoogleLoading(bool value) {
    _isGoogleLoading = value;
    notifyListeners();
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Get user-friendly error messages for Firebase Auth errors
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      case 'invalid-credential':
        return 'Invalid credentials. Please try again';
      default:
        return 'Authentication failed. Please try again';
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
