import 'package:gherkin/gherkin.dart';

class ProgressReporter extends StdoutReporter
    implements ScenarioReporter, StepReporter {
  @override
  ReporterMap<StartedCallback, ScenarioFinishedCallback> get onScenario =>
      ReporterMap(
        onStarted: (message) async => printMessageLine(
          'Running scenario: ${_getNameAndContext(message.name, message.context)}',
          StdoutReporter.kWarnColor,
        ),
        onFinished: (message) async => printMessageLine(
          "${message.passed ? 'PASSED' : 'FAILED'}: Scenario ${_getNameAndContext(message.name, message.context)}",
          message.passed
              ? StdoutReporter.kPassColor
              : StdoutReporter.kFailColor,
        ),
      );

  @override
  // TODO: implement onStep
  ReporterMap<StepStartedCallback, StepFinishedCallback> get onStep =>
      ReporterMap(
        onFinished: (message) async {
          printMessageLine(
            [
              '  ',
              _getStatePrefixIcon(message.result.result),
              _getNameAndContext(message.name, message.context),
              _getExecutionDuration(message.result),
              _getReasonMessage(message.result),
              _getErrorMessage(message.result)
            ].join(' ').trimRight(),
            _getMessageColour(message.result.result),
          );

          if (message.attachments.isNotEmpty) {
            message.attachments.forEach(
              (attachment) {
                final attachment2 = attachment;
                printMessageLine(
                  [
                    '    ',
                    'Attachment',
                    "(${attachment2.mimeType})${attachment.mimeType == 'text/plain' ? ': ${attachment.data}' : ''}"
                  ].join(' ').trimRight(),
                  StdoutReporter.kResetColor,
                );
              },
            );
          }
        },
      );

  @override
  Future<void> message(String message, MessageLevel level) async {
    // ignore messages
  }

  String _getReasonMessage(StepResult stepResult) {
    if (stepResult.resultReason != null &&
        stepResult.resultReason!.isNotEmpty) {
      return '\n      ${stepResult.resultReason}';
    } else {
      return '';
    }
  }

  String _getErrorMessage(StepResult stepResult) {
    if (stepResult is ErroredStepResult) {
      return '\n${stepResult.exception}\n${stepResult.stackTrace}';
    } else {
      return '';
    }
  }

  String _getNameAndContext(String name, RunnableDebugInformation context) {
    return "$name # ${context.filePath.replaceAll(RegExp(r"\.\\"), "")}:${context.lineNumber}";
  }

  String _getExecutionDuration(StepResult stepResult) {
    return 'took ${stepResult.elapsedMilliseconds}ms';
  }

  String _getStatePrefixIcon(StepExecutionResult result) {
    switch (result) {
      case StepExecutionResult.passed:
        return '√';
      case StepExecutionResult.error:
      case StepExecutionResult.fail:
      case StepExecutionResult.timeout:
        return '×';
      case StepExecutionResult.skipped:
        return '-';
    }
  }

  String _getMessageColour(StepExecutionResult result) {
    switch (result) {
      case StepExecutionResult.passed:
        return StdoutReporter.kPassColor;
      case StepExecutionResult.fail:
        return StdoutReporter.kFailColor;
      case StepExecutionResult.error:
        return StdoutReporter.kFailColor;
      case StepExecutionResult.skipped:
        return StdoutReporter.kWarnColor;
      case StepExecutionResult.timeout:
        return StdoutReporter.kFailColor;
      default:
        return StdoutReporter.kResetColor;
    }
  }
}
