import '../../gherkin.dart';

class TestRunSummaryReporter extends StdoutReporter
    implements
        ScenarioReporter,
        StepReporter,
        TestReporter,
        DisposableReporter {
  final _timer = Stopwatch();
  final List<StepMessage> _ranSteps = [];
  final List<ScenarioMessage> _ranScenarios = [];

  @override
  ReportActionHandler<TestMessage> get test => ReportActionHandler(
        onStarted: ([message]) async => _timer.start(),
        onFinished: ([message]) async {
          _timer.stop();
          printMessageLine(
            "${_ranScenarios.length} scenario${_ranScenarios.length > 1 ? "s" : ""} "
            "(${_collectScenarioSummary(_ranScenarios)})",
          );
          printMessageLine(
            "${_ranSteps.length} step${_ranSteps.length > 1 ? "s" : ""} "
            "(${_collectStepSummary(_ranSteps)})",
          );
          printMessageLine(
            '${Duration(milliseconds: _timer.elapsedMilliseconds)}',
          );
        },
      );

  @override
  ReportActionHandler<ScenarioMessage> get scenario => ReportActionHandler(
        onFinished: ([message]) async {
          if (message == null) {
            return;
          }
          _ranScenarios.add(message);
        },
      );

  @override
  ReportActionHandler<StepMessage> get step => ReportActionHandler(
        onFinished: ([message]) async {
          if (message == null) {
            return;
          }
          _ranSteps.add(message);
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

  String _collectScenarioSummary(Iterable<ScenarioMessage> scenarios) {
    final summaries = <String>[];
    final passedScenarios = scenarios.where((s) => s.hasPassed);
    final failedScenarios = scenarios.where((s) => !s.hasPassed);
    if (passedScenarios.isNotEmpty) {
      summaries.add(
        '${StdoutReporter.kPassColor}${passedScenarios.length} passed'
        '${StdoutReporter.kResetColor}',
      );
    }

    if (failedScenarios.isNotEmpty) {
      summaries.add(
        '${StdoutReporter.kFailColor}${failedScenarios.length} failed'
        '${StdoutReporter.kResetColor}',
      );
    }

    return summaries.join(', ');
  }

  String _collectStepSummary(Iterable<StepMessage> steps) {
    final summaries = <String>[];
    final passed =
        steps.where((s) => s.result!.result == StepExecutionResult.passed);
    final skipped =
        steps.where((s) => s.result!.result == StepExecutionResult.skipped);
    final failed = steps.where(
      (s) =>
          s.result!.result == StepExecutionResult.error ||
          s.result!.result == StepExecutionResult.fail ||
          s.result!.result == StepExecutionResult.timeout,
    );
    if (passed.isNotEmpty) {
      summaries.add(
        '${StdoutReporter.kPassColor}${passed.length} passed'
        '${StdoutReporter.kResetColor}',
      );
    }

    if (skipped.isNotEmpty) {
      summaries.add(
        '${StdoutReporter.kWarnColor}${skipped.length} skipped'
        '${StdoutReporter.kResetColor}',
      );
    }

    if (failed.isNotEmpty) {
      summaries.add(
        '${StdoutReporter.kFailColor}${failed.length} failed'
        '${StdoutReporter.kResetColor}',
      );
    }

    return summaries.join(', ');
  }
}
