import 'package:remote_config_data/built_config.dart';

part 'remote_config_data_example.g.dart';


abstract class RemoteConfigValues implements BuiltConfig {
  @BuiltConfigField(defaultValue: 1,allValues: [1,2])
  String get name;
}