import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/utils/constant.dart';
import 'package:expense_tracker/features/auth/view/forgot_password/forgot_password.dart';
import 'package:expense_tracker/features/auth/view/login/login_screen.dart';
import 'package:expense_tracker/features/auth/view/signup/signup_screen.dart';
import 'package:expense_tracker/features/auth/view/auth_wrapper.dart';
import 'package:expense_tracker/features/dashboard/view/bottom_nav/bottom_navigator.dart';
import 'package:expense_tracker/features/dashboard/view/budget/budget_screen.dart';
import 'package:expense_tracker/features/dashboard/view/budget/screens/add_budget/add_budget_screen.dart';
import 'package:expense_tracker/features/dashboard/view/home/home_screen.dart';
import 'package:expense_tracker/features/dashboard/view/home/view/all_transaction_screen.dart';
import 'package:expense_tracker/features/dashboard/view/home/view/monthly_recape_screen.dart';
import 'package:expense_tracker/features/dashboard/view/home/view/recurring_transaction_screen.dart';
import 'package:expense_tracker/features/dashboard/view/notications/view/notication_screen.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/appearance_screen.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/categories_screen.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/view/add_category/add_category_screen.dart';
import 'package:expense_tracker/features/dashboard/view/profile/my_account/my_account_screen.dart';
import 'package:expense_tracker/features/dashboard/view/profile/profile_screen.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/feedback_screen.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/setting_screens.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/delete_account_screen.dart';
import 'package:expense_tracker/features/dashboard/view/stats/calender_screen.dart';
import 'package:expense_tracker/features/dashboard/view/stats/stats_screen.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/add_transaction.dart';
import 'package:expense_tracker/features/dashboard/view/transactions/edit_transactions.dart';
import 'package:expense_tracker/features/introduction/view/introduction_screen.dart';
import 'package:expense_tracker/features/splash/view/splash.dart';
import 'package:expense_tracker/features/subscription/screens/subscription_screen.dart';
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
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final type = extra?['type'] as TransactionType?;
          return AddTransaction(initialType: type);
        },
      ),
      GoRoute(
        path: RouteName.editTransaction,
        name: RouteName.editTransaction,
        builder: (context, state) {
          final transaction = state.extra as TransactionModel;
          return EditTransaction(transaction: transaction);
        },
      ),
      GoRoute(
        path: RouteName.notifications,
        name: RouteName.notifications,
        builder: (context, state) => const NotificationScreen(),
      ),
      // Categories
      GoRoute(
        path: RouteName.categories,
        name: RouteName.categories,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: RouteName.addCategory,
        name: RouteName.addCategory,
        builder: (context, state) => const AddCategoryScreen(),
      ),
      GoRoute(
        path: RouteName.transactions,
        name: RouteName.transactions,
        builder: (context, state) => const AllTransactionScreen(),
      ),
      GoRoute(
        path: RouteName.recurringTransactions,
        name: RouteName.recurringTransactions,
        builder: (context, state) => const RecurringTransactionsScreen(),
      ),
      GoRoute(
        path: RouteName.monthlyRecap,
        name: RouteName.monthlyRecap,
        builder: (context, state) => const MonthlyRecapScreen(),
      ),
      GoRoute(
        path: RouteName.calender,
        name: RouteName.calender,
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: RouteName.budget,
        name: RouteName.budget,
        builder: (context, state) => const BudgetScreen(),
      ),
      GoRoute(
        path: RouteName.subscription,
        name: RouteName.subscription,
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: RouteName.addBudget,
        name: RouteName.addBudget,
        builder: (context, state) => const AddBudgetScreen(),
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
