import 'package:gherkin/gherkin.dart';
import 'package:test/test.dart';

class TestableTestRunSummaryReporter extends TestRunSummaryReporter {
  final output = <String>[];
  @override
  void printMessageLine(
    String message, [
    String? colour,
  ]) {
    output.add(message);
  }
}

void main() {
  group('report', () {
    test('provides correct output', () async {
      final reporter = TestableTestRunSummaryReporter();

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: '',
          context: RunnableDebugInformation.empty(),
          result: StepResult(0, StepExecutionResult.passed),
        ),
      );
      await reporter.step.onFinished.invoke(
        StepMessage(
          name: '',
          context: RunnableDebugInformation.empty(),
          result: StepResult(0, StepExecutionResult.fail),
        ),
      );
      await reporter.step.onFinished.invoke(
        StepMessage(
          name: '',
          context: RunnableDebugInformation.empty(),
          result: StepResult(0, StepExecutionResult.skipped),
        ),
      );
      await reporter.step.onFinished.invoke(
        StepMessage(
          name: '',
          context: RunnableDebugInformation.empty(),
          result: StepResult(0, StepExecutionResult.skipped),
        ),
      );
      await reporter.step.onFinished.invoke(
        StepMessage(
          name: '',
          context: RunnableDebugInformation.empty(),
          result: StepResult(0, StepExecutionResult.passed),
        ),
      );
      await reporter.step.onFinished.invoke(
        StepMessage(
          name: '',
          context: RunnableDebugInformation.empty(),
          result: StepResult(0, StepExecutionResult.error),
        ),
      );
      await reporter.step.onFinished.invoke(
        StepMessage(
          name: '',
          context: RunnableDebugInformation.empty(),
          result: StepResult(0, StepExecutionResult.passed),
        ),
      );
      await reporter.step.onFinished.invoke(
        StepMessage(
          name: '',
          context: RunnableDebugInformation.empty(),
          result: StepResult(0, StepExecutionResult.timeout),
        ),
      );

      await reporter.scenario.onFinished.invoke(
        ScenarioMessage(
          name: '',
          context: RunnableDebugInformation.empty(),
          hasPassed: true,
        ),
      );
      await reporter.scenario.onFinished.invoke(
        ScenarioMessage(
          name: '',
          context: RunnableDebugInformation.empty(),
          hasPassed: false,
        ),
      );
      await reporter.scenario.onFinished.invoke(
        ScenarioMessage(
          name: '',
          context: RunnableDebugInformation.empty(),
          hasPassed: false,
        ),
      );
      await reporter.scenario.onFinished.invoke(
        ScenarioMessage(
          name: '',
          context: RunnableDebugInformation.empty(),
          hasPassed: true,
        ),
      );

      await reporter.test.onFinished.invoke();
      expect(reporter.output, [
        '4 scenarios (\x1B[33;32m2 passed\x1B[33;0m, \x1B[33;31m2 failed\x1B[33;0m)',
        '8 steps (\x1B[33;32m3 passed\x1B[33;0m, \x1B[33;10m2 skipped\x1B[33;0m, \x1B[33;31m3 failed\x1B[33;0m)',
        '0:00:00.000000'
      ]);
    });
  });
}
