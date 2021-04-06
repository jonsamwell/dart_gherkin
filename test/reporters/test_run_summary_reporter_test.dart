import 'package:gherkin/gherkin.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/steps/step_run_result.dart';
import 'package:test/test.dart';

class TestableTestRunSummaryReporter extends TestRunSummaryReporter {
  final output = <String>[];
  @override
  void printMessageLine(String message, [String? colour]) {
    output.add(message);
  }
}

void main() {
  group('report', () {
    test('provides correct output', () async {
      final reporter = TestableTestRunSummaryReporter();
      final debugStub = RunnableDebugInformation('', 0, null);

      await reporter.onStepFinished(StepFinishedMessage(
          '', debugStub, StepResult(0, StepExecutionResult.pass)));
      await reporter.onStepFinished(StepFinishedMessage(
          '', debugStub, StepResult(0, StepExecutionResult.fail)));
      await reporter.onStepFinished(StepFinishedMessage(
          '', debugStub, StepResult(0, StepExecutionResult.skipped)));
      await reporter.onStepFinished(StepFinishedMessage(
          '', debugStub, StepResult(0, StepExecutionResult.skipped)));
      await reporter.onStepFinished(StepFinishedMessage(
          '', debugStub, StepResult(0, StepExecutionResult.pass)));
      await reporter.onStepFinished(StepFinishedMessage(
          '', debugStub, StepResult(0, StepExecutionResult.error)));
      await reporter.onStepFinished(StepFinishedMessage(
          '', debugStub, StepResult(0, StepExecutionResult.pass)));
      await reporter.onStepFinished(StepFinishedMessage(
          '', debugStub, StepResult(0, StepExecutionResult.timeout)));

      await reporter
          .onScenarioFinished(ScenarioFinishedMessage('', debugStub, true));
      await reporter
          .onScenarioFinished(ScenarioFinishedMessage('', debugStub, false));
      await reporter
          .onScenarioFinished(ScenarioFinishedMessage('', debugStub, false));
      await reporter
          .onScenarioFinished(ScenarioFinishedMessage('', debugStub, true));

      await reporter.onTestRunFinished();
      expect(reporter.output, [
        '4 scenarios (\x1B[33;32m2 passed\x1B[33;0m, \x1B[33;31m2 failed\x1B[33;0m)',
        '8 steps (\x1B[33;32m3 passed\x1B[33;0m, \x1B[33;10m2 skipped\x1B[33;0m, \x1B[33;31m3 failed\x1B[33;0m)',
        '0:00:00.000000'
      ]);
    });
  });
}
