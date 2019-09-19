class GherkinDialogNotSupportedException implements Exception {
  final String dialect;

  GherkinDialogNotSupportedException(this.dialect);

  String toString() {
    if (dialect == null) return "GherkinDialogNotSupportedException";
    return "GherkinDialogNotSupportedException: Dialect is not supported '$dialect'";
  }
}
