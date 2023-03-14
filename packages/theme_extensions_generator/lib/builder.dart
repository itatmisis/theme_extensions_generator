import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/theme_extension_generator.dart';

Builder themeExtension(BuilderOptions options) =>
    SharedPartBuilder([ThemeExtensionGenerator()], 'theme_extension');