import 'constants.dart';
import 'models.dart';

/// Describes how a value should be interpolated.
enum TransformState { tween, lerp }

/// Base type for `LerpGenerator.transformFunction` results.
class LerpGeneratorResult { const LerpGeneratorResult(); }

/// A marker result meaning no transform rule was found.
class LerpGeneratorResultNone extends LerpGeneratorResult { const LerpGeneratorResultNone(); }

/// A successful transform rule with [state] and [namespaceType].
class LerpGeneratorResultFound extends LerpGeneratorResult {
  /// Whether to use tween or lerp strategy.
  final TransformState state;
  /// Type that owns lerp/tween implementation (may differ from target type).
  final DataType namespaceType;

  const LerpGeneratorResultFound(this.state, this.namespaceType);
}


/// Describes mapping for a type to a lerp/tween namespace.
class TransformModel {
  /// Type to be transformed.
  final DataType targetType;
  /// Type that provides the lerp/tween static method.
  final DataType namespaceType;

  const TransformModel(this.targetType): namespaceType = targetType;
  const TransformModel.withNamespace(this.targetType, this.namespaceType);

  @override
  String toString() {
    return 'LerpModel($targetType, $namespaceType)';
  }

  @override
  int get hashCode => targetType.hashCode;

  @override
  bool operator ==(Object other) => other is TransformModel && other.targetType == targetType;

}

extension _ on List<String> {
  Iterable<TransformModel> toLerpModels() {
    return expand<TransformModel>((element) => [TransformModel(DataType(element))]);
  }
}

/// Holds interpolation rules and resolves how to transform a type.
class LerpGenerator {
  static final List<TransformModel> _initialTweenDataTypeNames = [...Constants.typeNamesTween.toLerpModels()];
  static final List<TransformModel> _initialLerpDataTypeNames = [...Constants.typeNamesLerp.toLerpModels()];

  final List<TransformModel> _tweenDataTypeNames = [..._initialTweenDataTypeNames];
  final List<TransformModel> _lerpDataTypeNames = [..._initialLerpDataTypeNames];

  /// Registers an additional tween rule.
  void addTweenTypename(TransformModel model) { _tweenDataTypeNames.add(model); }

  /// Registers an additional lerp rule.
  void addLerpTypename(TransformModel model) { _lerpDataTypeNames.add(model); }

  /// Returns a rule describing how to transform [type].
  LerpGeneratorResult transformFunction(DataType type) {
    for (var t in _tweenDataTypeNames) {
      if (type == t.targetType) {
        return LerpGeneratorResultFound(TransformState.tween, t.namespaceType);
      }
    }

    for (var t in _lerpDataTypeNames) {
      if (type == t.targetType) {
        return LerpGeneratorResultFound(TransformState.lerp, t.namespaceType);
      }
    }

    return LerpGeneratorResultNone();
  }
}
