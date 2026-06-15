import 'package:expense_tracker/core/utils/google_fonts_helper.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light(
    FlexScheme scheme,
    FontOption font,
  ) {
    return FlexThemeData.light(
      scheme: scheme,
      textTheme: AppFonts.getTextTheme(font),
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        tintedDisabledControls: true,
        useM2StyleDividerInM3: true,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        alignedDropdown: true,
        navigationRailUseIndicator: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      cupertinoOverrideTheme: const CupertinoThemeData(
        applyThemeToAll: true,
      ),
    );
  }

  static ThemeData dark(
    FlexScheme scheme,
    FontOption font,
  ) {
    return FlexThemeData.dark(
      scheme: scheme,
      textTheme: AppFonts.getTextTheme(font),
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        tintedDisabledControls: true,
        blendOnColors: true,
        useM2StyleDividerInM3: true,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        alignedDropdown: true,
        navigationRailUseIndicator: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      cupertinoOverrideTheme: const CupertinoThemeData(
        applyThemeToAll: true,
      ),
    );
  }
}
