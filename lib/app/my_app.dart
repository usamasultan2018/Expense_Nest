import 'package:expense_tracker/core/repository/transaction_repository.dart';
import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:expense_tracker/app/routes/app_router.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:expense_tracker/features/dashboard/view/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:expense_tracker/features/dashboard/view/budget/controller/budget_controller.dart';
import 'package:expense_tracker/features/dashboard/view/notifications/controller/notification_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/controller/currency_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/controller/category_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/controller/app_info_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/controller/setting_controller.dart';
import 'package:expense_tracker/features/subscription/controller/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _transactionRepository = TransactionRepository();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavController()),
        ChangeNotifierProvider(create: (_) => CurrencyController()),
        ChangeNotifierProvider(create: (_) => UserController()..fetchUser()),
        ChangeNotifierProvider(
          create: (_) => BudgetController()..loadBudgets(),
        ),
        ChangeNotifierProxyProvider2<BudgetController, UserController,
            TransactionController>(
          create: (context) => TransactionController(
            transactionRepository: _transactionRepository,
            budgetController: context.read<BudgetController>(),
          ),
          update: (context, budgetController, userController, previous) {
            final controller = previous!
              ..updateBudgetController(budgetController);

            // Pass user info for personalised daily reminder
            final user = userController.currentUser;
            if (user != null) {
              controller.setUserInfo(
                name: user.username,
                createdAt: user.createdAt,
              );
            }
            return controller;
          },
        ),
        ChangeNotifierProvider(create: (_) => SettingController()..init()),
        ChangeNotifierProvider(create: (_) => CategoryController()),
        ChangeNotifierProvider(
          create: (_) => AppInfoController()..loadVersion(),
        ),
        ChangeNotifierProxyProvider<UserController, SubscriptionController>(
          create: (context) => SubscriptionController(
            userController: context.read<UserController>(),
          ),
          update: (context, userController, previous) =>
              previous ??
              SubscriptionController(
                userController: userController,
              ),
        ),
        // Notification list — streams from Firestore in real-time
        ChangeNotifierProvider(create: (_) => NotificationController()),
      ],
      child: Consumer<SettingController>(
        builder: (context, settingController, child) {
          return MaterialApp.router(
            title: 'ExpenseNest',
            debugShowCheckedModeBanner: false,
            themeMode: settingController.currentThemeMode,
            theme: AppTheme.light(
              settingController.currentScheme,
              settingController.currentFont,
            ),
            darkTheme: AppTheme.dark(
              settingController.currentScheme,
              settingController.currentFont,
            ),
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
