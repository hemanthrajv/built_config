class BuiltConfigField {
  const BuiltConfigField({
    this.wireName,
    this.defaultValue,
    this.allValues = const [],
    this.description,
  }) : assert(allValues != null);

  final String wireName;
  final defaultValue;
  final List allValues;
  final String description;
}

abstract class BuiltConfig {
  bool getBool(String key);

  String getString(String key);

  int getInt(String key);

  double getDouble(String key);

  Map<String, dynamic> toJson();

  Map<String, dynamic> toDefaultJson();
}
