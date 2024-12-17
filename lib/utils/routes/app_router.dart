import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/view/auth/login/login_screen.dart';
import 'package:expense_tracker/view/auth/signup/signup_screen.dart';
import 'package:expense_tracker/view/dashboard/bottom_nav/bottom_navigator.dart';
import 'package:expense_tracker/view/dashboard/home/all_transaction/all_transaction.dart';
import 'package:expense_tracker/view/dashboard/home/home_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/appearance/appearance_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/my_account/my_account_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/profile_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/feedback_screen.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/setting_screens.dart';
import 'package:expense_tracker/view/dashboard/profile/settings/delete_account_screen.dart';
import 'package:expense_tracker/view/dashboard/stats/stats_screen.dart';
import 'package:expense_tracker/view/dashboard/transactions/add_transaction.dart';
import 'package:expense_tracker/view/dashboard/transactions/edit_transactions.dart';
import 'package:expense_tracker/view/introduction/introduction_screen.dart';
import 'package:expense_tracker/view/splash/splash.dart';
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
        builder: (context, state) => const SplashScreen(),
      ),

      // Introduction Screen
      GoRoute(
        path: RouteName.introduction,
        builder: (context, state) => const IntroductionScreen(),
      ),

      // Home
      GoRoute(
        path: RouteName.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // Auth
      GoRoute(
        path: RouteName.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteName.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      // bottom
      GoRoute(
        path: RouteName.bottomNavBar,
        builder: (context, state) => const BottomNavigatorWidget(),
      ),

      // view all
      GoRoute(
        path: RouteName.viewAllScreen,
        builder: (context, state) => const AllTransaction(),
      ),
      // Profil
      GoRoute(
        path: RouteName.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteName.myAccount,
        builder: (context, state) => const MyAccountScreen(),
      ),
      GoRoute(
        path: RouteName.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteName.appearance,
        builder: (context, state) => const AppearanceScreen(),
      ),
      GoRoute(
        path: RouteName.deleteAccount,
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        path: RouteName.contact,
        builder: (context, state) => const FeedBackScreen(),
      ),

      // Stats
      GoRoute(
        path: RouteName.stats,
        builder: (context, state) => const StatScreen(),
      ),

      // Transactions
      GoRoute(
        path: RouteName.addTransaction,
        builder: (context, state) => const AddTransaction(),
      ),
      GoRoute(
        path: RouteName.editTransaction,
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
