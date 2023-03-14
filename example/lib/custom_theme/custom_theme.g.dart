// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_theme.dart';

// **************************************************************************
// ThemeExtensionGenerator
// **************************************************************************

final _ActionButtonThemePrivateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `ActionButtonTheme._()`. This constructor is only meant to be used by themeExtended and you are not supposed to need it nor use it.');

mixin _$ActionButtonTheme {
  Color get backgroundColor =>
      throw _ActionButtonThemePrivateConstructorUsedError;
  Color get foregroundColor =>
      throw _ActionButtonThemePrivateConstructorUsedError;
  IconData get icon => throw _ActionButtonThemePrivateConstructorUsedError;

  ActionButtonTheme copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    IconData? icon,
  }) =>
      throw _ActionButtonThemePrivateConstructorUsedError;

  ActionButtonTheme copyWithDecoration(
          ActionButtonThemeDecoration? decoration) =>
      throw _ActionButtonThemePrivateConstructorUsedError;
}

class _ActionButtonTheme implements ActionButtonTheme {
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;

  const _ActionButtonTheme({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  _ActionButtonTheme copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    IconData? icon,
  }) =>
      _ActionButtonTheme(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        foregroundColor: foregroundColor ?? this.foregroundColor,
        icon: icon ?? this.icon,
      );

  _ActionButtonTheme copyWithDecoration(
          ActionButtonThemeDecoration? decoration) =>
      decoration != null
          ? _ActionButtonTheme(
              backgroundColor:
                  decoration.backgroundColor ?? this.backgroundColor,
              foregroundColor:
                  decoration.foregroundColor ?? this.foregroundColor,
              icon: decoration.icon ?? this.icon,
            )
          : this;

  static ActionButtonTheme? lerp(
      ActionButtonTheme? a, ActionButtonTheme? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return ActionButtonTheme(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t)!,
      icon: b.icon,
    );
  }
}

class ActionButtonThemeDecoration {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;

  const ActionButtonThemeDecoration({
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
  });
}

final _CustomThemePrivateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `CustomTheme._()`. This constructor is only meant to be used by themeExtended and you are not supposed to need it nor use it.');

mixin _$CustomTheme {
  Color get backgroundColor => throw _CustomThemePrivateConstructorUsedError;
  Color get foregroundColor => throw _CustomThemePrivateConstructorUsedError;
  Color get textColor => throw _CustomThemePrivateConstructorUsedError;
  Alignment? get textAlign => throw _CustomThemePrivateConstructorUsedError;
  ActionButtonTheme get actionButtonTheme =>
      throw _CustomThemePrivateConstructorUsedError;
  String get themeName => throw _CustomThemePrivateConstructorUsedError;

  CustomTheme copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? textColor,
    Alignment? textAlign,
    ActionButtonTheme? actionButtonTheme,
    String? themeName,
  }) =>
      throw _CustomThemePrivateConstructorUsedError;

  CustomTheme copyWithDecoration(CustomThemeDecoration? decoration) =>
      throw _CustomThemePrivateConstructorUsedError;
}

class _CustomTheme implements CustomTheme {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color textColor;
  final Alignment? textAlign;
  final ActionButtonTheme actionButtonTheme;
  final String themeName;

  const _CustomTheme({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.textColor,
    this.textAlign,
    required this.actionButtonTheme,
    required this.themeName,
  });

  _CustomTheme copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? textColor,
    Alignment? textAlign,
    ActionButtonTheme? actionButtonTheme,
    String? themeName,
  }) =>
      _CustomTheme(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        foregroundColor: foregroundColor ?? this.foregroundColor,
        textColor: textColor ?? this.textColor,
        textAlign: textAlign ?? this.textAlign,
        actionButtonTheme: actionButtonTheme ?? this.actionButtonTheme,
        themeName: themeName ?? this.themeName,
      );

  _CustomTheme copyWithDecoration(CustomThemeDecoration? decoration) =>
      decoration != null
          ? _CustomTheme(
              backgroundColor:
                  decoration.backgroundColor ?? this.backgroundColor,
              foregroundColor:
                  decoration.foregroundColor ?? this.foregroundColor,
              textColor: decoration.textColor ?? this.textColor,
              textAlign: decoration.textAlign ?? this.textAlign,
              actionButtonTheme:
                  decoration.actionButtonTheme ?? this.actionButtonTheme,
              themeName: decoration.themeName ?? this.themeName,
            )
          : this;

  static CustomTheme? lerp(CustomTheme? a, CustomTheme? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return CustomTheme(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t)!,
      textColor: Color.lerp(a.textColor, b.textColor, t)!,
      textAlign: Alignment.lerp(a.textAlign, b.textAlign, t),
      actionButtonTheme:
          _ActionButtonTheme.lerp(a.actionButtonTheme, b.actionButtonTheme, t)!,
      themeName: b.themeName,
    );
  }
}

class CustomThemeDecoration {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? textColor;
  final Alignment? textAlign;
  final ActionButtonTheme? actionButtonTheme;
  final String? themeName;

  const CustomThemeDecoration({
    this.backgroundColor,
    this.foregroundColor,
    this.textColor,
    this.textAlign,
    this.actionButtonTheme,
    this.themeName,
  });
}

extension CustomThemeThemeData on ThemeData {
  CustomTheme get customThemeExtension =>
      this.extension<CustomThemeExtension>()!.theme;
}

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final CustomTheme theme;

  const CustomThemeExtension(this.theme);

  @override
  CustomThemeExtension copyWith({CustomTheme? theme}) {
    return CustomThemeExtension(theme ?? this.theme);
  }

  @override
  CustomThemeExtension lerp(CustomThemeExtension? other, double t) {
    if (other == null) return this;
    return CustomThemeExtension(_CustomTheme.lerp(theme, other.theme, t)!);
  }
}
