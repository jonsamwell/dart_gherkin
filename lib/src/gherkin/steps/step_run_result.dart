enum StepExecutionResult { passed, fail, skipped, timeout, error }

class StepResult {
  /// The duration in milliseconds the step took to run
  final int elapsedMilliseconds;

  /// The result of executing the step
  final StepExecutionResult result;

  // A reason for the result
  // This would be a failure message if the result failed.
  final String? resultReason;

  StepResult(
    this.elapsedMilliseconds,
    this.result, [
    this.resultReason,
  ]);
}

class ErroredStepResult extends StepResult {
  final Object exception;
  final StackTrace stackTrace;

  @override
  final String? resultReason;

  ErroredStepResult(int elapsedMilliseconds, StepExecutionResult result,
      this.exception, this.stackTrace,
      [this.resultReason])
      : super(elapsedMilliseconds, result);
}
