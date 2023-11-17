import 'package:gherkin/gherkin.dart';
import 'package:test/test.dart';

class TestableProgressReporter extends ProgressReporter {
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
    test('provides correct step finished output', () async {
      final reporter = TestableProgressReporter();

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filePath', 1, 'line 1'),
          result: StepResult(0, StepExecutionResult.passed),
          attachments: [Attachment('A string', 'text/plain')],
        ),
      );
      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 2',
          context: RunnableDebugInformation('filePath', 2, 'line 2'),
          result: StepResult(
            0,
            StepExecutionResult.fail,
            resultReason: 'Failed Reason',
          ),
        ),
      );
      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 3',
          context: RunnableDebugInformation('filePath', 3, 'line 3'),
          result: StepResult(0, StepExecutionResult.skipped),
        ),
      );
      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 4',
          context: RunnableDebugInformation('filePath', 4, 'line 4'),
          result: StepResult(0, StepExecutionResult.error),
        ),
      );
      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 5',
          context: RunnableDebugInformation('filePath', 5, 'line 5'),
          result: StepResult(1, StepExecutionResult.timeout),
        ),
      );

      expect(reporter.output, [
        '   √ Step 1 # filePath:1 took 0ms',
        '     Attachment (text/plain): A string',
        '   × Step 2 # filePath:2 took 0ms \n      Failed Reason',
        '   - Step 3 # filePath:3 took 0ms',
        '   × Step 4 # filePath:4 took 0ms',
        '   × Step 5 # filePath:5 took 1ms',
      ]);
    });

    test('provides correct scenario started output', () async {
      final reporter = TestableProgressReporter();

      await reporter.scenario.onStarted.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          context: RunnableDebugInformation('filePath', 1, 'line 1'),
        ),
      );

      expect(reporter.output, ['Running scenario: Scenario 1 # filePath:1']);
    });
  });
}
