/// Defines how the generator should extend your theme class.
///
/// - [full] – generate mixin, implementation, decoration, ThemeData extension
///   and ThemeExtension wrapper.
/// - [themeOnly] – generate only mixin/implementation and decoration.
enum ThemeExtendedType { full, themeOnly }

/// Annotation placed on a theme class to enable code generation.
///
/// See README for usage and examples.
class ThemeExtended {
  /// Controls what will be generated for the annotated class.
  final ThemeExtendedType type;

  /// Optional custom name of the getter inside `ThemeData` extension.
  final String? extensionGetterName;

  /// Generates a full set of artifacts for the theme.
  const ThemeExtended({this.extensionGetterName})
      : type = ThemeExtendedType.full;

  /// Generates only mixin/implementation and decoration class (no ThemeData/ThemeExtension).
  const ThemeExtended.themeOnly()
      : type = ThemeExtendedType.themeOnly,
        extensionGetterName = null;
}
