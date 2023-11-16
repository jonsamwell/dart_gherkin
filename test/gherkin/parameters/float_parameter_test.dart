import 'package:gherkin/src/gherkin/parameters/float_parameter.dart';
import 'package:test/test.dart';

void main() {
  group('FloatParameter', () {
    test('{float} parsed correctly', () async {
      final parameter = FloatParameterLower();
      expect(await parameter.transformer('12.243'), equals(12.243));
    });

    test('{Float} parsed correctly', () async  {
      final parameter = FloatParameterCamel();
      expect(await parameter.transformer('12.243'), equals(12.243));
    });

    test('{num} parsed correctly', () async {
      final parameter = NumParameterLower();
      expect(await parameter.transformer('12.243'), equals(12.243));
      expect(await parameter.transformer('3'), equals(3));
      expect(await parameter.transformer('-1.321'), equals(-1.321));
    });

    test('{Num} parsed correctly', () async  {
      final parameter = NumParameterCamel();
      expect(await parameter.transformer('12.243'), equals(12.243));
      expect(await parameter.transformer('3'), equals(3));
    });

    test('{Num} pattern matches correctly', () async {
      final parameter = NumParameterCamel();
      expect(parameter.pattern.hasMatch('12'), true);
      expect(parameter.pattern.hasMatch('-12'), true);
      expect(parameter.pattern.hasMatch('12.0'), true);
      expect(parameter.pattern.hasMatch('-12.0'), true);
      expect(parameter.pattern.hasMatch('12.00'), true);
      expect(parameter.pattern.hasMatch('12.000'), true);
      expect(parameter.pattern.hasMatch('12.000000'), true);
      expect(parameter.pattern.hasMatch('-12.000000'), true);
    });
  });
}
