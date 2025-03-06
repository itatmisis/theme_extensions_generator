# Motivation

Flutter provides awesome mechanism for extending a standard theme - Theme extensions. Adding your own extension includes the following steps:

- Creating a container class that extends the `ThemeExtension<T>` for storing parameters,
- Defenition of the container animation when changing the theme by overriding the `lerp` method,
- Defenition of the behavior of the container when changing properties using the `copyWith` method,
- Optionally, it is possible to create an extension for the `ThemeData` class, which will allow you to simply get the current theme.

Implementing all of this can take hundreds of lines, which are error-prone and affect the readability of your theme significantly.
It's worth considering that Flutter also provides a built-in `lerp` method for many embedded structures. Unfortunately, the classes that have this method are not unified by any interface, which complicates the correct use of this functionality. For numeric types in Dart, there is also a `Tween` with similar functionality.

Structures having `lerp`:

- AlignmentGeometry,
- Alignment,
- BorderRadius,
- Border,
- BoxConstraints,
- Color,
- Decoration,
- EdgeInsetsGeometry,
- EdgeInsets,
- FractionalOffset,
- Gradient,
- Offset,
- Matrix4,
- Rect,
- RelativeRect,
- ShapeBorder,
- Size,
- TextStyle,
- ThemeData.

All of them are supported by this generator.

