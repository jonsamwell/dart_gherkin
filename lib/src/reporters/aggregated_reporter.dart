import 'package:collection/collection.dart';
import 'message_level.dart';
import 'messages/messages.dart';
import 'reporter.dart';
import 'serializable_reporter.dart';

class AggregatedReporter extends FullReporter
    with AllReporters
    implements JsonSerializableReporter {
  final List<Reporter> _reporters = <Reporter>[];

  void addReporter(Reporter reporter) => _reporters.add(reporter);

  @override
  UnmodifiableListView<Reporter> get reporters =>
      UnmodifiableListView(_reporters);

  @override
  ReportActionHandler<TestMessage> get test => ReportActionHandler(
        onStarted: ([_]) => invokeReporters<TestReporter>(
          (r) => r.test.onStarted.maybeCall(),
        ),
        onFinished: ([_]) => invokeReporters<TestReporter>(
          (r) => r.test.onFinished.maybeCall(),
        ),
      );

  @override
  ReportActionHandler<FeatureMessage> get feature => ReportActionHandler(
        onStarted: ([value]) => invokeReporters<FeatureReporter>(
          (r) => r.feature.onStarted.maybeCall(value),
        ),
        onFinished: ([message]) => invokeReporters<FeatureReporter>(
          (report) => report.feature.onFinished.maybeCall(message),
        ),
      );

  @override
  ReportActionHandler<ScenarioMessage> get scenario => ReportActionHandler(
        onStarted: ([message]) => invokeReporters<ScenarioReporter>(
          (r) => r.scenario.onStarted.maybeCall(message),
        ),
        onFinished: ([message]) => invokeReporters<ScenarioReporter>(
          (r) => r.scenario.onFinished.maybeCall(message),
        ),
      );

  @override
  ReportActionHandler<StepMessage> get step => ReportActionHandler(
        onStarted: ([message]) => invokeReporters<StepReporter>(
          (r) => r.step.onStarted.maybeCall(message),
        ),
        onFinished: ([message]) => invokeReporters<StepReporter>(
          (r) => r.step.onFinished.maybeCall(message),
        ),
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
    await invokeReporters<DisposableReporter>((r) => r.dispose());
    _reporters.clear();
  }
}
