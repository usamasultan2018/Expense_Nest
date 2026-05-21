import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/features/auth/view/forgot_password/forgot_password.dart';
import 'package:expense_tracker/features/auth/view/login/login_screen.dart';
import 'package:expense_tracker/features/auth/view/signup/signup_screen.dart';
import 'package:expense_tracker/features/auth/view/auth_wrapper.dart';
import 'package:expense_tracker/features/dashboard/view/bottom_nav/bottom_navigator.dart';
import 'package:expense_tracker/features/dashboard/view/home/home_screen.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/appearance_screen.dart';
import 'package:expense_tracker/features/dashboard/view/profile/my_account/my_account_screen.dart';
import 'package:expense_tracker/features/dashboard/view/profile/profile_screen.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/feedback_screen.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/setting_screens.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/delete_account_screen.dart';
import 'package:expense_tracker/features/dashboard/view/stats/stats_screen.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/add_transaction.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/edit_transactions.dart';
import 'package:expense_tracker/features/introduction/view/introduction_screen.dart';
import 'package:expense_tracker/features/splash/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_name.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteName.splash,
    routes: [
      // Splash Screen
      GoRoute(
        path: RouteName.splash,
        name: RouteName.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Wrapper
      GoRoute(
        path: RouteName.authWrapper,
        name: RouteName.authWrapper,
        builder: (context, state) => const AuthWrapper(),
      ),

      // Introduction Screen
      GoRoute(
        path: RouteName.introduction,
        name: RouteName.introduction,
        builder: (context, state) => const IntroductionScreen(),
      ),

      // Home
      GoRoute(
        path: RouteName.home,
        name: RouteName.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // Auth
      GoRoute(
        path: RouteName.login,
        name: RouteName.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteName.signup,
        name: RouteName.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      // Bottom Navigator
      GoRoute(
        path: RouteName.bottomNavBar,
        name: RouteName.bottomNavBar,
        builder: (context, state) => const BottomNavigatorWidget(),
      ),
      // forgot password
      GoRoute(
        path: RouteName.forgotPassword,
        name: RouteName.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      // Profile
      GoRoute(
        path: RouteName.profile,
        name: RouteName.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteName.myAccount,
        name: RouteName.myAccount,
        builder: (context, state) => const MyAccountScreen(),
      ),
      GoRoute(
        path: RouteName.settings,
        name: RouteName.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteName.appearance,
        name: RouteName.appearance,
        builder: (context, state) => const AppearanceScreen(),
      ),
      GoRoute(
        path: RouteName.deleteAccount,
        name: RouteName.deleteAccount,
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        path: RouteName.contact,
        name: RouteName.contact,
        builder: (context, state) => const FeedBackScreen(),
      ),

      // Stats
      GoRoute(
        path: RouteName.stats,
        name: RouteName.stats,
        builder: (context, state) => const StatScreen(),
      ),

      // Transactions
      GoRoute(
        path: RouteName.addTransaction,
        name: RouteName.addTransaction,
        builder: (context, state) => const AddTransaction(),
      ),
      GoRoute(
        path: RouteName.editTransaction,
        name: RouteName.editTransaction,
        builder: (context, state) {
          final transaction = state.extra as TransactionModel;
          return EditTransaction(transaction: transaction);
        },
      ),
    ],

    // Error Route
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    ),
  );
}