| You write                     | Autogen do                       |
|-------------------------------|----------------------------------|
|![before](https://github.com/itatmisis/theme_extensions_generator/blob/master/theme_extensions_generator/docs/before.png?raw=true)     |![after](https://github.com/itatmisis/theme_extensions_generator/blob/master/theme_extensions_generator/docs/after.png?raw=true)          |

# Index

- [Motivation](#motivation)
- [Index](#index)
- [How to use](#how-to-use)
    - [Install](#install)
        - [Run the generator](#run-the-generator)
    - [Creating a theme using generator](#creating-a-theme-using-generator)
        - [Usage in UI](#usage-in-ui)
        - [What is decoration type](#what-is-decoration-type)
        - [Lerpable types](#lerpable-types)
        - [ThemeExtension and ThemeData extension. Nested Declaration](#themeextension-and-themedata-extension-nested-declaration)
    - [ThemeExtension initializing and registration](#themeextension-initializing-and-registration)

# How to use

## Install

To use ThemeExtensions Generator you will need your typical code-generator setup.

This installs three packages:

- [build_runner](https://pub.dev/packages/build_runner), the tool to run code-generators
- theme_extensions_generator, the code generator
- theme_extensions_annotation, a package containing annotations for theme_extensions_generator.

## Run the generator

To run the code generator, execute the following command:

```
dart run build_runner build
```

For Flutter projects, you can also run:

```
flutter pub run build_runner build
```

Note that like most code-generators, theme_extensions_generator will need you to both import the annotation (theme_extensions_annotation)
and use the `part` keyword on the top of your files.

As such, a file that wants to use theme_extensions_generator will start with:
```dart
import 'package:theme_extensions_annotation/theme_extensions_annotation.dart';

part 'my_file.g.dart';

```

## Creating a theme using generator

An example of a typical theme_extensions_generator class:
```dart
import 'package:flutter/material.dart';
import 'package:theme_extensions_annotation/theme_extension_annotation.dart';

part 'custom_theme.g.dart';

@ThemeExtended.themeOnly()
class ActionButtonTheme with _$ActionButtonTheme {
  const factory ActionButtonTheme({
    @ThemeProperty()
    required Color backgroundColor,
    @ThemeProperty()
    required Color foregroundColor,
    required IconData icon
  })= _ActionButtonTheme;
}

@ThemeExtended()
class CustomTheme with _$CustomTheme {
  const factory CustomTheme({
    @ThemeProperty()
    required Color backgroundColor,
    @ThemeProperty()
    required Color foregroundColor,
    @ThemeProperty()
    required Color textColor,
    @ThemeProperty()
    Alignment? textAlign,
    @ThemeProperty.styled()
    required ActionButtonTheme actionButtonTheme,

    required String themeName
  })= _CustomTheme;
}
```


The following snippet defines two themes named `ActionButtonTheme` and `CustomTheme`:

- `ActionButtonTheme` has 3 properties `backgroundColor`, `foregroundColor` and `icon`
- `CustomTheme` has 6 properties `backgroundColor`, `foregroundColor`, `textColor`, `textAlign`, `actionButtonTheme` and `themeName`
- `actionButtonTheme` has `@ThemeProperty.styled()`, it means that field supports specific `lerp` method
- Because we are using `@ThemeExtended`, some code will also automatically generate:
  - a `copyWith` method, for cloning the object with different properties
  - a `copyWithDecoration` this method also cloning the object with different properties, but in this case properties contains in "decoration"-structure 
  - a `lerp` method, that generate specific `lerp` for lerpable types.
  - a `ThemeData` extension for easy access
- `ActionButtonTheme` uses `@ThemeExtended.themeOnly()`, so `ThemeExtension` class and `ThemeData` extension for this class will not be generated
- `icon` in `ActionButtonTheme` and `themeName` in `CustomTheme` don't have annotation, therefore, specific `lerp` will not be generated for some fields

### Usage in UI

To use the widget, you just need to get the theme extension via the extension of `ThemeData`:
```dart
class MyHomePage extends StatelessWidget {
    const MyHomePage({super.key});

@override
Widget build(BuildContext context) {
    var theme = Theme.of(context)
        .yourThemeExtension

    return ...
    }
}

```

### What is decoration type

The decoration class is a tool that both simply helps to quickly redefine the fields specified by the theme, and facilitates the transfer of parameters to the widget constructor. Using decoration classes are also popular pattern in standard Flutter widgets:
```dart
Container(
    decoration: BoxDecoration(
    color: Colors.orange,
    border: Border.all(
        color: Colors.pink[800],
        width: 3.0),
    borderRadius: BorderRadius.all(
        Radius.circular(10.0)),
    boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))],
    ...
    ),
    child: ...
)
```

theme_extensions_generator generates simple structures for you:
```dart
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
```

Which you can then use in a widget constructor to redefine theme parameters:
```dart
class MyHomePage extends StatelessWidget {
    const MyHomePage(
        {super.key,
        this.decoration});

    final YourThemeDecoration? decoration;

@override
Widget build(BuildContext context) {
    var theme = Theme.of(context)
        .yourThemeExtension
        .copyWithDecoration(widget.decoration);

    return ...
    }
}
```
### Lerpable types

The generator supports all built-in types that have their own implementation of `lerp` and automatically uses their methods. If no `lerp` method is found for the type, or if the field does not contain annotations, it will be changed instantly:
```dart
static ActionButtonTheme? lerp(
    ActionButtonTheme? a, ActionButtonTheme? b, double t) {

    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return ActionButtonTheme(
        //Has annotation and built-in lerp method
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
        //Has annotation and built-in lerp method
        foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t)!,
        //Has not annotation or built-in lerp method
        icon: b.icon,
    );
}
```

The generator has an annotation `@ThemeProperty.styled()`, explicitly saying that the type has a `lerp` method that satisfies the interface:
```dart
static CustomType? lerp(CustomType? a, CustomType? b, double t)
```

### ThemeExtension and ThemeData extension. Nested Declaration

By default, when using the annotation `@ThemeExtended()` a `ThemeExtension` and an extension for `ThemeData` will be generated. In case you don't need them (for example, if the theme is nested), you can use the annotation `@ThemeExtended.themeOnly()`. In this case, they will not be generated.

### `extensionGetterName` parameter

You can customize the name of the extension getter by using the `extensionGetterName` parameter:

```dart
@ThemeExtended(extensionGetterName: 'customTheme')
class CustomTheme with _$CustomTheme {
  // Your theme implementation
}
```

Then use it to access extension:

```dart
var theme = Theme.of(context).customTheme;
```

## ThemeExtension initializing and registration

According to the [Flutter documentation](https://api.flutter.dev/flutter/material/ThemeExtension-class.html), to register a theme extension, you need to add the generated `ThemeExtension` class, as shown in the example below:
```dart
class Example extends StatelessWidget {

    CustomTheme lightTheme = const CustomTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        textColor: Colors.black,
        themeName: 'Light',
        actionButtonTheme: ActionButtonTheme(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.black,
            icon: Icons.add));

    CustomTheme darkTheme = const CustomTheme(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.blue,
        textColor: Colors.white,
        textAlign: Alignment.centerRight,
        themeName: 'Dark',
        actionButtonTheme: ActionButtonTheme(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            icon: Icons.add));

    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(extensions: [
                CustomThemeExtension(someSwitch ? lightTheme : darkTheme)
            ]),
            home: ...
        );
    }
}
```
