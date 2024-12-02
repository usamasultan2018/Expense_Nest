import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/repository/category_repository.dart';
import 'package:expense_tracker/repository/transaction_repository.dart';
import 'package:expense_tracker/utils/app_theme.dart';
import 'package:expense_tracker/utils/helpers/shared_preference.dart';
import 'package:expense_tracker/view%20model/transaction_controller/transaction_controller.dart';
import 'package:expense_tracker/view%20model/login_controller/login_controller.dart';
import 'package:expense_tracker/view%20model/signup_controller/signup_controller.dart';
import 'package:expense_tracker/view%20model/user_controller/user_controller.dart';
import 'package:expense_tracker/view%20model/setting_controller/setting_controller.dart'; // Import the SettingController
import 'package:expense_tracker/view/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:expense_tracker/view%20model/category_controller/category_controller.dart'; // Import the CategoryController

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize SharedPreferences
  await HTrackerSharedPreferences.getInit(); // Initializes SharedPreferences
  // await addAllCategoriesToFirestore(categories);
  runApp(const MyApp());
}

final _transactionRepository = TransactionRepository();
final _categoryRepository =
    CategoryRepository(); // Instantiate the CategoryRepository

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupController()),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(
          create: (_) => TransactionController(
              transactionRepository: _transactionRepository,
              categoryController: CategoryController(
                  categoryRepository: _categoryRepository,
                  transactionRepository: _transactionRepository)),
        ),
        ChangeNotifierProvider(
            create: (_) => SettingController()), // SettingController
        ChangeNotifierProvider(
            create: (_) => CategoryController(
                categoryRepository: _categoryRepository,
                transactionRepository: _transactionRepository)),
      ],
      child: Consumer<SettingController>(
        builder: (context, settingController, child) {
          return MaterialApp(
            title: 'Expense Tracker',
            debugShowCheckedModeBanner: false,
            locale: settingController.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              Locale("en"),
              Locale("es"),
              Locale("ur"),
            ],
            themeMode: settingController.currentThemeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}

// Function to add all categories to Firestore
Future<void> addAllCategoriesToFirestore(List<CategoryModel> categories) async {
  CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  // Loop through the categories and add them to Firestore
  for (var category in categories) {
    try {
      await categoriesCollection.add(category.toMap());
      print("Added category: ${category.name}");
    } catch (e) {
      print("Failed to add category ${category.name}: $e");
    }
  }
}
