## 3.0.0

- Compatibility: Require Dart 3.9+ for the current `source_gen` 4.2.2 line.
- Compatibility: Update dependencies to the current `build` 4 / `source_gen` 4.2.2 stack.

## 2.0.0

- Compatibility: Require Dart 3.8+ for the intermediate `source_gen` 4 line.
- Compatibility: Update dependencies to the `source_gen` 4.0-4.2.0 stack.

## 1.2.4

- Compatibility: Clarify the legacy `source_gen` 3.x line as Dart 3.7+.
- Compatibility: Relax dependency constraints within the `build` 3 / `source_gen` 3 stack.

## 1.2.3

- **Fix**: Removed unused `generateSource` stub and the redundant `package:analyzer/dart/element/element.dart` import so analyzer no longer reports deprecated `Element` (old element model) when analyzing this package.

## 1.2.2

- **Fix**: `@ThemeProperty.styled()` now emits a public lerp entry (`extension {Theme}Lerp on {Theme}` with `static lerp`) so nested themes work across libraries; `ThemeExtension.lerp` uses the same public namespace. Remove any hand-written `{Theme}Lerp` duplicates if you added them as a workaround.

## 1.2.1

- **Compatibility**: Relaxed dependency constraints (analyzer) to support wider versions

## 1.2.0

- **Feature**: Deep-copy. See [deep copy documentation](https://github.com/itatmisis/theme_extensions_generator/blob/master/theme_extensions_generator/doc/deep_copy_functionality.md).

## 1.1.4

- **Compatibility**: Relaxed dependency constraints (build/source_gen) to support wider versions

## 1.1.3

- **Docs**: Added Dartdoc comments to public APIs
- **Fix**: Validation of non-lerpable types now throws InvalidGenerationSource error
- **Tests**: Expanded test coverage, including comprehensive examples
- **Chore**: Minor refactoring and code cleanup

## 1.1.1

- **Feature**: Added ability to manually set generated extension getter name (`extensionGetterName` parameter)
- **Credits**: Contribution by drooxie

## 1.0.0

- Initial version.
