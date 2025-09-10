import 'package:test/test.dart';
import 'package:theme_extensions_generator/src/lerp_generator.dart';
import 'package:theme_extensions_generator/src/models.dart';
import 'package:theme_extensions_generator/src/templates.dart';

/// Regression tests to ensure backward compatibility after adding deep-copy functionality
void main() {
  group('Deep Copy Regression Tests', () {
    group('Backward compatibility', () {
      test(
          'generateDecorationClass should work same as before for old styled() without enableDeepCopy',
          () {
        DataType type = DataType('OldStyledThemeDecoration');
        List<Parameter> p = [
          Parameter('color', DataType('Color'), false, true,
              annotation: ParameterAnnotation.themeParameter),
          Parameter('nestedTheme', DataType('NestedTheme'), false, true,
              annotation:
                  ParameterAnnotation.styleParameter), // Old styled behavior
          Parameter('text', DataType('String'), false, true),
        ];

        var result = Templates.generateDecorationClass(type, p);

        // Old styled parameters should use original theme types, not decoration types
        expect(result, contains('final Color? color;'));
        expect(result,
            contains('final NestedTheme? nestedTheme;')); // Full theme type!
        expect(result, contains('final String? text;'));

        // Should not contain decoration types for old styled
        expect(result, isNot(contains('NestedThemeDecoration')));
      });

      test(
          'generateCopyWithDecorationMethod should work same as before for old styled() without enableDeepCopy',
          () {
        DataType type = DataType('OldStyledTheme');
        DataType decorationType = DataType('OldStyledThemeDecoration');
        List<Parameter> p = [
          Parameter('color', DataType('Color'), false, true,
              annotation: ParameterAnnotation.themeParameter),
          Parameter('nestedTheme', DataType('NestedTheme'), false, true,
              annotation:
                  ParameterAnnotation.styleParameter), // Old styled behavior
          Parameter('text', DataType('String'), false, true),
        ];

        var result =
            Templates.generateCopyWithDecorationMethod(type, decorationType, p);

        // All parameters should use simple override, including old styled
        expect(result, contains('color: decoration.color ?? color,'));
        expect(result,
            contains('nestedTheme: decoration.nestedTheme ?? nestedTheme,'));
        expect(result, contains('text: decoration.text ?? text,'));

        // Should not contain deep merge calls for old styled
        expect(result, isNot(contains('.copyWithDecoration(')));
      });

      test(
          'generateDecorationClass should work same as before for non-styled parameters',
          () {
        DataType type = DataType('LegacyThemeDecoration');
        List<Parameter> p = [
          Parameter('color', DataType('Color'), false, true),
          Parameter('size', DataType('double'), true, false),
          Parameter('text', DataType('String'), false, true),
        ];

        var result = Templates.generateDecorationClass(type, p);

        // All parameters should be nullable and use original types
        expect(result, contains('final Color? color;'));
        expect(result, contains('final double? size;'));
        expect(result, contains('final String? text;'));

        // Should not contain decoration types
        expect(result, isNot(contains('ColorDecoration')));
        expect(result, isNot(contains('doubleDecoration')));
        expect(result, isNot(contains('StringDecoration')));
      });

      test(
          'generateCopyWithDecorationMethod should work same as before for non-styled parameters',
          () {
        DataType type = DataType('LegacyTheme');
        DataType decorationType = DataType('LegacyThemeDecoration');
        List<Parameter> p = [
          Parameter('color', DataType('Color'), false, true),
          Parameter('size', DataType('double'), true, false),
          Parameter('text', DataType('String'), false, true),
        ];

        var result =
            Templates.generateCopyWithDecorationMethod(type, decorationType, p);

        // All parameters should use simple override
        expect(result, contains('color: decoration.color ?? color,'));
        expect(result, contains('size: decoration.size ?? size,'));
        expect(result, contains('text: decoration.text ?? text,'));

        // Should not contain deep merge calls
        expect(result, isNot(contains('.copyWithDecoration(')));
      });

      test('Mixed parameters should handle both styles correctly', () {
        DataType decorationType = DataType('MixedThemeDecoration');
        List<Parameter> p = [
          Parameter('regularColor', DataType('Color'), false, true,
              annotation: ParameterAnnotation.themeParameter),
          Parameter('styledTheme', DataType('StyledTheme'), false, true,
              annotation: ParameterAnnotation.deepStyleParameter),
          Parameter('regularText', DataType('String'), false, true,
              annotation: ParameterAnnotation.themeParameter),
        ];

        var decorationResult =
            Templates.generateDecorationClass(decorationType, p);

        // Regular parameters should use original types
        expect(decorationResult, contains('final Color? regularColor;'));
        expect(decorationResult, contains('final String? regularText;'));

        // Styled parameters should use decoration types
        expect(decorationResult,
            contains('final StyledThemeDecoration? styledTheme;'));

        DataType type = DataType('MixedTheme');
        var copyWithResult =
            Templates.generateCopyWithDecorationMethod(type, decorationType, p);

        // Regular parameters should use simple override
        expect(copyWithResult,
            contains('regularColor: decoration.regularColor ?? regularColor,'));
        expect(copyWithResult,
            contains('regularText: decoration.regularText ?? regularText,'));

        // Styled parameters should use deep merge
        expect(
            copyWithResult,
            contains(
                'styledTheme: decoration.styledTheme != null ? styledTheme.copyWithDecoration(decoration.styledTheme) : styledTheme,'));
      });
    });

    group('Edge cases', () {
      test('Empty parameter list should generate valid decoration class', () {
        DataType type = DataType('EmptyDecoration');
        List<Parameter> p = [];

        var result = Templates.generateDecorationClass(type, p);

        expect(result, contains('class EmptyDecoration'));
        expect(result, contains('const EmptyDecoration('));
      });

      test('Only styled parameters should work correctly', () {
        DataType type = DataType('OnlyStyledDecoration');
        List<Parameter> p = [
          Parameter('first', DataType('FirstTheme'), false, true,
              annotation: ParameterAnnotation.deepStyleParameter),
          Parameter('second', DataType('SecondTheme'), false, true,
              annotation: ParameterAnnotation.deepStyleParameter),
        ];

        var decorationResult = Templates.generateDecorationClass(type, p);
        var copyWithResult = Templates.generateCopyWithDecorationMethod(
            DataType('OnlyStyledTheme'), type, p);

        expect(
            decorationResult, contains('final FirstThemeDecoration? first;'));
        expect(
            decorationResult, contains('final SecondThemeDecoration? second;'));

        expect(
            copyWithResult,
            contains(
                'first: decoration.first != null ? first.copyWithDecoration(decoration.first) : first,'));
        expect(
            copyWithResult,
            contains(
                'second: decoration.second != null ? second.copyWithDecoration(decoration.second) : second,'));
      });

      test('Nullable styled parameters should work correctly', () {
        DataType type = DataType('NullableStyledDecoration');
        List<Parameter> p = [
          Parameter('optionalTheme', DataType('OptionalTheme'), true, false,
              annotation: ParameterAnnotation.deepStyleParameter),
          Parameter('requiredTheme', DataType('RequiredTheme'), false, true,
              annotation: ParameterAnnotation.deepStyleParameter),
        ];

        var decorationResult = Templates.generateDecorationClass(type, p);
        var copyWithResult = Templates.generateCopyWithDecorationMethod(
            DataType('NullableStyledTheme'), type, p);

        expect(decorationResult,
            contains('final OptionalThemeDecoration? optionalTheme;'));
        expect(decorationResult,
            contains('final RequiredThemeDecoration? requiredTheme;'));

        expect(
            copyWithResult,
            contains(
                'optionalTheme: decoration.optionalTheme != null ? optionalTheme.copyWithDecoration(decoration.optionalTheme) : optionalTheme,'));
        expect(
            copyWithResult,
            contains(
                'requiredTheme: decoration.requiredTheme != null ? requiredTheme.copyWithDecoration(decoration.requiredTheme) : requiredTheme,'));
      });
    });

    group('Parameter annotation handling', () {
      test('None annotation should be treated as theme parameter', () {
        DataType type = DataType('NoneAnnotationDecoration');
        List<Parameter> p = [
          Parameter('field1', DataType('Type1'), false, true,
              annotation: ParameterAnnotation.none),
          Parameter('field2', DataType('Type2'), false, true,
              annotation: ParameterAnnotation.themeParameter),
        ];

        var decorationResult = Templates.generateDecorationClass(type, p);
        var copyWithResult = Templates.generateCopyWithDecorationMethod(
            DataType('NoneAnnotationTheme'), type, p);

        // Both should be handled the same way as regular parameters
        expect(decorationResult, contains('final Type1? field1;'));
        expect(decorationResult, contains('final Type2? field2;'));

        expect(
            copyWithResult, contains('field1: decoration.field1 ?? field1,'));
        expect(
            copyWithResult, contains('field2: decoration.field2 ?? field2,'));
      });

      test('Style parameter annotation should trigger deep merge', () {
        DataType type = DataType('StyleAnnotationDecoration');
        List<Parameter> p = [
          Parameter('styledField', DataType('StyledType'), false, true,
              annotation: ParameterAnnotation.deepStyleParameter),
        ];

        var decorationResult = Templates.generateDecorationClass(type, p);
        var copyWithResult = Templates.generateCopyWithDecorationMethod(
            DataType('StyleAnnotationTheme'), type, p);

        expect(decorationResult,
            contains('final StyledTypeDecoration? styledField;'));
        expect(
            copyWithResult,
            contains(
                'styledField: decoration.styledField != null ? styledField.copyWithDecoration(decoration.styledField) : styledField,'));
      });
    });

    group('Complex scenarios', () {
      test('Deeply nested themes should generate correct decoration hierarchy',
          () {
        // Simulate scenario: ParentTheme -> ChildTheme -> GrandChildTheme
        DataType parentDecorationType = DataType('ParentThemeDecoration');
        List<Parameter> parentParams = [
          Parameter('child', DataType('ChildTheme'), false, true,
              annotation: ParameterAnnotation.deepStyleParameter),
          Parameter('parentColor', DataType('Color'), false, true,
              annotation: ParameterAnnotation.themeParameter),
        ];

        var parentDecorationResult = Templates.generateDecorationClass(
            parentDecorationType, parentParams);

        expect(parentDecorationResult,
            contains('final ChildThemeDecoration? child;'));
        expect(parentDecorationResult, contains('final Color? parentColor;'));

        // ChildTheme with its own nested object
        DataType childDecorationType = DataType('ChildThemeDecoration');
        List<Parameter> childParams = [
          Parameter('grandChild', DataType('GrandChildTheme'), false, true,
              annotation: ParameterAnnotation.deepStyleParameter),
          Parameter('childColor', DataType('Color'), false, true,
              annotation: ParameterAnnotation.themeParameter),
        ];

        var childDecorationResult =
            Templates.generateDecorationClass(childDecorationType, childParams);

        expect(childDecorationResult,
            contains('final GrandChildThemeDecoration? grandChild;'));
        expect(childDecorationResult, contains('final Color? childColor;'));
      });

      test('Large number of mixed parameters should be handled correctly', () {
        DataType type = DataType('LargeThemeDecoration');
        List<Parameter> params = [];

        // Add many parameters of different types
        for (int i = 0; i < 10; i++) {
          params.add(Parameter('regular$i', DataType('Type$i'), false, true,
              annotation: ParameterAnnotation.themeParameter));
          params.add(Parameter(
              'styled$i', DataType('StyledType$i'), false, true,
              annotation: ParameterAnnotation.deepStyleParameter));
        }

        var decorationResult = Templates.generateDecorationClass(type, params);
        var copyWithResult = Templates.generateCopyWithDecorationMethod(
            DataType('LargeTheme'), type, params);

        // Check several random parameters
        expect(decorationResult, contains('final Type5? regular5;'));
        expect(decorationResult,
            contains('final StyledType7Decoration? styled7;'));

        expect(copyWithResult,
            contains('regular3: decoration.regular3 ?? regular3,'));
        expect(
            copyWithResult,
            contains(
                'styled9: decoration.styled9 != null ? styled9.copyWithDecoration(decoration.styled9) : styled9,'));
      });
    });
  });
}
