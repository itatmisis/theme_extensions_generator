import 'dart:async';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_annotation/theme_extension_annotation.dart';
import 'package:theme_extensions_generator/src/theme_extension_generator.dart';

Future<void> main() async {
  final simpleTheme = await initializeLibraryReaderForDirectory(
    'test/src',
    'simple_theme.dart',
  );

  final nestedTheme = await initializeLibraryReaderForDirectory(
    'test/src',
    'nested_theme.dart',
  );

  final invalidTheme = await initializeLibraryReaderForDirectory(
    'test/src',
    'invalid_theme.dart',
  );

  final exampleCustomTheme = await initializeLibraryReaderForDirectory(
    'test/src',
    'example_custom_theme.dart',
  );

  initializeBuildLogTracking();

  testAnnotatedElements<ThemeExtended>(
    simpleTheme,
    ThemeExtensionGenerator(),
  );

  testAnnotatedElements<ThemeExtended>(
    nestedTheme,
    ThemeExtensionGenerator(),
  );

  testAnnotatedElements<ThemeExtended>(
    invalidTheme,
    ThemeExtensionGenerator(),
  );

  testAnnotatedElements<ThemeExtended>(
    exampleCustomTheme,
    ThemeExtensionGenerator(),
  );
}