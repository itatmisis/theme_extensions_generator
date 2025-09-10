import 'constants.dart';
import 'lerp_generator.dart';
import 'models.dart';

/// Renders fragments of generated source code for themes.
class Templates {
    /// Emits expression that tweens between `a` and `b` for the given [type].
  static String generateTween(DataType type, String a, String b) {
    if (type.toString() == 'int') {
      return 'IntTween(begin: $a, end: $b).transform(${Constants.varnameTransform})';
    }

    return 'Tween<$type>(begin: $a, end: $b).transform(${Constants.varnameTransform})';
  }

    /// Emits expression that calls `<Type>.lerp(a, b, t)`; adds `!` if non-nullable.
  static String generateLerp(DataType type, String a, String b, bool nullable) {
    return '$type.lerp($a, $b, ${Constants.varnameTransform})${nullable ? '' : '!'}';
  }

    /// Emits constructor parameter list like `{required this.a, ...}`.
  static String generateConstructorParameters(Iterable<Parameter> parameters) {
    String e = '';

    for (var p in parameters) {
      e += '${p.required ? 'required ' : ''}this.${p.name},';
    }

    return '{$e}';
  }

    /// Emits method parameter list like `{Type? a, ...}` with optional `required`.
  static String generateMethodParameters(Iterable<Parameter> parameters,
      [bool isNullable = false]) {
    String e = '';

    for (var p in parameters) {
      e +=
          '${p.required && !isNullable ? 'required ' : ''}${p.type}${isNullable || p.nullable ? '?' : ''} ${p.name},';
    }

    return '{$e}';
  }

    /// Emits `final` fields for the class from [parameters].
  static String generateClassFields(Iterable<Parameter> parameters) {
    String e = '';

    for (var p in parameters) {
      e += 'final ${p.type}${p.nullable ? '?' : ''} ${p.name};';
    }

    return e;
  }

    /// Emits `const` constructor for [type].
  static String generateConstructor(
      DataType type, Iterable<Parameter> parameters) {
    return 'const $type(${generateConstructorParameters(parameters)});';
  }

    /// Emits `copyWith` method for [type].
  static String generateCopyWithMethod(
      DataType type, Iterable<Parameter> parameters) {
    String e = '';

    for (var p in parameters) {
      e += '${p.name}: ${p.name} ?? this.${p.name},';
    }

    return '$type copyWith(${generateMethodParameters(parameters, true)}) => $type($e);';
  }

    /// Emits `copyWithDecoration` method using [decorationType].
  static String generateCopyWithDecorationMethod(
      DataType type, DataType decorationType, Iterable<Parameter> parameters) {
    String e = '';

    for (var p in parameters) {
      e += '${p.name}: decoration.${p.name} ?? this.${p.name},';
    }

    return '$type copyWithDecoration($decorationType? decoration) => decoration != null? $type($e) : this;';
  }

    /// Emits expression that calls `<Type>.lerp(a, b, t)`; adds `!` if non-nullable.
    /// Emits static `lerp` method for the main theme type.
  static String generateLerpMethod(
      DataType type, Iterable<Parameter> parameters, LerpGenerator generator) {
    String e = '';

    for (var p in parameters) {
      e += '${p.name}: ';

      var type = generator.transformFunction(p.type);

      if (p.allowLerp) {
        if (type is LerpGeneratorResultFound) {
          if (type.state == TransformState.tween && !p.nullable) {
            e +=
                '${generateTween(type.namespaceType, 'a.${p.name}', 'b.${p.name}')},';
            continue;
          } else if (type.state == TransformState.lerp) {
            e +=
                '${generateLerp(type.namespaceType, 'a.${p.name}', 'b.${p.name}', p.nullable)},';
            continue;
          }
        }
      }
      e += 'b.${p.name},';
    }

    return 'static $type? lerp($type? a, $type? b, double ${Constants.varnameTransform}) { if (a == null && b == null) return null; if (a == null) return b; if (b == null) return a; return $type($e);}';
  }

