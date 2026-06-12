import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeOption {
  light,
  dark,
  system,
}

class SettingController extends ChangeNotifier {
  ThemeMode _currentThemeMode = ThemeMode.system;
  FlexScheme _currentScheme = FlexScheme.blueM3;

  ThemeMode get currentThemeMode => _currentThemeMode;

  FlexScheme get currentScheme => _currentScheme;

  ThemeModeOption get themeModeOption {
    switch (_currentThemeMode) {
      case ThemeMode.light:
        return ThemeModeOption.light;

      case ThemeMode.dark:
        return ThemeModeOption.dark;

      case ThemeMode.system:
        return ThemeModeOption.system;
    }
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    /// Theme Mode
    final savedTheme =
        prefs.getString('theme_mode') ?? ThemeModeOption.system.name;

    switch (savedTheme) {
      case 'light':
        _currentThemeMode = ThemeMode.light;
        break;

      case 'dark':
        _currentThemeMode = ThemeMode.dark;
        break;

      default:
        _currentThemeMode = ThemeMode.system;
    }

    /// Color Scheme
    final savedScheme =
        prefs.getString('theme_scheme') ?? FlexScheme.blueM3.name;

    _currentScheme = FlexScheme.values.firstWhere(
      (e) => e.name == savedScheme,
      orElse: () => FlexScheme.blueM3,
    );

    notifyListeners();
  }

  Future<void> setThemeMode(
    ThemeModeOption option,
  ) async {
    switch (option) {
      case ThemeModeOption.light:
        _currentThemeMode = ThemeMode.light;
        break;

      case ThemeModeOption.dark:
        _currentThemeMode = ThemeMode.dark;
        break;

      case ThemeModeOption.system:
        _currentThemeMode = ThemeMode.system;
        break;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'theme_mode',
      option.name,
    );

    notifyListeners();
  }

  Future<void> setColorScheme(
    FlexScheme scheme,
  ) async {
    _currentScheme = scheme;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'theme_scheme',
      scheme.name,
    );

    notifyListeners();
  }
}
