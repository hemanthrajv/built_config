import 'package:built_config/built_config.dart';

part 'built_config_example.g.dart';

class Environment {
  final DefaultConfigValues _configValues = ProdConfigValues();
}

abstract class ProdConfigValues extends DefaultConfigValues
    implements BuiltConfig {
  factory ProdConfigValues() = _$ProdConfigValues;

  ProdConfigValues._() : super._();

  @override
  @BuiltConfigField(
    defaultValue: 4,
    allValues: [4, 5],
    wireName: 'myCustomVersion',
  )
  int get version;
}

abstract class DefaultConfigValues implements BuiltConfig {
  factory DefaultConfigValues() = _$DefaultConfigValues;

  DefaultConfigValues._();

  Future<void> initialize() async {}

  Future<void> dispose() async {}

  @override
  bool getBool(String key) => null;

  @override
  double getDouble(String key) => null;

  @override
  int getInt(String key) => null;

  @override
  String getString(String key) => null;

  @BuiltConfigField(
    defaultValue: 1,
    allValues: [1, 2],
    wireName: 'myCustomVersion',
  )
  int get version;

  @BuiltConfigField(defaultValue: 2, allValues: [1, 2])
  int get version2;

  @BuiltConfigField(defaultValue: 'hello123')
  String get hello;

  @BuiltConfigField(defaultValue: true)
  bool get boolTest;

  @BuiltConfigField(defaultValue: 1.1123, wireName: 'doubleValue')
  double get doubleVal;

  String get name2 {
    return '';
  }
}
