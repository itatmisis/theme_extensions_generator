import 'package:flutter/material.dart';
import 'package:theme_extensions_annotation/theme_extension_annotation.dart';

part 'custom_theme.g.dart';

@ThemeExtended.themeOnly()
class ActionButtonTheme with _$ActionButtonTheme {
  const factory ActionButtonTheme({
    @ThemeProperty()
    required Color backgroundColor,
    @ThemeProperty()
    required Color foregroundColor,
    required IconData icon
  })= _ActionButtonTheme;
}

@ThemeExtended()
class CustomTheme with _$CustomTheme {
  const factory CustomTheme({
    @ThemeProperty()
    required Color backgroundColor,
    @ThemeProperty()
    required Color foregroundColor,
    @ThemeProperty()
    required Color textColor,
    @ThemeProperty()
    Alignment? textAlign,
    @ThemeProperty.styled()
    required ActionButtonTheme actionButtonTheme,
    required String themeName
  })= _CustomTheme;
}