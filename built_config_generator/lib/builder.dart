import 'package:build/build.dart';
import 'package:built_config_generator/built_config_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder builtConfigBuilder(BuilderOptions options) =>
    SharedPartBuilder([BuiltConfigGenerator()], 'built_config');
