import 'package:flutter/material.dart';
import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_annotation/theme_extension_annotation.dart';

part 'deep_copy_theme.g.dart';

// Simple nested theme for testing
@ShouldGenerate(r'mixin _$ButtonStyleTheme', contains: true)
@ShouldGenerate(r'class _ButtonStyleTheme implements ButtonStyleTheme',
    contains: true)
@ShouldGenerate(r'class ButtonStyleThemeDecoration', contains: true)
@ShouldGenerate(r'final Color? backgroundColor', contains: true)
@ShouldGenerate(r'final Color? borderColor', contains: true)
@ThemeExtended.themeOnly()
class ButtonStyleTheme with _$ButtonStyleTheme {
  const factory ButtonStyleTheme({
    @ThemeProperty() required Color backgroundColor,
    @ThemeProperty() required Color borderColor,
    @ThemeProperty() required Color textColor,
  }) = _ButtonStyleTheme;
}

// Theme with single nested object
@ShouldGenerate(r'mixin _$SimpleDeepTheme', contains: true)
@ShouldGenerate(r'class _SimpleDeepTheme implements SimpleDeepTheme',
    contains: true)
@ShouldGenerate(r'class SimpleDeepThemeDecoration', contains: true)
@ShouldGenerate('ButtonStyleThemeDecoration? buttonStyle', contains: true)
@ShouldGenerate('String? title', contains: true)
@ShouldGenerate('buttonStyle.copyWithDecoration(decoration.buttonStyle)',
    contains: true)
@ShouldGenerate('title: decoration.title ?? title', contains: true)
@ThemeExtended()
class SimpleDeepTheme with _$SimpleDeepTheme {
  const factory SimpleDeepTheme({
    @ThemeProperty.styled(enableDeepCopy: true)
    required ButtonStyleTheme buttonStyle,
    required String title, // No annotation as String doesn't support lerp
  }) = _SimpleDeepTheme;
}

// More complex theme with multiple nesting levels
@ShouldGenerate(r'mixin _$IconStyleTheme', contains: true)
@ShouldGenerate(r'class _IconStyleTheme implements IconStyleTheme',
    contains: true)
@ThemeExtended.themeOnly()
class IconStyleTheme with _$IconStyleTheme {
  const factory IconStyleTheme({
    @ThemeProperty() required Color iconColor,
    @ThemeProperty() required double iconSize,
  }) = _IconStyleTheme;
}

@ShouldGenerate(r'mixin _$ComplexDeepTheme', contains: true)
@ShouldGenerate(r'class _ComplexDeepTheme implements ComplexDeepTheme',
    contains: true)
@ShouldGenerate(r'class ComplexDeepThemeDecoration', contains: true)
@ShouldGenerate('ButtonStyleThemeDecoration? primaryButton', contains: true)
@ShouldGenerate('ButtonStyleThemeDecoration? secondaryButton', contains: true)
@ShouldGenerate('IconStyleThemeDecoration? iconStyle', contains: true)
@ShouldGenerate('Color? backgroundColor', contains: true)
@ShouldGenerate('primaryButton.copyWithDecoration(decoration.primaryButton)',
    contains: true)
@ShouldGenerate('secondaryButton.copyWithDecoration', contains: true)
@ShouldGenerate('iconStyle.copyWithDecoration(decoration.iconStyle)',
    contains: true)
@ShouldGenerate('decoration.backgroundColor ?? backgroundColor', contains: true)
@ThemeExtended()
class ComplexDeepTheme with _$ComplexDeepTheme {
  const factory ComplexDeepTheme({
    @ThemeProperty.styled(enableDeepCopy: true)
    required ButtonStyleTheme primaryButton,
    @ThemeProperty.styled(enableDeepCopy: true)
    required ButtonStyleTheme secondaryButton,
    @ThemeProperty.styled(enableDeepCopy: true)
    required IconStyleTheme iconStyle,
    @ThemeProperty() required Color backgroundColor,
  }) = _ComplexDeepTheme;
}

// Test for backward compatibility - regular fields should work as before
@ShouldGenerate('mixin _\$BackwardCompatTheme', contains: true)
@ShouldGenerate('class _BackwardCompatTheme implements BackwardCompatTheme',
    contains: true)
@ShouldGenerate('class BackwardCompatThemeDecoration', contains: true)
@ShouldGenerate('Color? primaryColor', contains: true)
@ShouldGenerate('Color? secondaryColor', contains: true)
@ShouldGenerate('String? text', contains: true)
@ShouldGenerate('decoration.primaryColor ?? primaryColor', contains: true)
@ShouldGenerate('decoration.secondaryColor ?? secondaryColor', contains: true)
@ShouldGenerate('decoration.text ?? text', contains: true)
@ThemeExtended()
class BackwardCompatTheme with _$BackwardCompatTheme {
  const factory BackwardCompatTheme({
    @ThemeProperty() required Color primaryColor,
    @ThemeProperty() required Color secondaryColor,
    required String text, // No annotation for String
  }) = _BackwardCompatTheme;
}
