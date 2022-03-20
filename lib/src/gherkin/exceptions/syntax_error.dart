import 'package:gherkin/src/gherkin/exceptions/gherkin_exception.dart';

class GherkinSyntaxException implements GherkinException {
  final String message;

  GherkinSyntaxException(this.message);
}
