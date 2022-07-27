import 'package:built_config/built_config.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    int? awesome;

    setUp(() {
      awesome = 1;
    });

    test('First Test', () {
      expect(awesome, 1);
    });
  });
}
