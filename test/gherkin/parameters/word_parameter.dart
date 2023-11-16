import 'package:gherkin/src/gherkin/parameters/string_parameter.dart';
import 'package:test/test.dart';

void main() {
  group('WordParameter', () {
    test('{word} parsed correctly', () async {
      final parameter = StringParameterLower();
      expect(await parameter.transformer('Jon'), equals('Jon'));
    });

    test('{Word} parsed correctly', () async {
      final parameter = StringParameterCamel();
      expect(await parameter.transformer('Jon'), equals('Jon'));
    });
  });
}
