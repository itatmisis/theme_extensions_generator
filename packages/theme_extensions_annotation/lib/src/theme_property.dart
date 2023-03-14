class ThemeProperty {
  final String? targetType;

  const ThemeProperty(): targetType = null;
  const ThemeProperty.styled(): targetType = null;
  const ThemeProperty.lerp(this.targetType);
  const ThemeProperty.tween(this.targetType);
}