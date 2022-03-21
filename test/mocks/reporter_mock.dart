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
  ReportActionHandler<void, void> get test => ReportActionHandler<void, void>(
        onStarted: ([massage]) async => onTestRunStartedInvocationCount += 1,
        onFinished: ([massage]) async => onTestRunFinishedInvocationCount += 1,
      );

  @override
  ReportActionHandler<StartedMessage, FinishedMessage> get feature =>
      ReportActionHandler(
        onStarted: ([message]) async => onFeatureStartedInvocationCount += 1,
        onFinished: ([message]) async => onFeatureFinishedInvocationCount += 1,
      );

  @override
  ReportActionHandler<StartedMessage, ScenarioFinishedMessage> get scenario =>
      ReportActionHandler(
        onStarted: ([message]) async => onScenarioStartedInvocationCount += 1,
        onFinished: ([message]) async => onScenarioFinishedInvocationCount += 1,
      );

  @override
  ReportActionHandler<StepStartedMessage, StepFinishedMessage> get step =>
      ReportActionHandler(
        onStarted: ([message]) async => onStepStartedInvocationCount += 1,
        onFinished: ([message]) async {
          if (message != null && onStepFinishedFn != null) {
            onStepFinishedFn!(message);
          }

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
