import 'gherkin_exception.dart';

class GherkinStepNotDefinedException implements GherkinException {
  final String? message;

  GherkinStepNotDefinedException(this.message);

  @override
  String toString() {
    if (message == null) {
      return 'GherkinStepNotDefinedException';
    }

    return 'GherkinStepNotDefinedException: $message';
  }
}
