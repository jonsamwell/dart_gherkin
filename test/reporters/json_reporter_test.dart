import 'dart:convert';
import 'dart:io';

import 'package:gherkin/gherkin.dart';
import 'package:test/test.dart';

class TestableJsonReporter extends JsonReporter {
  late final String report;

  @override
  Future<void> onSaveReport(String jsonReport, String path) async {
    report = jsonReport;

    return Future.value(null);
  }
}

String minimizeJson(String jsonReport) {
  return json.encode(json.decode(jsonReport));
}

void main() {
  group('report', () {
    test('correct report with one passing step', () async {
      final reporter = TestableJsonReporter();
      await reporter.onFeature.onStarted?.call(
        StartedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
          [Tag('tag1', 1)],
        ),
      );

      await reporter.onScenario.onStarted?.call(
        StartedMessage(
          Target.scenario,
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          [Tag('tag1', 1, isInherited: true), Tag('tag2', 3)],
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
          StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.onScenario.onFinished?.call(
        ScenarioFinishedMessage(
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          passed: true,
        ),
      );

      await reporter.onFeature.onFinished?.call(
        FinishedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.onTest.onFinished?.call();
      final expectedJson =
          File.fromUri(Uri.file('./test/reporters/json_reports/report_1.json'))
              .readAsStringSync();
      expect(
        reporter.report,
        minimizeJson(expectedJson),
      );
    });

    test('correct report with one passing step with doc string', () async {
      final reporter = TestableJsonReporter();
      await reporter.onFeature.onStarted?.call(
        StartedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
          [Tag('tag1', 1)],
        ),
      );

      await reporter.onScenario.onStarted?.call(
        StartedMessage(
          Target.scenario,
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          [Tag('tag1', 1, isInherited: true), Tag('tag2', 3)],
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
          multilineString: 'a\nb\nc',
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
          StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.onScenario.onFinished?.call(
        ScenarioFinishedMessage(
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          passed: true,
        ),
      );

      await reporter.onFeature.onFinished?.call(
        FinishedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.onTest.onFinished?.call();

      expect(
        reporter.report,
        minimizeJson(
          File.fromUri(Uri.file('./test/reporters/json_reports/report_5.json'))
              .readAsStringSync(),
        ),
      );
    });

    test('correct report with one passing and one failing step', () async {
      final reporter = TestableJsonReporter();
      await reporter.onFeature.onStarted?.call(
        StartedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
          [Tag('tag1', 1)],
        ),
      );

      await reporter.onScenario.onStarted?.call(
        StartedMessage(
          Target.scenario,
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          [
            Tag('tag1', 1, isInherited: true),
            Tag('tag2', 3, isInherited: false)
          ],
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
          StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 2',
          RunnableDebugInformation('filepath', 6, 'linetext6'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 2',
          RunnableDebugInformation('filepath', 6, 'linetext6'),
          StepResult(100, StepExecutionResult.fail, 'error message'),
        ),
      );

      await reporter.onScenario.onFinished?.call(
        ScenarioFinishedMessage(
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          passed: true,
        ),
      );

      await reporter.onFeature.onFinished?.call(
        FinishedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.onTest.onFinished?.call();

      expect(
        reporter.report,
        minimizeJson(
          File.fromUri(Uri.file('./test/reporters/json_reports/report_2.json'))
              .readAsStringSync(),
        ),
      );
    });

    test('correct report with one passing, one failing and one skipped step',
        () async {
      final reporter = TestableJsonReporter();
      await reporter.onFeature.onStarted?.call(
        StartedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
          [Tag('tag1', 1, isInherited: false)],
        ),
      );

      await reporter.onScenario.onStarted?.call(
        StartedMessage(
          Target.scenario,
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          [
            Tag('tag1', 1, isInherited: true),
            Tag('tag2', 3, isInherited: false)
          ],
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
          StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 2',
          RunnableDebugInformation('filepath', 6, 'linetext6'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 2',
          RunnableDebugInformation('filepath', 6, 'linetext6'),
          StepResult(100, StepExecutionResult.fail, 'error message'),
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 3',
          RunnableDebugInformation('filepath', 7, 'linetext7'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 3',
          RunnableDebugInformation('filepath', 7, 'linetext7'),
          StepResult(100, StepExecutionResult.skipped),
        ),
      );

      await reporter.onScenario.onFinished?.call(
        ScenarioFinishedMessage(
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          passed: true,
        ),
      );

      await reporter.onFeature.onFinished?.call(
        FinishedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.onTest.onFinished?.call();

      expect(
        reporter.report,
        minimizeJson(
          File.fromUri(Uri.file('./test/reporters/json_reports/report_3.json'))
              .readAsStringSync(),
        ),
      );
    });

    test('correct report with one passing and one failing step with attachment',
        () async {
      final reporter = TestableJsonReporter();
      await reporter.onFeature.onStarted?.call(
        StartedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
          [Tag('tag1', 1, isInherited: false)],
        ),
      );

      await reporter.onScenario.onStarted?.call(
        StartedMessage(
          Target.scenario,
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          [
            Tag('tag1', 1, isInherited: true),
            Tag('tag2', 3, isInherited: false)
          ],
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
          StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 2',
          RunnableDebugInformation('filepath', 6, 'linetext6'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 2',
          RunnableDebugInformation('filepath', 6, 'linetext6'),
          StepResult(100, StepExecutionResult.fail, 'error message'),
          [Attachment('data', 'mimetype')],
        ),
      );

      await reporter.onScenario.onFinished?.call(
        ScenarioFinishedMessage(
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          passed: true,
        ),
      );

      await reporter.onFeature.onFinished?.call(
        FinishedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.onTest.onFinished?.call();

      expect(
        reporter.report,
        minimizeJson(
          File.fromUri(Uri.file('./test/reporters/json_reports/report_4.json'))
              .readAsStringSync(),
        ),
      );
    });

    test('correct report with scenario outlines', () async {
      final reporter = TestableJsonReporter();
      await reporter.onFeature.onStarted?.call(
        StartedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
          [Tag('tag1', 1, isInherited: false)],
        ),
      );

      await reporter.onScenario.onStarted?.call(
        StartedMessage(
          Target.scenarioOutline,
          'Scenario Outline 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          [
            Tag('tag1', 1, isInherited: true),
            Tag('tag2', 3, isInherited: false)
          ],
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
          StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 2',
          RunnableDebugInformation('filepath', 6, 'linetext6'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 2',
          RunnableDebugInformation('filepath', 6, 'linetext6'),
          StepResult(100, StepExecutionResult.passed),
          [Attachment('data', 'mimetype')],
        ),
      );

      await reporter.onScenario.onFinished?.call(
        ScenarioFinishedMessage(
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          passed: true,
        ),
      );

      await reporter.onFeature.onFinished?.call(
        FinishedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.onTest.onFinished?.call();

      expect(
        reporter.report,
        minimizeJson(
          File.fromUri(Uri.file('./test/reporters/json_reports/report_6.json'))
              .readAsStringSync(),
        ),
      );
    });

    test('can add exception before any features has run', () async {
      final reporter = TestableJsonReporter();
      await reporter.onException(Exception('Test exception'), StackTrace.empty);
      await reporter.onTest.onFinished?.call();

      expect(
        reporter.report,
        minimizeJson(
          File.fromUri(Uri.file('./test/reporters/json_reports/report_7.json'))
              .readAsStringSync(),
        ),
      );
    });

    test('correct report with two features', () async {
      final reporter = TestableJsonReporter();
      await reporter.onFeature.onStarted?.call(
        StartedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
          [Tag('tag1', 1, isInherited: false)],
        ),
      );

      await reporter.onScenario.onStarted?.call(
        StartedMessage(
          Target.scenario,
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          [
            Tag('tag1', 1, isInherited: true),
            Tag('tag2', 3, isInherited: false)
          ],
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
          StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 2',
          RunnableDebugInformation('filepath', 6, 'linetext6'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 2',
          RunnableDebugInformation('filepath', 6, 'linetext6'),
          StepResult(100, StepExecutionResult.fail, 'error message'),
        ),
      );

      await reporter.onScenario.onFinished?.call(
        ScenarioFinishedMessage(
          'Scenario 1',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          passed: true,
        ),
      );

      await reporter.onFeature.onFinished?.call(
        FinishedMessage(
          Target.feature,
          'Feature 1',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.onFeature.onStarted?.call(
        StartedMessage(
          Target.feature,
          'Feature 2',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
          [Tag('tag1', 1, isInherited: false)],
        ),
      );

      await reporter.onScenario.onStarted?.call(
        StartedMessage(
          Target.scenario,
          'Scenario 2',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          [
            Tag('tag1', 1, isInherited: true),
            Tag('tag2', 3, isInherited: false)
          ],
        ),
      );

      await reporter.onStep.onStarted?.call(
        StepStartedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.onStep.onFinished?.call(
        StepFinishedMessage(
          'Step 1',
          RunnableDebugInformation('filepath', 5, 'linetext5'),
          StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.onScenario.onFinished?.call(
        ScenarioFinishedMessage(
          'Scenario 2',
          RunnableDebugInformation('filepath', 4, 'linetext4'),
          passed: true,
        ),
      );

      await reporter.onFeature.onFinished?.call(
        FinishedMessage(
          Target.feature,
          'Feature 2',
          RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.onTest.onFinished?.call();

      expect(
        reporter.report,
        minimizeJson(
          File.fromUri(Uri.file('./test/reporters/json_reports/report_8.json'))
              .readAsStringSync(),
        ),
      );
    });
  });
}
