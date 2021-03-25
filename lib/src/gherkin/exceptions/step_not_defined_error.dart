import 'gherkin_exception.dart';

class GherkinStepNotDefinedException implements GherkinException {
  final String message;

  GherkinStepNotDefinedException(this.message);

  @override
  String toString() {
    return 'GherkinStepNotDefinedException: $message';
  }
}
