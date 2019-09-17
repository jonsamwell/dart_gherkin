class GherkinStepNotDefinedException implements Exception {
  final String message;

  GherkinStepNotDefinedException(this.message);

  String toString() {
    if (message == null) return "GherkinStepNotDefinedException";
    return "GherkinStepNotDefinedException: $message";
  }
}
