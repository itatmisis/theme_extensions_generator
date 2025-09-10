import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/theme_extension_generator.dart';

/// Entrypoint for build_runner to wire ThemeExtensions generator.
///
/// See README for how to configure build.yaml and run the generator.
Builder themeExtension(BuilderOptions options) =>
    SharedPartBuilder([ThemeExtensionGenerator()], 'theme_extension');
