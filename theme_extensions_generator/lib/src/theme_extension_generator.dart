import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
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
      Map<ParameterElement, List<ElementAnnotation>> fields,
      Map<
              String,
              void Function(String type, String varname,
                  ParameterElement element, DartObject? computeObject)>
          on) {
    for (var f in fields.entries) {
      if (fields[f.key]!.isEmpty && on.containsKey('null')) {
        on['null']!(f.key.type.getDisplayString(withNullability: false),
            f.key.name, f.key, null);
      }

      for (var m in fields[f.key]!) {
        var name = m.toSource();
        name = name.replaceRange(name.indexOf('(') + 1, name.length - 1, '');
        if (on.containsKey(name)) {
          on[name]!(f.key.type.getDisplayString(withNullability: false),
              f.key.name, f.key, m.computeConstantValue());
          break;
        }
      }
    }
  }

  Map<ParameterElement, List<ElementAnnotation>> inspectConstructor(
      ConstructorElement element) {
    Map<ParameterElement, List<ElementAnnotation>> inspect = {};

    for (var e in element.children) {
      final parameterElement = e as ParameterElement;
      inspect[parameterElement] = e.metadata;
    }

    return inspect;
  }

  List<Parameter> parseFields(
      Map<ParameterElement, List<ElementAnnotation>> parameters,
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
        p.add(Parameter(
            v,
            DataType(t),
            e.type.nullabilitySuffix == NullabilitySuffix.question,
            e.isRequiredNamed,
            annotation: ParameterAnnotation.styleParameter));
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
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    var classImpl = element as ClassElement;
    var constructorImpl = element.children[0] as ConstructorElement;

    var result = '';

    var targetType = DataType(classImpl.name);
    var mixinType = DataType('_\$${classImpl.name}');
    var decorationType = DataType('${classImpl.name}Decoration');
    var implementationType = DataType('_${classImpl.name}');
    var extensionType = DataType('${classImpl.name}Extension');

    var lerpGenerator = LerpGenerator();
    var parameters =
        parseFields(inspectConstructor(constructorImpl), lerpGenerator);

    var annotationType = annotation.objectValue
        .getField('type')!
        .getField('_name')!
        .toStringValue();
    var extensionGetterName =
        annotation.objectValue.getField('extensionGetterName')!.toStringValue();

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

    return result;
  }
}
