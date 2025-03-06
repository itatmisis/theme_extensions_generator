enum ThemeExtendedType {
  full, themeOnly
}

class ThemeExtended {
  final ThemeExtendedType type;
  final String? extensionGetterName;

  const ThemeExtended({this.extensionGetterName}) : type = ThemeExtendedType.full;
  const ThemeExtended.themeOnly(): type = ThemeExtendedType.themeOnly, extensionGetterName = null;
}