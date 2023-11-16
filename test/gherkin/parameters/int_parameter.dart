import 'package:gherkin/src/gherkin/parameters/int_parameter.dart';
import 'package:test/test.dart';

void main() {
  group('IntParameter', () {
    test('{int} parsed correctly', () async {
      final parameter = IntParameterLower();
      expect(await parameter.transformer('12'), equals(12));
    });

    test('{Int} parsed correctly', () async {
      final parameter = IntParameterCamel();
      expect(await parameter.transformer('12'), equals(12));
    });
  });
}
