// import 'package:expense_tracker/core/repository/transaction_repository.dart';
// import 'package:expense_tracker/features/dashboard/controller/transaction_controller.dart';
// import 'package:expense_tracker/features/dashboard/view/bottom_nav/controller/bottom_nav_controller.dart';
// import 'package:expense_tracker/features/dashboard/view/profile/appearance/controller/currency_controller.dart';
// import 'package:expense_tracker/features/dashboard/view/profile/categories/controller/category_controller.dart';
// import 'package:expense_tracker/features/dashboard/view/profile/controller/user_controller.dart';
// import 'package:expense_tracker/features/dashboard/view/profile/settings/controller/app_info_controller.dart';
// import 'package:expense_tracker/features/dashboard/view/profile/settings/controller/setting_controller.dart';
// import 'package:expense_tracker/features/subscription/controller/subscription_controller.dart';
// import 'package:expense_tracker/features/subscription/services/revenuecat_service.dart';
// import 'package:provider/provider.dart';

// final _transactionRepository = TransactionRepository();

// List<ChangeNotifierProvider> get appProviders => [
//       ChangeNotifierProvider(create: (_) => BottomNavController()),
//       ChangeNotifierProvider(create: (_) => CurrencyController()),
//       ChangeNotifierProvider(create: (_) => UserController()..fetchUser()),
//       ChangeNotifierProvider(
//         create: (_) => TransactionController(
//           transactionRepository: _transactionRepository,
//         ),
//       ),
//       ChangeNotifierProvider(create: (_) => SettingController()..init()),
//       ChangeNotifierProvider(create: (_) => CategoryController()),
//       ChangeNotifierProvider(create: (_) => AppInfoController()..loadVersion()),

//     ];
