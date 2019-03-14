import 'package:gherkin/src/gherkin/parameters/float_parameter.dart';
import 'package:test/test.dart';

void main() {
  group("FloatParameter", () {
    test("{float} parsed correctly", () {
      final parameter = FloatParameterLower();
      expect(parameter.transformer("12.243"), equals(12.243));
    });

    test("{Float} parsed correctly", () {
      final parameter = FloatParameterCamel();
      expect(parameter.transformer("12.243"), equals(12.243));
    });

    test("{num} parsed correctly", () {
      final parameter = NumParameterLower();
      expect(parameter.transformer("12.243"), equals(12.243));
      expect(parameter.transformer("3"), equals(3));
    });

    test("{Num} parsed correctly", () {
      final parameter = NumParameterCamel();
      expect(parameter.transformer("12.243"), equals(12.243));
      expect(parameter.transformer("3"), equals(3));
    });

    test("{Num} pattern matches correctly", () {
      final parameter = NumParameterCamel();
      expect(parameter.pattern.hasMatch("12"), true);
      expect(parameter.pattern.hasMatch("12.0"), true);
      expect(parameter.pattern.hasMatch("12.00"), true);
      expect(parameter.pattern.hasMatch("12.000"), true);
      expect(parameter.pattern.hasMatch("12.000000"), true);
      expect(parameter.pattern.hasMatch("12.0000.00"), false);
    });
  });
}
