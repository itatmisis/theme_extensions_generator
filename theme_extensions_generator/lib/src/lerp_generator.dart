import 'constants.dart';
import 'models.dart';

enum TransformState {
  tween, lerp;
}

class LerpGeneratorResult {
  const LerpGeneratorResult();
}

class LerpGeneratorResultNone extends LerpGeneratorResult {
  const LerpGeneratorResultNone();
}

class LerpGeneratorResultFound extends LerpGeneratorResult {
  final TransformState state;
  final DataType namespaceType;

  const LerpGeneratorResultFound(this.state, this.namespaceType);
}


class TransformModel {
  final DataType targetType;
  final DataType namespaceType;

  const TransformModel(this.targetType): namespaceType = targetType;
  const TransformModel.withNamespace(this.targetType, this.namespaceType);

  @override
  String toString() {
    return 'LerpModel($targetType, $namespaceType)';
  }

  @override
  // TODO: implement hashCode
  int get hashCode => targetType.hashCode;

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return hashCode == other.hashCode;
  }

}

extension _ on List<String> {
  Iterable<TransformModel> toLerpModels() {
    return expand<TransformModel>((element) => [TransformModel(DataType(element))]);
  }
}

class LerpGenerator {
  static final List<TransformModel> _initialTweenDataTypeNames = [...Constants.typeNamesTween.toLerpModels()];
  static final List<TransformModel> _initialLerpDataTypeNames = [...Constants.typeNamesLerp.toLerpModels()];

  final List<TransformModel> _tweenDataTypeNames = [..._initialTweenDataTypeNames];
  final List<TransformModel> _lerpDataTypeNames = [..._initialLerpDataTypeNames];

  void addTweenTypename(TransformModel model) {
    _tweenDataTypeNames.add(model);
  }

  void addLerpTypename(TransformModel model) {
    _lerpDataTypeNames.add(model);
  }

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
