import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeOption {
  light,
  dark,
  system,
}

class SettingController extends ChangeNotifier {
  /// Private Theme State
  ThemeMode _currentThemeMode = ThemeMode.system;

  /// Getter
  ThemeMode get currentThemeMode => _currentThemeMode;

  /// Current Theme Option
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

  /// Initialize Theme
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString('theme_mode') ?? 'system';

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

    notifyListeners();
  }

  /// Set Theme
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

  /// Toggle Theme
  Future<void> toggleTheme() async {
    if (_currentThemeMode == ThemeMode.dark) {
      await setThemeMode(
        ThemeModeOption.light,
      );
    } else {
      await setThemeMode(
        ThemeModeOption.dark,
      );
    }
  }
}
