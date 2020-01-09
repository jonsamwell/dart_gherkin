import 'gherkin_exception.dart';

class GherkinSyntaxException implements GherkinException {
  final String message;

  GherkinSyntaxException(this.message);
}
