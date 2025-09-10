import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:theme_extensions_annotation/theme_extension_annotation.dart';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'lerp_generator.dart';
import 'models.dart';
import 'templates.dart';

class ThemeExtensionGenerator extends GeneratorForAnnotation<ThemeExtended> {
  void forEachField(
      Map<FormalParameterElement, List<ElementAnnotation>> fields,
      Map<
              String,
              void Function(String type, String varname,
                  FormalParameterElement element, DartObject? computeObject)>
          on) {
    for (var f in fields.entries) {
      if (fields[f.key]!.isEmpty && on.containsKey('null')) {
        on['null']!(f.key.type.getDisplayString().replaceAll('?', ''),
            f.key.displayName, f.key, null);
      }

      for (var m in fields[f.key]!) {
        var name = m.toSource();
        name = name.replaceRange(name.indexOf('(') + 1, name.length - 1, '');
        if (on.containsKey(name)) {
          on[name]!(f.key.type.getDisplayString().replaceAll('?', ''),
              f.key.displayName, f.key, m.computeConstantValue());
          break;
        }
      }
    }
  }

  Map<FormalParameterElement, List<ElementAnnotation>> inspectConstructor(
      ConstructorElement2 element) {
    Map<FormalParameterElement, List<ElementAnnotation>> inspect = {};

    for (var e in element.children2) {
      final parameterElement = e as FormalParameterElement;
      inspect[parameterElement] = e.metadata2.annotations;
    }

    return inspect;
  }

  List<Parameter> parseFields(
      Map<FormalParameterElement, List<ElementAnnotation>> parameters,
      LerpGenerator generator) {
    List<Parameter> p = [];
    forEachField(parameters, {
      '@ThemeProperty()': (t, v, e, c) {
        p.add(Parameter(
            v,
            DataType(t),
            e.type.nullabilitySuffix == NullabilitySuffix.question,
            e.isRequiredNamed,
            annotation: ParameterAnnotation.themeParameter));
      },
      '@ThemeProperty.styled()': (t, v, e, c) {
        generator.addLerpTypename(
            TransformModel.withNamespace(DataType(t), DataType('_$t')));

        // Check if enableDeepCopy is set to true
        var enableDeepCopy =
            c?.getField('enableDeepCopy')?.toBoolValue() ?? false;
        var annotation = enableDeepCopy
            ? ParameterAnnotation.deepStyleParameter
            : ParameterAnnotation.styleParameter;

        p.add(Parameter(
            v,
            DataType(t),
            e.type.nullabilitySuffix == NullabilitySuffix.question,
            e.isRequiredNamed,
            annotation: annotation));
      },
      '@ThemeProperty.lerp()': (t, v, e, c) {
        var targetType = c!.getField('targetType')!.toStringValue();
        generator.addLerpTypename(
            TransformModel.withNamespace(DataType(t), DataType(targetType!)));
        p.add(Parameter(
            v,
            DataType(t),
            e.type.nullabilitySuffix == NullabilitySuffix.question,
            e.isRequiredNamed,
            annotation: ParameterAnnotation.styleParameter));
      },
      '@ThemeProperty.tween()': (t, v, e, c) {
        var targetType = c!.getField('targetType')!.toStringValue();
        generator.addTweenTypename(
            TransformModel.withNamespace(DataType(t), DataType(targetType!)));
        p.add(Parameter(
            v,
            DataType(t),
            e.type.nullabilitySuffix == NullabilitySuffix.question,
            e.isRequiredNamed,
            annotation: ParameterAnnotation.styleParameter));
      },
      'null': (t, v, e, c) {
        p.add(Parameter(
            v,
            DataType(t),
            e.type.nullabilitySuffix == NullabilitySuffix.question,
            e.isRequiredNamed,
            allowLerp: false));
      }
    });

    return p;
  }

  String generateSource(Element element) {
    String result = '';

    return result;
  }

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    var classImpl = element as ClassElement2;
    var constructorImpl = element.children2[0] as ConstructorElement2;

    var result = '';

    var targetType = DataType(classImpl.displayName);
    var mixinType = DataType('_\$${classImpl.displayName}');
    var decorationType = DataType('${classImpl.displayName}Decoration');
    var implementationType = DataType('_${classImpl.displayName}');
    var extensionType = DataType('${classImpl.displayName}Extension');

    var lerpGenerator = LerpGenerator();
    var parameters =
        parseFields(inspectConstructor(constructorImpl), lerpGenerator);

    var annotationType = annotation.objectValue
        .getField('type')!
        .getField('_name')!
        .toStringValue();
    var extensionGetterName =
        annotation.objectValue.getField('extensionGetterName')?.toStringValue();

    if (annotationType == 'themeOnly') {
      result += Templates.generateMixin(
          mixinType, targetType, decorationType, parameters, lerpGenerator);
      result += Templates.generateMainClass(implementationType, targetType,
          decorationType, parameters, lerpGenerator);
      result += Templates.generateDecorationClass(decorationType, parameters);
    } else if (annotationType == 'full') {
      result += Templates.generateMixin(
          mixinType, targetType, decorationType, parameters, lerpGenerator);
      result += Templates.generateMainClass(implementationType, targetType,
          decorationType, parameters, lerpGenerator);
      result += Templates.generateDecorationClass(decorationType, parameters);

      lerpGenerator.addLerpTypename(
          TransformModel.withNamespace(targetType, implementationType));
      result += Templates.generateThemeExtension(
        extensionType,
        targetType,
        lerpGenerator,
        extensionGetterName,
      );
    }

    // Validate unsupported types for fields that are supposed to be lerpable/tweenable
    for (final p in parameters) {
      if (p.allowLerp) {
        final transform = lerpGenerator.transformFunction(p.type);
        if (transform is LerpGeneratorResultNone) {
          throw InvalidGenerationSource('Unsupported type: ${p.type.name}',
              element: element);
        }
      }
    }

    return result;
  }
}
