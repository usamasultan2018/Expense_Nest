import 'package:expense_tracker/app/app_config.dart';
import 'package:expense_tracker/features/subscription/services/revenuecat_service.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
    await dotenv.load(fileName: ".env");

  await RevenueCatService().initialize(AppConfig.revenueCatKey);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
