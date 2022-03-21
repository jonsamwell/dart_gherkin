import '../../gherkin.dart';

class TestRunSummaryReporter extends StdoutReporter
    implements ScenarioReporter, StepReporter, TestReporter, DisposableRepoter {
  final _timer = Stopwatch();
  final List<StepFinishedMessage> _ranSteps = <StepFinishedMessage>[];
  final List<ScenarioFinishedMessage> _ranScenarios =
      <ScenarioFinishedMessage>[];

  @override
  ReportActionHandler<StartedMessage, ScenarioFinishedMessage> get scenario =>
      ReportActionHandler(
        onFinished: ([message]) async {
          if (message == null) {
            return;
          }
          _ranScenarios.add(message);
        },
      );

  @override
  ReportActionHandler<StepStartedMessage, StepFinishedMessage> get step =>
      ReportActionHandler(
        onFinished: ([message]) async {
          if (message == null) {
            return;
          }
          _ranSteps.add(message);
        },
      );

  @override
  ReportActionHandler<void, void> get test => ReportActionHandler(
        onStarted: ([message]) async => _timer.start(),
        onFinished: ([message]) async {
          _timer.stop();
          printMessageLine(
            "${_ranScenarios.length} scenario${_ranScenarios.length > 1 ? "s" : ""} (${_collectScenarioSummary(_ranScenarios)})",
          );
          printMessageLine(
            "${_ranSteps.length} step${_ranSteps.length > 1 ? "s" : ""} (${_collectStepSummary(_ranSteps)})",
          );
          printMessageLine(
            '${Duration(milliseconds: _timer.elapsedMilliseconds)}',
          );
        },
      );

  @override
  Future<void> message(String message, MessageLevel level) async {
    // ignore messages
  }

  @override
  Future<void> dispose() async {
    if (_timer.isRunning) {
      _timer.stop();
    }
  }

  String _collectScenarioSummary(Iterable<ScenarioFinishedMessage> scenarios) {
    final summaries = <String>[];
    if (scenarios.any((s) => s.passed)) {
      summaries.add(
        '${StdoutReporter.kPassColor}${scenarios.where((s) => s.passed).length} passed${StdoutReporter.kResetColor}',
      );
    }

    if (scenarios.any((s) => !s.passed)) {
      summaries.add(
        '${StdoutReporter.kFailColor}${scenarios.where((s) => !s.passed).length} failed${StdoutReporter.kResetColor}',
      );
    }

    return summaries.join(', ');
  }

  String _collectStepSummary(Iterable<StepFinishedMessage> steps) {
    final summaries = <String>[];
    final passed =
        steps.where((s) => s.result.result == StepExecutionResult.passed);
    final skipped =
        steps.where((s) => s.result.result == StepExecutionResult.skipped);
    final failed = steps.where(
      (s) =>
          s.result.result == StepExecutionResult.error ||
          s.result.result == StepExecutionResult.fail ||
          s.result.result == StepExecutionResult.timeout,
    );
    if (passed.isNotEmpty) {
      summaries.add(
        '${StdoutReporter.kPassColor}${passed.length} passed${StdoutReporter.kResetColor}',
      );
    }

    if (skipped.isNotEmpty) {
      summaries.add(
        '${StdoutReporter.kWarnColor}${skipped.length} skipped${StdoutReporter.kResetColor}',
      );
    }

    if (failed.isNotEmpty) {
      summaries.add(
        '${StdoutReporter.kFailColor}${failed.length} failed${StdoutReporter.kResetColor}',
      );
    }

    return summaries.join(', ');
  }
}
