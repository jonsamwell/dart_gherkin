class RunnableDebugInformation {
  final String? filePath;
  final int lineNumber;
  final String? lineText;

  int get nonZeroAdjustedLineNumber => lineNumber + 1;

  RunnableDebugInformation(this.filePath, this.lineNumber, this.lineText);

  RunnableDebugInformation copyWith(int lineNumber, String? line) {
    return RunnableDebugInformation(filePath, lineNumber, line);
  }
}
