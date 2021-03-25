import 'dart:convert';
import 'dart:io';

import 'package:gherkin/gherkin.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:test/test.dart';

class TestableJsonReporter extends JsonReporter {
  String? report;

  @override
  Future<void> onSaveReport(String jsonReport) async {
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
      await reporter.onFeatureStarted(StartedMessage(
        Target.feature,
        'Feature 1',
        RunnableDebugInformation('filepath', 2, 'linetext2'),
        [Tag('tag1', 1, false)],
      ));

      await reporter.onScenarioStarted(StartedMessage(
        Target.scenario,
        'Scenario 1',
        RunnableDebugInformation('filepath', 4, 'linetext4'),
        [Tag('tag1', 1, true), Tag('tag2', 3, false)],
      ));

      await reporter.onStepStarted(StepStartedMessage(
        'Step 1',
        RunnableDebugInformation('filepath', 5, 'linetext5'),
      ));

      await reporter.onStepFinished(StepFinishedMessage(
        'Step 1',
        RunnableDebugInformation('filepath', 5, 'linetext5'),
        StepResult(100, StepExecutionResult.pass),
      ));

      await reporter.onScenarioFinished(ScenarioFinishedMessage(
        'Scenario 1',
        RunnableDebugInformation('filepath', 4, 'linetext4'),
        true,
      ));

      await reporter.onFeatureFinished(FinishedMessage(
        Target.feature,
        'Feature 1',
        RunnableDebugInformation('filepath', 2, 'linetext2'),
      ));

      await reporter.onTestRunFinished();

      expect(
        reporter.report,
        minimizeJson(
          File.fromUri(Uri.file('./test/reporters/json_reports/report_1.json'))
              .readAsStringSync(),
        ),
      );
    });

    test('correct report with one passing step with doc string', () async {
      final reporter = TestableJsonReporter();
      await reporter.onFeatureStarted(StartedMessage(
        Target.feature,
        'Feature 1',
        RunnableDebugInformation('filepath', 2, 'linetext2'),
        [Tag('tag1', 1, false)],
      ));

      await reporter.onScenarioStarted(StartedMessage(
        Target.scenario,
        'Scenario 1',
        RunnableDebugInformation('filepath', 4, 'linetext4'),
        [Tag('tag1', 1, true), Tag('tag2', 3, false)],
      ));

      await reporter.onStepStarted(StepStartedMessage(
        'Step 1',
        RunnableDebugInformation('filepath', 5, 'linetext5'),
        multilineString: 'a\nb\nc',
      ));

      await reporter.onStepFinished(StepFinishedMessage(
        'Step 1',
        RunnableDebugInformation('filepath', 5, 'linetext5'),
        StepResult(100, StepExecutionResult.pass),
      ));

      await reporter.onScenarioFinished(ScenarioFinishedMessage(
        'Scenario 1',
        RunnableDebugInformation('filepath', 4, 'linetext4'),
        true,
      ));

      await reporter.onFeatureFinished(FinishedMessage(
        Target.feature,
        'Feature 1',
        RunnableDebugInformation('filepath', 2, 'linetext2'),
      ));

      await reporter.onTestRunFinished();

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
      await reporter.onFeatureStarted(StartedMessage(
        Target.feature,
        'Feature 1',
        RunnableDebugInformation('filepath', 2, 'linetext2'),
        [Tag('tag1', 1, false)],
      ));

      await reporter.onScenarioStarted(StartedMessage(
        Target.scenario,
        'Scenario 1',
        RunnableDebugInformation('filepath', 4, 'linetext4'),
        [Tag('tag1', 1, true), Tag('tag2', 3, false)],
      ));

      await reporter.onStepStarted(StepStartedMessage(
        'Step 1',
        RunnableDebugInformation('filepath', 5, 'linetext5'),
      ));

      await reporter.onStepFinished(StepFinishedMessage(
        'Step 1',
        RunnableDebugInformation('filepath', 5, 'linetext5'),
        StepResult(100, StepExecutionResult.pass),
      ));

      await reporter.onStepStarted(StepStartedMessage(
        'Step 2',
        RunnableDebugInformation('filepath', 6, 'linetext6'),
      ));

      await reporter.onStepFinished(StepFinishedMessage(
        'Step 2',
        RunnableDebugInformation('filepath', 6, 'linetext6'),
        StepResult(100, StepExecutionResult.fail, 'error message'),
      ));

      await reporter.onScenarioFinished(ScenarioFinishedMessage(
        'Scenario 1',
        RunnableDebugInformation('filepath', 4, 'linetext4'),
        true,
      ));

      await reporter.onFeatureFinished(FinishedMessage(
        Target.feature,
        'Feature 1',
        RunnableDebugInformation('filepath', 2, 'linetext2'),
      ));

      await reporter.onTestRunFinished();

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
      await reporter.onFeatureStarted(StartedMessage(
        Target.feature,
        'Feature 1',
        RunnableDebugInformation('filepath', 2, 'linetext2'),
        [Tag('tag1', 1, false)],
      ));

      await reporter.onScenarioStarted(StartedMessage(
        Target.scenario,
        'Scenario 1',
        RunnableDebugInformation('filepath', 4, 'linetext4'),
        [Tag('tag1', 1, true), Tag('tag2', 3, false)],
      ));

      await reporter.onStepStarted(StepStartedMessage(
        'Step 1',
        RunnableDebugInformation('filepath', 5, 'linetext5'),
      ));

      await reporter.onStepFinished(StepFinishedMessage(
        'Step 1',
        RunnableDebugInformation('filepath', 5, 'linetext5'),
        StepResult(100, StepExecutionResult.pass),
      ));

      await reporter.onStepStarted(StepStartedMessage(
        'Step 2',
        RunnableDebugInformation('filepath', 6, 'linetext6'),
      ));

      await reporter.onStepFinished(StepFinishedMessage(
        'Step 2',
        RunnableDebugInformation('filepath', 6, 'linetext6'),
        StepResult(100, StepExecutionResult.fail, 'error message'),
      ));

      await reporter.onStepStarted(StepStartedMessage(
        'Step 3',
        RunnableDebugInformation('filepath', 7, 'linetext7'),
      ));

      await reporter.onStepFinished(StepFinishedMessage(
        'Step 3',
        RunnableDebugInformation('filepath', 7, 'linetext7'),
        StepResult(100, StepExecutionResult.skipped),
      ));

      await reporter.onScenarioFinished(ScenarioFinishedMessage(
        'Scenario 1',
        RunnableDebugInformation('filepath', 4, 'linetext4'),
        true,
      ));

      await reporter.onFeatureFinished(FinishedMessage(
        Target.feature,
        'Feature 1',
        RunnableDebugInformation('filepath', 2, 'linetext2'),
      ));

      await reporter.onTestRunFinished();

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
      await reporter.onFeatureStarted(StartedMessage(
        Target.feature,
        'Feature 1',
        RunnableDebugInformation('filepath', 2, 'linetext2'),
        [Tag('tag1', 1, false)],
      ));

      await reporter.onScenarioStarted(StartedMessage(
        Target.scenario,
        'Scenario 1',
        RunnableDebugInformation('filepath', 4, 'linetext4'),
        [Tag('tag1', 1, true), Tag('tag2', 3, false)],
      ));

      await reporter.onStepStarted(StepStartedMessage(
        'Step 1',
        RunnableDebugInformation('filepath', 5, 'linetext5'),
      ));

      await reporter.onStepFinished(StepFinishedMessage(
        'Step 1',
        RunnableDebugInformation('filepath', 5, 'linetext5'),
        StepResult(100, StepExecutionResult.pass),
      ));

      await reporter.onStepStarted(StepStartedMessage(
        'Step 2',
        RunnableDebugInformation('filepath', 6, 'linetext6'),
      ));

      await reporter.onStepFinished(StepFinishedMessage(
        'Step 2',
        RunnableDebugInformation('filepath', 6, 'linetext6'),
        StepResult(100, StepExecutionResult.fail, 'error message'),
        [Attachment('data', 'mimetype')],
      ));

      await reporter.onScenarioFinished(ScenarioFinishedMessage(
        'Scenario 1',
        RunnableDebugInformation('filepath', 4, 'linetext4'),
        true,
      ));

      await reporter.onFeatureFinished(FinishedMessage(
        Target.feature,
        'Feature 1',
        RunnableDebugInformation('filepath', 2, 'linetext2'),
      ));

      await reporter.onTestRunFinished();

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
      await reporter.onFeatureStarted(StartedMessage(
        Target.feature,
        'Feature 1',
        RunnableDebugInformation('filepath', 2, 'linetext2'),
        [Tag('tag1', 1, false)],
      ));

      await reporter.onScenarioStarted(StartedMessage(
        Target.scenario_outline,
        'Scenario Outline 1',
        RunnableDebugInformation('filepath', 4, 'linetext4'),
        [Tag('tag1', 1, true), Tag('tag2', 3, false)],
      ));

      await reporter.onStepStarted(StepStartedMessage(
        'Step 1',
        RunnableDebugInformation('filepath', 5, 'linetext5'),
      ));

      await reporter.onStepFinished(StepFinishedMessage(
        'Step 1',
        RunnableDebugInformation('filepath', 5, 'linetext5'),
        StepResult(100, StepExecutionResult.pass),
      ));

      await reporter.onStepStarted(StepStartedMessage(
        'Step 2',
        RunnableDebugInformation('filepath', 6, 'linetext6'),
      ));

      await reporter.onStepFinished(StepFinishedMessage(
        'Step 2',
        RunnableDebugInformation('filepath', 6, 'linetext6'),
        StepResult(100, StepExecutionResult.pass),
        [Attachment('data', 'mimetype')],
      ));

      await reporter.onScenarioFinished(ScenarioFinishedMessage(
        'Scenario 1',
        RunnableDebugInformation('filepath', 4, 'linetext4'),
        true,
      ));

      await reporter.onFeatureFinished(FinishedMessage(
        Target.feature,
        'Feature 1',
        RunnableDebugInformation('filepath', 2, 'linetext2'),
      ));

      await reporter.onTestRunFinished();

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
      await reporter.onTestRunFinished();

      expect(
        reporter.report,
        minimizeJson(
          File.fromUri(Uri.file('./test/reporters/json_reports/report_7.json'))
              .readAsStringSync(),
        ),
      );
    });
  });
}
