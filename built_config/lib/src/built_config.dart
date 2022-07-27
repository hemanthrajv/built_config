class BuiltConfigField {
  const BuiltConfigField({
    this.wireName,
    this.defaultValue,
    this.allValues = const [],
    this.description,
  });

  final String? wireName;
  final dynamic defaultValue;
  final List allValues;
  final String? description;
}

class BuiltConfigOptions {
  const BuiltConfigOptions({
    this.outputJson = false,
    this.jsonFileName,
  });

  final bool outputJson;
  final String? jsonFileName;
}

abstract class BuiltConfig {
  bool? getBool(String key);

  String? getString(String key);

  int? getInt(String key);

  double? getDouble(String key);

  Map<String, dynamic> toJson();

  Map<String, dynamic> toDefaultJson();
}
