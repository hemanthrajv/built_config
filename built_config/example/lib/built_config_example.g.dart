// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'built_config_example.dart';

// **************************************************************************
// BuiltConfigGenerator
// **************************************************************************

class _$ProdConfigValues extends ProdConfigValues {
  factory _$ProdConfigValues() => _$ProdConfigValues._();

  _$ProdConfigValues._() : super._();

  final Map<String, dynamic> _defaultRemoteValues = <String, dynamic>{
    'myInt': 4,
    'sampleString': 'myString',
    'sampleBool': true,
    'doubleValue': 1.1123
  };

  @override
  int get sampleInt => getInt('myInt') ?? _defaultRemoteValues['myInt'];

  @override
  String get sampleString =>
      getString('sampleString') ?? _defaultRemoteValues['sampleString'];

  @override
  bool get sampleBool =>
      getBool('sampleBool') ?? _defaultRemoteValues['sampleBool'];

  @override
  double get sampleDouble =>
      getDouble('doubleValue') ?? _defaultRemoteValues['doubleValue'];

  @override
  Map<String, dynamic> toDefaultJson() => _defaultRemoteValues;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'myInt': sampleInt,
      'sampleString': sampleString,
      'sampleBool': sampleBool,
      'doubleValue': sampleDouble
    };
  }
}

/*

*/

class _$DefaultConfigValues extends DefaultConfigValues {
  factory _$DefaultConfigValues() => _$DefaultConfigValues._();

  _$DefaultConfigValues._() : super._();

  final Map<String, dynamic> _defaultRemoteValues = <String, dynamic>{
    'myInt': 1,
    'sampleString': 'myString',
    'sampleBool': true,
    'doubleValue': 1.1123
  };

  @override
  int get sampleInt => getInt('myInt') ?? _defaultRemoteValues['myInt'];

  @override
  String get sampleString =>
      getString('sampleString') ?? _defaultRemoteValues['sampleString'];

  @override
  bool get sampleBool =>
      getBool('sampleBool') ?? _defaultRemoteValues['sampleBool'];

  @override
  double get sampleDouble =>
      getDouble('doubleValue') ?? _defaultRemoteValues['doubleValue'];

  @override
  Map<String, dynamic> toDefaultJson() => _defaultRemoteValues;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'myInt': sampleInt,
      'sampleString': sampleString,
      'sampleBool': sampleBool,
      'doubleValue': sampleDouble
    };
  }
}

/*

*/
