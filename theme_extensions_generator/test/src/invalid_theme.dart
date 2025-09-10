import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_annotation/theme_extension_annotation.dart';

part 'invalid_theme.g.dart';

@ShouldThrow('Unsupported type: NonLerpableType')
@ThemeExtended()
class InvalidTheme with _$InvalidTheme {
  const factory InvalidTheme({
    @ThemeProperty() required NonLerpableType invalidField,
  }) = _InvalidTheme;
}

class NonLerpableType {
  final String value;
  const NonLerpableType(this.value);
}
