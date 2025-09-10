class DataType {
  final String name;

  const DataType(this.name);

  @override
  String toString() {
    return name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}

class Field {
  final DataType type;
  final String name;
  final bool nullable;

  const Field(this.name, this.type, this.nullable);
}

enum ParameterAnnotation {
  themeParameter,
  styleParameter,
  deepStyleParameter,
  none
}

class Parameter extends Field {
  final bool required;
  final bool allowLerp;
  final ParameterAnnotation annotation;

  const Parameter(super.name, super.type, super.nullable, this.required,
      {this.allowLerp = true, this.annotation = ParameterAnnotation.none});
}
