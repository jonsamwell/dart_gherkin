import 'package:gherkin/src/gherkin/parameters/string_parameter.dart';
import 'package:test/test.dart';

void main() {
  group('StringParameter', () {
    test('{string} parsed correctly', () async {
      final parameter = StringParameterLower();
      expect(await parameter.transformer('Jon Samwell'), equals('Jon Samwell'));
    });

    test('{String} parsed correctly', () async {
      final parameter = StringParameterCamel();
      expect(await parameter.transformer('Jon Samwell'), equals('Jon Samwell'));
    });

    test('{String} pattern matches correctly', () {
      final parameter = StringParameterCamel();
      expect(parameter.pattern.hasMatch("'Jon'"), equals(true));
    });

    test('{String} pattern matches correctly with multiple words', () {
      final parameter = StringParameterCamel();
      expect(
        parameter.pattern.hasMatch("'Jon Samwell is a devloper'"),
        equals(true),
      );
    });

    test('{String} pattern matches correctly with new line within string', () {
      final parameter = StringParameterCamel();
      expect(
        parameter.pattern.hasMatch("'Jon Samwell is a \n devloper'"),
        equals(true),
      );
    });

    test('{String} pattern matches correctly with non alpha characters', () {
      final parameter = StringParameterCamel();
      expect(
        parameter.pattern.hasMatch(
          "'Jon Samwell is a devloper 123 '!@%^&*()_=+#:';{}'",
        ),
        equals(true),
      );
    });

    test('{String} parsed correctly with newline character in it', () {
      final parameter = StringParameterCamel();
      expect(parameter.pattern.hasMatch("'Jon \n Sam   well'"), equals(true));
    });
  });
}
