import 'package:built_config/built_config.dart';

part 'built_config_example.g.dart';

class Environment {
  final DefaultConfigValues _defaultConfigValues = DefaultConfigValues();
  final ProdConfigValues _prodConfigValues = ProdConfigValues();
}

// override Default Values for you Production Flavor
abstract class ProdConfigValues extends DefaultConfigValues
    implements BuiltConfig {
  factory ProdConfigValues() = _$ProdConfigValues;

  ProdConfigValues._() : super._();

  @override
  @BuiltConfigField(
    defaultValue: 4,
    allValues: [4, 5],
    wireName: 'myInt',
  )
  int get sampleInt;
}

// DefaultConfigValues
@BuiltConfigOptions(outputJson: true, jsonFileName: 'default')
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
    wireName: 'myInt',
  )
  int get sampleInt;

  @BuiltConfigField(defaultValue: 'myString')
  String get sampleString;

  @BuiltConfigField(defaultValue: true)
  bool get sampleBool;

  @BuiltConfigField(defaultValue: 1.1123, wireName: 'doubleValue')
  double get sampleDouble;

  String get otherField {
    return 'SomeValue';
  }
}
