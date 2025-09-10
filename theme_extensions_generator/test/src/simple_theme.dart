import 'package:flutter/material.dart';
import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_annotation/theme_extension_annotation.dart';

part 'simple_theme.g.dart';

@ShouldGenerate(r'''
mixin _$SimpleTheme {
''', contains: true)
@ShouldGenerate(r'''
class _SimpleTheme implements SimpleTheme {
''', contains: true)
@ShouldGenerate(r'''
extension SimpleThemeThemeData on ThemeData {
''', contains: true)
@ShouldGenerate(r'''
class SimpleThemeExtension extends ThemeExtension<SimpleThemeExtension> {
''', contains: true)
@ThemeExtended()
class SimpleTheme with _$SimpleTheme {
  const factory SimpleTheme({
    @ThemeProperty()
    required Color backgroundColor,
    @ThemeProperty()
    required Color foregroundColor,
  }) = _SimpleTheme;
}