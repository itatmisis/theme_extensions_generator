/// Marks a field of a theme class as participating in code generation.
///
/// The annotation affects how the `lerp`/`tween` logic will be generated:
/// - [ThemeProperty] – built-in types with `lerp`/`tween` are detected automatically.
/// - [ThemeProperty.styled] – declares that the type has its own static
///   `lerp(a, b, t)` function (e.g. nested theme type).
/// - [ThemeProperty.lerp] – explicitly specifies target type used for lerp.
/// - [ThemeProperty.tween] – explicitly specifies target type used for tween.
class ThemeProperty {
  /// Explicit target type for lerp/tween-based generation (optional).
  final String? targetType;

  /// Enables deep copy functionality for styled fields (disabled by default).
  /// When true, decoration classes will use decoration types instead of full theme types,
  /// and copyWithDecoration will perform recursive deep merge.
  final bool enableDeepCopy;

  /// Default behavior, lets the generator infer lerp/tween from known types.
  const ThemeProperty()
      : targetType = null,
        enableDeepCopy = false;

  /// Declares that the field type has static `lerp(a, b, t)` implementation.
  const ThemeProperty.styled({this.enableDeepCopy = false}) : targetType = null;

  /// Forces generator to use `lerp` behavior with [targetType].
  const ThemeProperty.lerp(this.targetType) : enableDeepCopy = false;

  /// Forces generator to use `tween` behavior with [targetType].
  const ThemeProperty.tween(this.targetType) : enableDeepCopy = false;
}
