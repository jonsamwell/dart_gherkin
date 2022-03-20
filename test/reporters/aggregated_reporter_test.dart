import 'package:gherkin/gherkin.dart';
import 'package:test/test.dart';

import '../mocks/reporter_mock.dart';

void main() {
  group('reporters', () {
    test('invokes all child reporters', () async {
      final reporter1 = ReporterMock();
      final reporter2 = ReporterMock();

      final aggregatedReporter = AggregatedReporter();
      aggregatedReporter.addReporter(reporter1);
      aggregatedReporter.addReporter(reporter2);

      await aggregatedReporter.message('', MessageLevel.info);
      expect(reporter1.messageInvocationCount, 1);
      expect(reporter2.messageInvocationCount, 1);

      await aggregatedReporter.onException(Object(), StackTrace.empty);
      expect(reporter1.onExceptionInvocationCount, 1);
      expect(reporter2.onExceptionInvocationCount, 1);

      await aggregatedReporter.onFeature.onStarted?.call(
        StartedMessage(
          Target.feature,
          '',
          RunnableDebugInformation.empty(),
          const Iterable.empty(),
        ),
      );
      expect(reporter1.onFeatureStartedInvocationCount, 1);
      expect(reporter2.onFeatureStartedInvocationCount, 1);

      await aggregatedReporter.onFeature.onFinished?.call(
        FinishedMessage(
          Target.feature,
          '',
          RunnableDebugInformation.empty(),
        ),
      );
      expect(reporter1.onFeatureFinishedInvocationCount, 1);
      expect(reporter2.onFeatureFinishedInvocationCount, 1);

      await aggregatedReporter.onScenario.onFinished?.call(
        ScenarioFinishedMessage(
          '',
          RunnableDebugInformation.empty(),
          passed: true,
        ),
      );
      expect(reporter1.onScenarioFinishedInvocationCount, 1);
      expect(reporter2.onScenarioFinishedInvocationCount, 1);

      await aggregatedReporter.onScenario.onStarted?.call(
        StartedMessage(
          Target.feature,
          '',
          RunnableDebugInformation.empty(),
          const Iterable.empty(),
        ),
      );
      expect(reporter1.onScenarioStartedInvocationCount, 1);
      expect(reporter2.onScenarioStartedInvocationCount, 1);

      await aggregatedReporter.onStep.onFinished?.call(
        StepFinishedMessage(
          '',
          RunnableDebugInformation.empty(),
          StepResult(
            0,
            StepExecutionResult.skipped,
          ),
        ),
      );
      expect(reporter1.onStepFinishedInvocationCount, 1);
      expect(reporter2.onStepFinishedInvocationCount, 1);

      await aggregatedReporter.onStep.onStarted?.call(
        StepStartedMessage(
          '',
          RunnableDebugInformation.empty(),
        ),
      );
      expect(reporter1.onStepStartedInvocationCount, 1);
      expect(reporter2.onStepStartedInvocationCount, 1);

      await aggregatedReporter.onTest.onFinished?.call();
      expect(reporter1.onTestRunFinishedInvocationCount, 1);
      expect(reporter2.onTestRunFinishedInvocationCount, 1);

      await aggregatedReporter.onTest.onStarted?.call();
      await aggregatedReporter.onTest.onStarted?.call();
      expect(reporter1.onTestRunStartedInvocationCount, 2);
      expect(reporter2.onTestRunStartedInvocationCount, 2);

      await aggregatedReporter.dispose();
      expect(reporter1.disposeInvocationCount, 1);
      expect(reporter2.disposeInvocationCount, 1);
    });

    test('toJson with no serializable reports returns correct json', () async {
      final reporter1 = ReporterMock();
      final reporter2 = ReporterMock();

      final aggregatedReporter = AggregatedReporter();
      aggregatedReporter.addReporter(reporter1);
      aggregatedReporter.addReporter(reporter2);

      expect(aggregatedReporter.serialize(), '[]');
    });

    test('toJson with two serializable reports returns correct json', () async {
      final reporter1 = SerializableReporterMock('{"a", "b", "c": 1}');
      final reporter2 = ReporterMock();
      final reporter3 = SerializableReporterMock('{"e", "f", "g": 2}');

      final aggregatedReporter = AggregatedReporter();
      aggregatedReporter.addReporter(reporter1);
      aggregatedReporter.addReporter(reporter2);
      aggregatedReporter.addReporter(reporter3);

      expect(
        aggregatedReporter.serialize(),
        '[{"a", "b", "c": 1},{"e", "f", "g": 2}]',
      );
    });
  });
}
