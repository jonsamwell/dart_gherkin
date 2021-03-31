import './messages.dart';
import './message_level.dart';
import './reporter.dart';

class AggregatedReporter extends Reporter {
  final List<Reporter> _reporters = <Reporter>[];

  void addReporter(Reporter reporter) => _reporters.add(reporter);

  @override
  Future<void> message(String message, MessageLevel level) async {
    await _invokeReporters((r) async => await r.message(message, level));
  }

  @override
  Future<void> onTestRunStarted() async {
    await _invokeReporters((r) async => await r.onTestRunStarted());
  }

  @override
  Future<void> onTestRunFinished() async {
    await _invokeReporters((r) async => await r.onTestRunFinished());
  }

  @override
  Future<void> onFeatureStarted(StartedMessage? message) async {
    await _invokeReporters((r) async => await r.onFeatureStarted(message));
  }

  @override
  Future<void> onFeatureFinished(FinishedMessage? message) async {
    await _invokeReporters((r) async => await r.onFeatureFinished(message));
  }

  @override
  Future<void> onScenarioStarted(StartedMessage? message) async {
    await _invokeReporters((r) async => await r.onScenarioStarted(message));
  }

  @override
  Future<void> onScenarioFinished(FinishedMessage? message) async {
    await _invokeReporters((r) async => await r.onScenarioFinished(message as ScenarioFinishedMessage?));
  }

  @override
  Future<void> onStepStarted(StepStartedMessage? message) async {
    await _invokeReporters((r) async => await r.onStepStarted(message));
  }

  @override
  Future<void> onStepFinished(StepFinishedMessage? message) async {
    await _invokeReporters((r) async => await r.onStepFinished(message));
  }

  @override
  Future<void> onException(Exception? exception, StackTrace? stackTrace) async {
    await _invokeReporters(
        (r) async => await r.onException(exception, stackTrace));
  }

  @override
  Future<void> dispose() async {
    await _invokeReporters((r) async => await r.dispose());
  }

  Future<void> _invokeReporters(
      Future<void> Function(Reporter r) invoke) async {
    if (_reporters != null && _reporters.isNotEmpty) {
      for (var reporter in _reporters) {
        await invoke(reporter);
      }
    }
  }
}
