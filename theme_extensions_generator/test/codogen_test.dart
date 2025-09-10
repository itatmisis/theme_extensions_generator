import 'package:test/test.dart';
import 'package:theme_extensions_generator/src/lerp_generator.dart';
import 'package:theme_extensions_generator/src/models.dart';
import 'package:theme_extensions_generator/src/templates.dart';

void main() {
  void Function(dynamic) print = (d) {};

  group('Templates.generateTween', () {
    test('Templates.generateTween double', () {
      var t = Templates.generateTween(DataType('double'), 'a', 'b');
      print(t);
      expect(t, equals('Tween<double>(begin: a, end: b).transform(t)'));
    });
    test('Templates.generateTween int', () {
      var t = Templates.generateTween(DataType('int'), 'a', 'b');
      print(t);
      expect(t, equals('IntTween(begin: a, end: b).transform(t)'));
    });
  });

  group('Templates.generateLerp', () {
    test('Templates.generateLerp Color', () {
      var t = Templates.generateLerp(DataType('Color'), 'a', 'b', false);
      print(t);
      expect(t, equals('Color.lerp(a, b, t)!'));
    });
    test('Templates.generateLerp Offset', () {
      var t = Templates.generateLerp(DataType('Offset'), 'a', 'b', false);
      print(t);
      expect(t, equals('Offset.lerp(a, b, t)!'));
    });
  });

  group('Templates.generateConstructorParameters', () {
    test('Templates.generateConstructorParameters Required', () {
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), false, true),
        Parameter('foregroundColor', DataType('Color'), false, true),
        Parameter('padding', DataType('double'), false, true)
      ];
      var t = Templates.generateConstructorParameters(p);
      print(t);
      expect(
          t,
          equals(
              '{required this.backgroundColor,required this.foregroundColor,required this.padding,}'));
    });
    test('Templates.generateConstructorParameters Not required', () {
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), false, false),
        Parameter('foregroundColor', DataType('Color'), false, false),
        Parameter('padding', DataType('double'), false, false)
      ];
      var t = Templates.generateConstructorParameters(p);
      print(t);
      expect(t,
          equals('{this.backgroundColor,this.foregroundColor,this.padding,}'));
    });
    test('Templates.generateConstructorParameters Nullable', () {
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, true)
      ];
      var t = Templates.generateConstructorParameters(p);
      print(t);
      expect(
          t,
          equals(
              '{required this.backgroundColor,this.foregroundColor,required this.padding,}'));
    });
  });

  group('Templates.generateMethodParameters', () {
    test('Templates.generateMethodParameters Not nullable', () {
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), false, true),
        Parameter('foregroundColor', DataType('Color'), false, true),
        Parameter('padding', DataType('double'), false, true)
      ];
      var t = Templates.generateMethodParameters(p);
      print(t);
      expect(
          t,
          equals(
              '{required Color backgroundColor,required Color foregroundColor,required double padding,}'));
    });
    test('Templates.generateMethodParameters Nullable', () {
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, true)
      ];
      var t = Templates.generateMethodParameters(p);
      print(t);
      expect(
          t,
          equals(
              '{required Color? backgroundColor,Color? foregroundColor,required double padding,}'));
    });
  });

  group('Templates.generateConstructorParameters', () {
    test('Templates.generateConstructorParameters Required', () {
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), false, true),
        Parameter('foregroundColor', DataType('Color'), false, true),
        Parameter('padding', DataType('double'), false, true)
      ];
      var t = Templates.generateConstructorParameters(p);
      print(t);
      expect(
          t,
          equals(
              '{required this.backgroundColor,required this.foregroundColor,required this.padding,}'));
    });
    test('Templates.generateConstructorParameters Not required', () {
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), false, false),
        Parameter('foregroundColor', DataType('Color'), false, false),
        Parameter('padding', DataType('double'), false, false)
      ];
      var t = Templates.generateConstructorParameters(p);
      print(t);
      expect(t,
          equals('{this.backgroundColor,this.foregroundColor,this.padding,}'));
    });
    test('Templates.generateConstructorParameters Nullable', () {
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, true)
      ];
      var t = Templates.generateConstructorParameters(p);
      print(t);
      expect(
          t,
          equals(
              '{required this.backgroundColor,this.foregroundColor,required this.padding,}'));
    });
  });

  group('Templates.generateClassFields', () {
    test('Templates.generateClassFields Not nullable', () {
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), false, true),
        Parameter('foregroundColor', DataType('Color'), false, true),
        Parameter('padding', DataType('double'), false, true)
      ];
      var t = Templates.generateClassFields(p);
      print(t);
      expect(
          t,
          equals(
              'final Color backgroundColor;final Color foregroundColor;final double padding;'));
    });
    test('Templates.generateClassFields Nullable', () {
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, true)
      ];
      var t = Templates.generateClassFields(p);
      print(t);
      expect(
          t,
          equals(
              'final Color? backgroundColor;final Color? foregroundColor;final double padding;'));
    });
  });

  group('Templates.generateConstructor', () {
    test('Templates.generateConstructor TestType', () {
      DataType type = DataType('TestType');
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, false)
      ];
      var t = Templates.generateConstructor(type, p);
      print(t);
      expect(
          t,
          equals(
              'const TestType({required this.backgroundColor,this.foregroundColor,this.padding,});'));
    });
  });

  group('Templates.generateCopyWithMethod', () {
    test('Templates.generateCopyWithMethod TestType', () {
      DataType type = DataType('TestType');
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, false)
      ];
      var t = Templates.generateCopyWithMethod(type, p);
      print(t);
      expect(
          t,
          equals(
              'TestType copyWith({Color? backgroundColor,Color? foregroundColor,double? padding,}) => TestType(backgroundColor: backgroundColor ?? this.backgroundColor,foregroundColor: foregroundColor ?? this.foregroundColor,padding: padding ?? this.padding,);'));
    });
  });

  group('Templates.generateCopyWithDecorationMethod', () {
    test('Templates.generateCopyWithDecorationMethod TestType', () {
      DataType type = DataType('TestType');
      DataType decorationType = DataType('TestTypeDecoration');
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, false)
      ];
      var t =
          Templates.generateCopyWithDecorationMethod(type, decorationType, p);
      print(t);
      expect(
          t,
          equals(
              'TestType copyWithDecoration(TestTypeDecoration? decoration) => decoration != null? TestType(backgroundColor: decoration.backgroundColor ?? backgroundColor,foregroundColor: decoration.foregroundColor ?? foregroundColor,padding: decoration.padding ?? padding,) : this;'));
    });

    test(
        'Templates.generateCopyWithDecorationMethod with deep merge for styled parameters',
        () {
      DataType type = DataType('ComplexTheme');
      DataType decorationType = DataType('ComplexThemeDecoration');
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), false, true,
            annotation: ParameterAnnotation.themeParameter),
        Parameter('nestedTheme', DataType('NestedTheme'), false, true,
            annotation: ParameterAnnotation.deepStyleParameter),
        Parameter('textColor', DataType('Color'), false, true,
            annotation: ParameterAnnotation.themeParameter),
      ];
      var t =
          Templates.generateCopyWithDecorationMethod(type, decorationType, p);
      print(t);
      expect(
          t,
          allOf([
            contains(
                'ComplexTheme copyWithDecoration(ComplexThemeDecoration? decoration)'),
            contains(
                'backgroundColor: decoration.backgroundColor ?? backgroundColor,'),
            contains(
                'nestedTheme: decoration.nestedTheme != null ? nestedTheme.copyWithDecoration(decoration.nestedTheme) : nestedTheme,'),
            contains('textColor: decoration.textColor ?? textColor,')
          ]));
    });

    test(
        'Templates.generateCopyWithDecorationMethod with multiple styled parameters',
        () {
      DataType type = DataType('MultiNestedTheme');
      DataType decorationType = DataType('MultiNestedThemeDecoration');
      List<Parameter> p = [
        Parameter('firstNested', DataType('FirstTheme'), false, true,
            annotation: ParameterAnnotation.deepStyleParameter),
        Parameter('secondNested', DataType('SecondTheme'), false, true,
            annotation: ParameterAnnotation.deepStyleParameter),
        Parameter('regularField', DataType('String'), false, true,
            annotation: ParameterAnnotation.themeParameter),
      ];
      var t =
          Templates.generateCopyWithDecorationMethod(type, decorationType, p);
      print(t);
      expect(
          t,
          allOf([
            contains(
                'firstNested: decoration.firstNested != null ? firstNested.copyWithDecoration(decoration.firstNested) : firstNested,'),
            contains(
                'secondNested: decoration.secondNested != null ? secondNested.copyWithDecoration(decoration.secondNested) : secondNested,'),
            contains('regularField: decoration.regularField ?? regularField,')
          ]));
    });

    test('Templates.generateCopyWithDecorationMethod mixed parameters', () {
      DataType type = DataType('MixedTheme');
      DataType decorationType = DataType('MixedThemeDecoration');
      List<Parameter> p = [
        Parameter('color', DataType('Color'), false, true,
            annotation: ParameterAnnotation.themeParameter),
        Parameter('childTheme', DataType('ChildTheme'), false, true,
            annotation: ParameterAnnotation.deepStyleParameter),
        Parameter('size', DataType('double'), false, true,
            annotation: ParameterAnnotation.themeParameter),
        Parameter('anotherChild', DataType('AnotherTheme'), false, true,
            annotation: ParameterAnnotation.deepStyleParameter),
      ];
      var t =
          Templates.generateCopyWithDecorationMethod(type, decorationType, p);
      print(t);
      expect(
          t,
          allOf([
            contains('color: decoration.color ?? color,'),
            contains(
                'childTheme: decoration.childTheme != null ? childTheme.copyWithDecoration(decoration.childTheme) : childTheme,'),
            contains('size: decoration.size ?? size,'),
            contains(
                'anotherChild: decoration.anotherChild != null ? anotherChild.copyWithDecoration(decoration.anotherChild) : anotherChild,')
          ]));
    });
  });

  group('Templates.generateLerpMethod', () {
    test('Templates.generateLerpMethod TestType', () {
      DataType type = DataType('TestType');
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, false)
      ];
      var t = Templates.generateLerpMethod(type, p, LerpGenerator());
      print(t);
    });

    test('Templates.generateLerpMethod ParentTestType Lerp', () {
      DataType type = DataType('ParentTestType');
      List<Parameter> p = [
        Parameter('testType', DataType('TestType'), true, true),
      ];

      var l = LerpGenerator()
        ..addLerpTypename(TransformModel.withNamespace(
            DataType('TestType'), DataType('_TestType')));

      var t = Templates.generateLerpMethod(type, p, l);
      print(t);
    });

    test('Templates.generateLerpMethod ParentTestType Tween', () {
      DataType type = DataType('ParentTestType');
      List<Parameter> p = [
        Parameter('testType', DataType('TestType'), true, true),
      ];

      var l = LerpGenerator()
        ..addTweenTypename(TransformModel.withNamespace(
            DataType('TestType'), DataType('_TestType')));

      var t = Templates.generateLerpMethod(type, p, l);
      print(t);
    });

    group('Templates.generateDecorationClass', () {
      test('Templates.generateDecorationClass TestTypeDecoration', () {
        DataType type = DataType('TestTypeDecoration');
        List<Parameter> p = [
          Parameter('backgroundColor', DataType('Color'), true, true),
          Parameter('foregroundColor', DataType('Color'), true, false),
          Parameter('padding', DataType('double'), false, false)
        ];
        var t = Templates.generateDecorationClass(type, p);
        print(t);
        expect(
            t,
            allOf([
              contains('class TestTypeDecoration'),
              contains('{'),
              contains(
                  'final Color? backgroundColor;final Color? foregroundColor;final double? padding;'),
              contains(
                  'const TestTypeDecoration({this.backgroundColor,this.foregroundColor,this.padding,});'),
              contains('}')
            ]));
      });

      test('Templates.generateDecorationClass with styled parameters', () {
        DataType type = DataType('ComplexThemeDecoration');
        List<Parameter> p = [
          Parameter('backgroundColor', DataType('Color'), false, true,
              annotation: ParameterAnnotation.themeParameter),
          Parameter('nestedTheme', DataType('NestedTheme'), false, true,
              annotation: ParameterAnnotation.deepStyleParameter),
          Parameter('textColor', DataType('Color'), false, true,
              annotation: ParameterAnnotation.themeParameter),
        ];
        var t = Templates.generateDecorationClass(type, p);
        print(t);
        expect(
            t,
            allOf([
              contains('class ComplexThemeDecoration'),
              contains('final Color? backgroundColor;'),
              contains('final NestedThemeDecoration? nestedTheme;'),
              contains('final Color? textColor;'),
              isNot(contains('final NestedTheme? nestedTheme;'))
            ]));
      });

      test('Templates.generateDecorationClass with multiple styled parameters',
          () {
        DataType type = DataType('MultiNestedDecoration');
        List<Parameter> p = [
          Parameter('firstNested', DataType('FirstTheme'), false, true,
              annotation: ParameterAnnotation.deepStyleParameter),
          Parameter('secondNested', DataType('SecondTheme'), false, true,
              annotation: ParameterAnnotation.deepStyleParameter),
          Parameter('regularField', DataType('String'), false, true,
              annotation: ParameterAnnotation.themeParameter),
        ];
        var t = Templates.generateDecorationClass(type, p);
        print(t);
        expect(
            t,
            allOf([
              contains('final FirstThemeDecoration? firstNested;'),
              contains('final SecondThemeDecoration? secondNested;'),
              contains('final String? regularField;')
            ]));
      });
    });
  });

  group('Templates.generateMainClass', () {
    test('Templates.generateMainClass TestTypeTheme', () {
      DataType type = DataType('TestTypeTheme');
      DataType parentType = DataType('TestType');
      DataType decorationType = DataType('TestTypeDecoration');
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, false)
      ];

      var l = LerpGenerator();
      var t =
          Templates.generateMainClass(type, parentType, decorationType, p, l);
      print(t);
      expect(
          t,
          allOf([
            contains('class TestTypeTheme implements TestType'),
            contains('{'),
            contains(Templates.generateConstructor(type, p)),
            contains(Templates.generateCopyWithMethod(type, p)),
            contains(Templates.generateCopyWithDecorationMethod(
                type, decorationType, p)),
            contains(Templates.generateLerpMethod(parentType, p, l)),
            contains('}')
          ]));
    });
  });

  group('Templates.generateMixinGetters', () {
    test('Templates.generateMixinGetters', () {
      String errorName = 'Error';
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, false)
      ];

      var t = Templates.generateMixinGetters(p, errorName);
      print(t);
      expect(
          t,
          allOf([
            contains('Color? get backgroundColor => throw Error'),
            contains('Color? get foregroundColor => throw Error'),
            contains('double get padding => throw Error')
          ]));
    });
  });

  group('Templates.generateMixinCopyWithMethod', () {
    test('Templates.generateMixinCopyWithMethod TestType', () {
      String errorName = 'Error';
      DataType type = DataType('TestType');
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, false)
      ];

      var t = Templates.generateMixinCopyWithMethod(type, p, errorName);
      print(t);
      expect(
          t,
          allOf([
            contains('TestType'),
            contains(
                'copyWith({Color? backgroundColor,Color? foregroundColor,double? padding,}) => throw Error'),
          ]));
    });
  });

  group('Templates.generateMixinCopyWithDecorationMethod', () {
    test('Templates.generateMixinCopyWithDecorationMethod TestType', () {
      String errorName = 'Error';
      DataType type = DataType('TestType');
      DataType decorationType = DataType('TestTypeDecoration');
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, false)
      ];

      var t = Templates.generateMixinCopyWithDecorationMethod(
          type, decorationType, p, errorName);
      print(t);
      expect(
          t,
          allOf([
            contains('TestType'),
            contains(
                'copyWithDecoration(TestTypeDecoration? decoration) => throw Error'),
          ]));
    });
  });

  group('Templates.generateMixin', () {
    test('Templates.generateMixin TestType', () {
      DataType type = DataType('_\$TestType');
      DataType parentType = DataType('TestType');
      DataType decorationType = DataType('TestTypeDecoration');
      List<Parameter> p = [
        Parameter('backgroundColor', DataType('Color'), true, true),
        Parameter('foregroundColor', DataType('Color'), true, false),
        Parameter('padding', DataType('double'), false, false)
      ];

      var t = Templates.generateMixin(
          type, parentType, decorationType, p, LerpGenerator());
      print(t);
      expect(
          t,
          allOf([
            contains('_TestTypePrivateConstructorUsedError'),
            contains('mixin _\$TestType'),
            contains(Templates.generateMixinGetters(
                p, '_TestTypePrivateConstructorUsedError')),
            contains(Templates.generateMixinCopyWithDecorationMethod(parentType,
                decorationType, p, '_TestTypePrivateConstructorUsedError')),
            contains(Templates.generateMixinCopyWithDecorationMethod(parentType,
                decorationType, p, '_TestTypePrivateConstructorUsedError'))
          ]));
    });
  });

  group('Templates.generateThemeExtension', () {
    test('Templates.generateThemeExtension TestType (default getter)', () {
      DataType extensionType = DataType('TestTypeExtension');
      DataType themeType = DataType('TestType');

      var l = LerpGenerator();
      l.addLerpTypename(
          TransformModel.withNamespace(themeType, DataType('_TestType')));

      var t = Templates.generateThemeExtension(
        extensionType,
        themeType,
        l,
        null,
      );

      expect(
          t,
          allOf([
            contains('TestTypeThemeData'),
            contains('class TestTypeExtension'),
            contains(
                'TestType get testTypeExtension => this.extension<TestTypeExtension>()!.theme;'),
          ]));
    });

    test('Templates.generateThemeExtension TestType (custom getter)', () {
      DataType extensionType = DataType('TestTypeExtension');
      DataType themeType = DataType('TestType');

      var l = LerpGenerator();
      l.addLerpTypename(
          TransformModel.withNamespace(themeType, DataType('_TestType')));

      var t = Templates.generateThemeExtension(
        extensionType,
        themeType,
        l,
        'veryCustomExtensionName',
      );

      expect(
          t,
          allOf([
            contains('TestTypeThemeData'),
            contains('class TestTypeExtension'),
            contains(
                'TestType get veryCustomExtensionName => this.extension<TestTypeExtension>()!.theme;'),
          ]));
    });
  });
}
