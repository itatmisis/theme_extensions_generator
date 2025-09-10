import 'package:flutter/material.dart';
import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_annotation/theme_extension_annotation.dart';

part 'nested_theme.g.dart';

@ShouldGenerate(r'mixin _$NestedButtonTheme', contains: true)
@ShouldGenerate(r'class _NestedButtonTheme implements NestedButtonTheme',
    contains: true)
@ThemeExtended.themeOnly()
class NestedButtonTheme with _$NestedButtonTheme {
  const factory NestedButtonTheme({
    @ThemeProperty() required Color borderColor,
  }) = _NestedButtonTheme;
}

@ShouldGenerate(r'extension ComplexThemeThemeData on ThemeData', contains: true)
@ShouldGenerate(
    r'class ComplexThemeExtension extends ThemeExtension<ComplexThemeExtension>',
    contains: true)
@ThemeExtended()
class ComplexTheme with _$ComplexTheme {
  const factory ComplexTheme({
    @ThemeProperty.styled() required NestedButtonTheme buttonTheme,
  }) = _ComplexTheme;
}
