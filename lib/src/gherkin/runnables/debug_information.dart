class RunnableDebugInformation {
  final String filePath;
  final int lineNumber;
  final String lineText;

  RunnableDebugInformation(this.filePath, this.lineNumber, this.lineText);

  RunnableDebugInformation.empty()
      : filePath = '',
        lineNumber = 0,
        lineText = '';

  int get nonZeroAdjustedLineNumber => lineNumber + 1;

  RunnableDebugInformation copyWith({
    String? filePath,
    int? lineNumber,
    String? lineText,
  }) {
    return RunnableDebugInformation(
      filePath ?? this.filePath,
      lineNumber ?? this.lineNumber,
      lineText ?? this.lineText,
    );
  }
}
