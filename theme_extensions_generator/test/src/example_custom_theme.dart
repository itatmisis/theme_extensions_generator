import 'package:flutter/material.dart';
import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_annotation/theme_extension_annotation.dart';

part 'example_custom_theme.g.dart';

@ShouldGenerate(r'mixin _$ActionButtonTheme', contains: true)
@ShouldGenerate(r'class _ActionButtonTheme implements ActionButtonTheme',
    contains: true)
@ThemeExtended.themeOnly()
class ActionButtonTheme with _$ActionButtonTheme {
  const factory ActionButtonTheme(
      {@ThemeProperty() required Color backgroundColor,
      @ThemeProperty() required Color foregroundColor,
      required IconData icon}) = _ActionButtonTheme;
}

@ShouldGenerate(r'extension CustomThemeThemeData on ThemeData', contains: true)
@ShouldGenerate(
    r'class CustomThemeExtension extends ThemeExtension<CustomThemeExtension>',
    contains: true)
@ThemeExtended()
class CustomTheme with _$CustomTheme {
  const factory CustomTheme(
      {@ThemeProperty() required Color backgroundColor,
      @ThemeProperty() required Color foregroundColor,
      @ThemeProperty() required Color textColor,
      @ThemeProperty() Alignment? textAlign,
      @ThemeProperty.styled() required ActionButtonTheme actionButtonTheme,
      required String themeName}) = _CustomTheme;
}
