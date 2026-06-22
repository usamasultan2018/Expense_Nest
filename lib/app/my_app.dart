import 'package:expense_tracker/core/repository/transaction_repository.dart';
import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:expense_tracker/app/routes/app_router.dart';
import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
import 'package:expense_tracker/features/dashboard/view/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/controller/currency_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/categories/controller/category_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/controller/app_info_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/settings/controller/setting_controller.dart';
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
          create: (_) => TransactionController(
              transactionRepository: _transactionRepository),
        ),
        ChangeNotifierProvider(create: (_) => SettingController()..init()),
        ChangeNotifierProvider(create: (_) => CategoryController()),
        ChangeNotifierProvider(
          create: (_) => AppInfoController()..loadVersion(),
        ),
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
