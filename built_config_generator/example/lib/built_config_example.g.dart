// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'built_config_example.dart';

// **************************************************************************
// BuiltConfigGenerator
// **************************************************************************

class _$ProdConfigValues extends ProdConfigValues {
  factory _$ProdConfigValues() => _$ProdConfigValues._();

  _$ProdConfigValues._() : super._();

  final Map<String, dynamic> _defaultRemoteValues = <String, dynamic>{
    'myCustomVersion': 4,
    'version2': 2,
    'hello': 'hello123',
    'boolTest': true,
    'doubleValue': 1.1123
  };

  @override
  int get version =>
      getInt('myCustomVersion') ?? _defaultRemoteValues['myCustomVersion'];

  @override
  int get version2 => getInt('version2') ?? _defaultRemoteValues['version2'];

  @override
  String get hello => getString('hello') ?? _defaultRemoteValues['hello'];

  @override
  bool get boolTest => getBool('boolTest') ?? _defaultRemoteValues['boolTest'];

  @override
  double get doubleVal =>
      getDouble('doubleValue') ?? _defaultRemoteValues['doubleValue'];

  @override
  Map<String, dynamic> toDefaultJson() => _defaultRemoteValues;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'myCustomVersion': version,
      'version2': version2,
      'hello': hello,
      'boolTest': boolTest,
      'doubleValue': doubleVal
    };
  }
}

/*

*/

class _$DefaultConfigValues extends DefaultConfigValues {
  factory _$DefaultConfigValues() => _$DefaultConfigValues._();

  _$DefaultConfigValues._() : super._();

  final Map<String, dynamic> _defaultRemoteValues = <String, dynamic>{
    'myCustomVersion': 1,
    'version2': 2,
    'hello': 'hello123',
    'boolTest': true,
    'doubleValue': 1.1123
  };

  @override
  int get version =>
      getInt('myCustomVersion') ?? _defaultRemoteValues['myCustomVersion'];

  @override
  int get version2 => getInt('version2') ?? _defaultRemoteValues['version2'];

  @override
  String get hello => getString('hello') ?? _defaultRemoteValues['hello'];

  @override
  bool get boolTest => getBool('boolTest') ?? _defaultRemoteValues['boolTest'];

  @override
  double get doubleVal =>
      getDouble('doubleValue') ?? _defaultRemoteValues['doubleValue'];

  @override
  Map<String, dynamic> toDefaultJson() => _defaultRemoteValues;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'myCustomVersion': version,
      'version2': version2,
      'hello': hello,
      'boolTest': boolTest,
      'doubleValue': doubleVal
    };
  }
}

/*

*/
