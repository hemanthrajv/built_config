# Built Config

Type safe configuration generator for flutter

## Usage

```dart
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
abstract class DefaultConfigValues implements BuiltConfig {
  factory DefaultConfigValues() = _$DefaultConfigValues;

  DefaultConfigValues._();

  //_______________________________
  // Use these methods to override any default values
  // You can use values from remote config like
  // bool getBool(String key) => _remoteConfig.getBool(key); 
  @override
  bool getBool(String key) => null;

  @override
  double getDouble(String key) => null;

  @override
  int getInt(String key) => null;

  @override
  String getString(String key) => null;
  //_______________________________

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
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
