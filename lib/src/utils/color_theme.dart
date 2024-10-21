import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

final FlexSchemeColor _schemeLight = FlexSchemeColor.from(
  primary: const Color(0xFF00296B),
  secondary: const Color(0xFFFF7B00),
  brightness: Brightness.light,
);

final FlexSchemeColor _schemeDark = FlexSchemeColor.from(
  primary: const Color(0xFF6B8BC3),
  secondary: const Color(0xFFFF7155),
  brightness: Brightness.dark,
);

final ThemeData lightTheme = FlexThemeData.light(
  colors: _schemeLight,
  useMaterial3: true,
  appBarStyle: FlexAppBarStyle.primary,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
);

final ThemeData darkTheme = FlexThemeData.dark(
  colors: _schemeDark,
  useMaterial3: true,
  appBarStyle: FlexAppBarStyle.background,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
);

class AppColorTheme {
  static final light = lightTheme;
  static final dark = darkTheme;
}
