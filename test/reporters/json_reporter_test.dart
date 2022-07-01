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
      await reporter.feature.onStarted.invoke(
        FeatureMessage(
          name: 'Feature 1',
          description: "Feature 1 description",
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
          tags: [Tag('tag1', 1)],
        ),
      );

      await reporter.scenario.onStarted.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          description: "Scenario 1 description",
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: true,
          tags: [Tag('tag1', 1, isInherited: true), Tag('tag2', 3)],
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
          result: StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.scenario.onFinished.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          description: "Scenario 1 description",
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: true,
        ),
      );

      await reporter.feature.onFinished.invoke(
        FeatureMessage(
          name: 'Feature 1',
          description: "Feature 1 description",
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.test.onFinished.invoke();
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
      await reporter.feature.onStarted.invoke(
        FeatureMessage(
          name: 'Feature 1',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
          tags: [Tag('tag1', 1)],
        ),
      );

      await reporter.scenario.onStarted.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: true,
          tags: [Tag('tag1', 1, isInherited: true), Tag('tag2', 3)],
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
          multilineString: 'a\nb\nc',
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
          result: StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.scenario.onFinished.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: true,
        ),
      );

      await reporter.feature.onFinished.invoke(
        FeatureMessage(
          name: 'Feature 1',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.test.onFinished.invoke();

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
      await reporter.feature.onStarted.invoke(
        FeatureMessage(
          name: 'Feature 1',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
          tags: [Tag('tag1', 1)],
        ),
      );

      await reporter.scenario.onStarted.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: false,
          tags: [
            Tag('tag1', 1, isInherited: true),
            Tag('tag2', 3, isInherited: false)
          ],
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
          result: StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 2',
          context: RunnableDebugInformation('filepath', 6, 'linetext6'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 2',
          context: RunnableDebugInformation('filepath', 6, 'linetext6'),
          result: StepResult(
            100,
            StepExecutionResult.fail,
            resultReason: 'error message',
          ),
        ),
      );

      await reporter.scenario.onFinished.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: true,
        ),
      );

      await reporter.feature.onFinished.invoke(
        FeatureMessage(
          name: 'Feature 1',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.test.onFinished.invoke();

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
      await reporter.feature.onStarted.invoke(
        FeatureMessage(
          name: 'Feature 1',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
          tags: [Tag('tag1', 1, isInherited: false)],
        ),
      );

      await reporter.scenario.onStarted.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: false,
          tags: [
            Tag('tag1', 1, isInherited: true),
            Tag('tag2', 3, isInherited: false)
          ],
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
          result: StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 2',
          context: RunnableDebugInformation('filepath', 6, 'linetext6'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 2',
          context: RunnableDebugInformation('filepath', 6, 'linetext6'),
          result: StepResult(
            100,
            StepExecutionResult.fail,
            resultReason: 'error message',
          ),
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 3',
          context: RunnableDebugInformation('filepath', 7, 'linetext7'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 3',
          context: RunnableDebugInformation('filepath', 7, 'linetext7'),
          result: StepResult(100, StepExecutionResult.skipped),
        ),
      );

      await reporter.scenario.onFinished.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: true,
        ),
      );

      await reporter.feature.onFinished.invoke(
        FeatureMessage(
          name: 'Feature 1',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.test.onFinished.invoke();

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
      await reporter.feature.onStarted.invoke(
        FeatureMessage(
          name: 'Feature 1',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
          tags: [Tag('tag1', 1, isInherited: false)],
        ),
      );

      await reporter.scenario.onStarted.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: false,
          tags: [
            Tag('tag1', 1, isInherited: true),
            Tag('tag2', 3, isInherited: false)
          ],
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
          result: StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 2',
          context: RunnableDebugInformation('filepath', 6, 'linetext6'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 2',
          context: RunnableDebugInformation('filepath', 6, 'linetext6'),
          result: StepResult(
            100,
            StepExecutionResult.fail,
            resultReason: 'error message',
          ),
          attachments: [Attachment('data', 'mimetype')],
        ),
      );

      await reporter.scenario.onFinished.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: true,
        ),
      );

      await reporter.feature.onFinished.invoke(
        FeatureMessage(
          name: 'Feature 1',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.test.onFinished.invoke();

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
      await reporter.feature.onStarted.invoke(
        FeatureMessage(
          name: 'Feature 1',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
          tags: [Tag('tag1', 1, isInherited: false)],
        ),
      );

      await reporter.scenario.onStarted.invoke(
        ScenarioMessage(
          target: Target.scenarioOutline,
          name: 'Scenario Outline 1',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: true,
          tags: [
            Tag('tag1', 1, isInherited: true),
            Tag('tag2', 3, isInherited: false)
          ],
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
          result: StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 2',
          context: RunnableDebugInformation('filepath', 6, 'linetext6'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 2',
          context: RunnableDebugInformation('filepath', 6, 'linetext6'),
          result: StepResult(100, StepExecutionResult.passed),
          attachments: [Attachment('data', 'mimetype')],
        ),
      );

      await reporter.scenario.onFinished.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: true,
        ),
      );

      await reporter.feature.onFinished.invoke(
        FeatureMessage(
          name: 'Feature 1',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.test.onFinished.invoke();

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
      await reporter.test.onFinished.invoke();

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
      await reporter.feature.onStarted.invoke(
        FeatureMessage(
          name: 'Feature 1',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
          tags: [Tag('tag1', 1, isInherited: false)],
        ),
      );

      await reporter.scenario.onStarted.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: false,
          tags: [
            Tag('tag1', 1, isInherited: true),
            Tag('tag2', 3, isInherited: false)
          ],
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
          result: StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 2',
          context: RunnableDebugInformation('filepath', 6, 'linetext6'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 2',
          context: RunnableDebugInformation('filepath', 6, 'linetext6'),
          result: StepResult(
            100,
            StepExecutionResult.fail,
            resultReason: 'error message',
          ),
        ),
      );

      await reporter.scenario.onFinished.invoke(
        ScenarioMessage(
          name: 'Scenario 1',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: true,
        ),
      );

      await reporter.feature.onFinished.invoke(
        FeatureMessage(
          name: 'Feature 1',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.feature.onStarted.invoke(
        FeatureMessage(
          name: 'Feature 2',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
          tags: [Tag('tag1', 1, isInherited: false)],
        ),
      );

      await reporter.scenario.onStarted.invoke(
        ScenarioMessage(
          name: 'Scenario 2',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          tags: [
            Tag('tag1', 1, isInherited: true),
            Tag('tag2', 3, isInherited: false)
          ],
        ),
      );

      await reporter.step.onStarted.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
        ),
      );

      await reporter.step.onFinished.invoke(
        StepMessage(
          name: 'Step 1',
          context: RunnableDebugInformation('filepath', 5, 'linetext5'),
          result: StepResult(100, StepExecutionResult.passed),
        ),
      );

      await reporter.scenario.onFinished.invoke(
        ScenarioMessage(
          name: 'Scenario 2',
          context: RunnableDebugInformation('filepath', 4, 'linetext4'),
          hasPassed: true,
        ),
      );

      await reporter.feature.onFinished.invoke(
        FeatureMessage(
          name: 'Feature 2',
          context: RunnableDebugInformation('filepath', 2, 'linetext2'),
        ),
      );

      await reporter.test.onFinished.invoke();

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
