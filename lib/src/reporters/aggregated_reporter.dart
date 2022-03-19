import './serializable_reporter.dart';
import './messages.dart';
import './message_level.dart';
import './reporter.dart';

typedef ReportInvoke = Future<void> Function(Reporter r);

class AggregatedReporter extends Reporter implements JsonSerializableReporter {
  final List<Reporter> _reporters = <Reporter>[];

  void addReporter(Reporter reporter) => _reporters.add(reporter);

  @override
  Future<void> message(String message, MessageLevel level) =>
      _invokeReporters((r) => r.message(message, level));

  @override
  Future<void> onTestRunStarted() {
    return _invokeReporters((r) => r.onTestRunStarted());
  }

  @override
  Future<void> onTestRunFinished() {
    return _invokeReporters((r) => r.onTestRunFinished());
  }

  @override
  Future<void> onFeatureStarted(StartedMessage message) {
    return _invokeReporters((r) => r.onFeatureStarted(message));
  }

  @override
  Future<void> onFeatureFinished(FinishedMessage message) {
    return _invokeReporters((r) => r.onFeatureFinished(message));
  }

  @override
  Future<void> onScenarioStarted(StartedMessage message) {
    return _invokeReporters((r) => r.onScenarioStarted(message));
  }

  @override
  Future<void> onScenarioFinished(ScenarioFinishedMessage message) {
    return _invokeReporters((r) => r.onScenarioFinished(message));
  }

  @override
  Future<void> onStepStarted(StepStartedMessage message) {
    return _invokeReporters((r) => r.onStepStarted(message));
  }

  @override
  Future<void> onStepFinished(StepFinishedMessage message) {
    return _invokeReporters((r) => r.onStepFinished(message));
  }

  @override
  Future<void> onException(Object exception, StackTrace stackTrace) {
    return _invokeReporters((r) => r.onException(exception, stackTrace));
  }

  @override
  Future<void> dispose() async {
    await _invokeReporters((r) => r.dispose());
    _reporters.clear();
  }

  Future<void> _invokeReporters(ReportInvoke invoke) =>
      Future.wait(_reporters.map(invoke));

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
}