    /// Emits decoration class with all fields made nullable.
  static String generateDecorationClass(
      DataType type, Iterable<Parameter> parameters) {
    List<Parameter> changedParameters = [];

    for (var p in parameters) {
      var t = DataType(p.type.name);
      var changedP = Parameter(p.name, t, true, false);
      changedParameters.add(changedP);
    }

    return '''
    class $type {
      ${generateClassFields(changedParameters)}
      
      ${generateConstructor(type, changedParameters)}
    }''';
  }

    /// Emits main implementation class that implements [parentType].
  static String generateMainClass(
      DataType type,
      DataType parentType,
      DataType decorationType,
      Iterable<Parameter> parameters,
      LerpGenerator generator) {
    return '''
    class $type implements $parentType {
      ${generateClassFields(parameters)}
      
      ${generateConstructor(type, parameters)}
      
      ${generateCopyWithMethod(type, parameters)}
      
      ${generateCopyWithDecorationMethod(type, decorationType, parameters)}
      
      ${generateLerpMethod(parentType, parameters, generator)}
    }''';
  }

    /// Emits getters for mixin that throw a private constructor error.
  static String generateMixinGetters(
      Iterable<Parameter> parameters, String errorName) {
    String e = '';

    for (var p in parameters) {
      e +=
          '${p.type}${p.nullable ? '?' : ''} get ${p.name} => throw $errorName;';
    }

    return e;
  }

    /// Emits `copyWith` mixin stub that throws.
  static String generateMixinCopyWithMethod(
      DataType parentType, Iterable<Parameter> parameters, String errorName) {
    return '$parentType copyWith(${generateMethodParameters(parameters, true)}) => throw $errorName;';
  }

    /// Emits `copyWithDecoration` mixin stub that throws.
  static String generateMixinCopyWithDecorationMethod(
      DataType parentType,
      DataType decorationType,
      Iterable<Parameter> parameters,
      String errorName) {
    return '$parentType copyWithDecoration($decorationType? decoration) => throw $errorName;';
  }

    /// Emits mixin declaration for the annotated theme type.
  static String generateMixin(
      DataType type,
      DataType parentType,
      DataType decorationType,
      Iterable<Parameter> parameters,
      LerpGenerator generator) {
    String errorName = '_${parentType.name}PrivateConstructorUsedError';
    return '''
    
    final $errorName = UnsupportedError(
        'It seems like you constructed your class using `${parentType.name}._()`. This constructor is only meant to be used by themeExtended and you are not supposed to need it nor use it.');
    
    mixin $type {
      ${generateMixinGetters(parameters, errorName)}
      
      ${generateMixinCopyWithMethod(parentType, parameters, errorName)}
      
      ${generateMixinCopyWithDecorationMethod(parentType, decorationType, parameters, errorName)}
    }''';
  }

    /// Emits ThemeData extension and ThemeExtension wrapper class.
  static String generateThemeExtension(
    DataType extensionType,
    DataType themeType,
    LerpGenerator generator,
    String? extensionGetterName,
  ) {
    var lerpType = generator.transformFunction(themeType);

    if (lerpType is! LerpGeneratorResultFound) {
      throw UnsupportedError('Theme class not registered in lerpGenerator');
    }

    extensionGetterName ??=
        extensionType.name[0].toLowerCase() + extensionType.name.substring(1);

    return '''
    
    extension ${themeType}ThemeData on ThemeData {
      $themeType get $extensionGetterName => this.extension<$extensionType>()!.theme;
    }
    
    class $extensionType extends ThemeExtension<$extensionType> {
      final $themeType theme;
      
      const $extensionType(this.theme);
      
      @override
      $extensionType copyWith({$themeType? theme}) {
        return $extensionType(theme ?? this.theme);
      }
      
      @override
      $extensionType lerp($extensionType? other, double ${Constants.varnameTransform}) {
        if (other == null) return this;
        return $extensionType(${lerpType.namespaceType}.lerp(theme, other.theme, ${Constants.varnameTransform})!);
      }
    }''';
  }
}
