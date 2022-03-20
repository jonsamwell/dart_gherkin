import 'package:gherkin/gherkin.dart';

typedef OnStepFinished = void Function(StepFinishedMessage message);

class ReporterMock extends FullReporter {
  int onTestRunStartedInvocationCount = 0;
  int onTestRunFinishedInvocationCount = 0;
  int onFeatureStartedInvocationCount = 0;
  int onFeatureFinishedInvocationCount = 0;
  int onScenarioStartedInvocationCount = 0;
  int onScenarioFinishedInvocationCount = 0;
  int onStepStartedInvocationCount = 0;
  int onStepFinishedInvocationCount = 0;
  int onExceptionInvocationCount = 0;
  int messageInvocationCount = 0;
  int disposeInvocationCount = 0;

  OnStepFinished? onStepFinishedFn;

  @override
  ReporterMap<FutureCallback, FutureCallback> get onTest => ReporterMap(
        onStarted: () async => onTestRunStartedInvocationCount += 1,
        onFinished: () async => onTestRunFinishedInvocationCount += 1,
      );

  @override
  ReporterMap<StartedCallback, FinishedCallback> get onFeature => ReporterMap(
        onStarted: (message) async => onFeatureStartedInvocationCount += 1,
        onFinished: (message) async => onFeatureFinishedInvocationCount += 1,
      );

  @override
  ReporterMap<StartedCallback, ScenarioFinishedCallback> get onScenario =>
      ReporterMap(
        onStarted: (message) async => onScenarioStartedInvocationCount += 1,
        onFinished: (message) async => onScenarioFinishedInvocationCount += 1,
      );

  @override
  ReporterMap<StepStartedCallback, StepFinishedCallback> get onStep =>
      ReporterMap(
        onStarted: (message) async => onStepStartedInvocationCount += 1,
        onFinished: (message) async {
          onStepFinishedFn?.call(message);

          onStepFinishedInvocationCount += 1;
        },
      );

  @override
  Future<void> onException(Object exception, StackTrace stackTrace) async =>
      onExceptionInvocationCount += 1;

  @override
  Future<void> message(String message, MessageLevel level) async =>
      messageInvocationCount += 1;

  @override
  Future<void> dispose() async => disposeInvocationCount += 1;
}

class SerializableReporterMock extends Reporter
    implements JsonSerializableReporter {
  final String _json;

  SerializableReporterMock(this._json);

  @override
  String serialize() {
    return _json;
  }
}
