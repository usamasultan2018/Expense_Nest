import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get revenueCatKey =>
      dotenv.env['REVENUECAT_ANDROID_API_KEY'] ?? '';
}
