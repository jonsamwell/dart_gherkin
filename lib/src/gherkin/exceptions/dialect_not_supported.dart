import 'gherkin_exception.dart';

class GherkinDialogNotSupportedException implements GherkinException {
  final String? dialect;

  GherkinDialogNotSupportedException(this.dialect);

  @override
  String toString() {
    if (dialect == null) {
      return 'GherkinDialogNotSupportedException';
    }

    return "GherkinDialogNotSupportedException: Dialect is not supported '$dialect'";
  }
}
