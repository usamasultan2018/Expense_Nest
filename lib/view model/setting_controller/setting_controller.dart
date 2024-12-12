import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeOption { system, dark, light }

class SettingController extends ChangeNotifier {
  ThemeModeOption _themeMode = ThemeModeOption.system;
  Locale _locale = Locale('en');

  SettingController() {
    _loadSettings();
  }

  ThemeModeOption get themeMode => _themeMode;
  Locale get locale => _locale;

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString('themeMode') ?? 'system';
    String languageCode = prefs.getString('languageCode') ?? 'en';

    setThemeMode(ThemeModeOption.values.firstWhere(
        (e) => e.toString() == 'ThemeModeOption.$theme',
        orElse: () => ThemeModeOption.system));
    setLanguage(languageCode);
  }

  void setThemeMode(ThemeModeOption mode) async {
    _themeMode = mode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode',
        mode.toString().split('.').last); // Save selected theme mode
    notifyListeners();
  }

  ThemeMode get currentThemeMode {
    switch (_themeMode) {
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.system:
      default:
        return ThemeMode.system;
    }
  }

  void setLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'languageCode', languageCode); // Save selected language code
    notifyListeners();
  }
}
