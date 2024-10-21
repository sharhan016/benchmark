import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

// Light color scheme definition
final FlexSchemeColor _schemeLight = FlexSchemeColor.from(
  primary: const Color(0xFF00296B),
  secondary: const Color(0xFFFF7B00),
  brightness: Brightness.light,
);

// Dark color scheme definition
final FlexSchemeColor _schemeDark = FlexSchemeColor.from(
  primary: const Color(0xFF6B8BC3),
  secondary: const Color(0xFFFF7155),
  brightness: Brightness.dark,
);

// Light ThemeData using FlexThemeData and the custom light scheme
final ThemeData lightTheme = FlexThemeData.light(
  colors: _schemeLight,
  useMaterial3: true,
  appBarStyle: FlexAppBarStyle.primary,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
);

// Dark ThemeData using FlexThemeData and the custom dark scheme
final ThemeData darkTheme = FlexThemeData.dark(
  colors: _schemeDark,
  useMaterial3: true,
  appBarStyle: FlexAppBarStyle.background,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
);

// Export both light and dark themes
class AppColorTheme {
  static final light = lightTheme;
  static final dark = darkTheme;
}
