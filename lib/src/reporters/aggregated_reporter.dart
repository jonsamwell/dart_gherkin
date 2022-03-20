import 'package:collection/collection.dart';
import 'package:gherkin/src/reporters/message_level.dart';
import 'package:gherkin/src/reporters/reporter.dart';
import 'package:gherkin/src/reporters/serializable_reporter.dart';

class AggregatedReporter extends FullReporter
    with ManyRepoters
    implements JsonSerializableReporter, ManyRepoters {
  final List<Reporter> _reporters = <Reporter>[];

  void addReporter(Reporter reporter) => _reporters.add(reporter);

  @override
  UnmodifiableListView<Reporter> get repoters =>
      UnmodifiableListView(_reporters);

  @override
  ReporterMap<StartedCallback, FinishedCallback> get onFeature => ReporterMap(
        onStarted: (message) => invokeReporters<FeatureReporter>(
          (r) => r.onFeature.onStarted?.call(message),
        ),
        onFinished: (message) => invokeReporters<FeatureReporter>(
          (r) => r.onFeature.onFinished?.call(message),
        ),
      );

  @override
  ReporterMap<StartedCallback, ScenarioFinishedCallback> get onScenario =>
      ReporterMap(
        onStarted: (message) => invokeReporters<ScenarioReporter>(
          (r) => r.onScenario.onStarted?.call(message),
        ),
        onFinished: (message) => invokeReporters<ScenarioReporter>(
          (r) => r.onScenario.onFinished?.call(message),
        ),
      );

  @override
  ReporterMap<StepStartedCallback, StepFinishedCallback> get onStep =>
      ReporterMap(
        onStarted: (message) => invokeReporters<StepReporter>(
          (r) => r.onStep.onStarted?.call(message),
        ),
        onFinished: (message) => invokeReporters<StepReporter>(
          (r) => r.onStep.onFinished?.call(message),
        ),
      );

  @override
  ReporterMap<FutureCallback, FutureCallback> get onTest => ReporterMap(
        onStarted: () =>
            invokeReporters<TestReporter>((r) => r.onTest.onStarted?.call()),
        onFinished: () =>
            invokeReporters<TestReporter>((r) => r.onTest.onFinished?.call()),
      );

  @override
  String serialize() {
    var jsonReports = '';
    if (_reporters.isEmpty) {
      return '[]';
    }

    jsonReports = _reporters
        .whereType<SerializableReporter<String>>()
        .map((x) => x.serialize())
        .where((x) => x.isNotEmpty)
        .join(',');

    return '[$jsonReports]';
  }

  @override
  Future<void> message(String message, MessageLevel level) =>
      invokeReporters<MessageReporter>((r) => r.message(message, level));

  @override
  Future<void> onException(Object exception, StackTrace stackTrace) =>
      invokeReporters<ExceptionReporter>(
        (r) => r.onException(exception, stackTrace),
      );

  @override
  Future<void> dispose() async {
    await invokeReporters<DisposableRepoter>((r) => r.dispose());
    _reporters.clear();
  }
}
