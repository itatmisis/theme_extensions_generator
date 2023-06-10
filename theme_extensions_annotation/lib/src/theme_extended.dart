enum ThemeExtendedType {
  full, themeOnly
}

class ThemeExtended {
  final ThemeExtendedType type;

  const ThemeExtended(): type = ThemeExtendedType.full;
  const ThemeExtended.themeOnly(): type = ThemeExtendedType.themeOnly;
}