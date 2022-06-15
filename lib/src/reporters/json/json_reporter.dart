import 'dart:convert';
import 'dart:io';

import '../../../gherkin.dart';
import 'json_feature.dart';
import 'json_scenario.dart';
import 'json_step.dart';

class JsonReporter
    implements
        JsonSerializableReporter,
        TestReporter,
        FeatureReporter,
        ScenarioReporter,
        StepReporter,
        ExceptionReporter {
  final List<JsonFeature> _features;
  final String path;
  final WriteReportCallback? writeReport;

  JsonReporter({
    this.path = './report.json',
    this.writeReport,
  }) : _features = [];

  JsonFeature get _currentFeature {
    if (_features.isEmpty) {
      _features.add(JsonFeature.empty);
    }

    return _features.last;
  }

  @override
  ReportActionHandler<TestMessage> get test =>
      ReportActionHandler(onFinished: ([message]) => _generateReport(path));

  @override
  ReportActionHandler<FeatureMessage> get feature => ReportActionHandler(
        onStarted: ([message]) async =>
            _features.add(JsonFeature.from(message!)),
      );

  @override
  ReportActionHandler<ScenarioMessage> get scenario => ReportActionHandler(
        onStarted: ([message]) async =>
            _currentFeature.add(JsonScenario.from(message!)),
      );

  @override
  ReportActionHandler<StepMessage> get step => ReportActionHandler(
        onStarted: ([message]) async =>
            _currentFeature.currentScenario.add(JsonStep.from(message!)),
        onFinished: ([message]) async =>
            _currentFeature.currentScenario.onStepFinish(message!),
      );

  @override
  Future<void> onException(Object exception, StackTrace stackTrace) async {
    _currentFeature.currentScenario.currentStep
        .onException(exception, stackTrace);
  }

  Future<void> onSaveReport(String jsonReport, String path) async {
    final file = File(path);
    await file.writeAsString(jsonReport);
  }

  Future<void> _generateReport(String path) async {
    try {
      final report = serialize();
      if (writeReport != null) {
        await writeReport!(report, path);
      } else {
        await onSaveReport(report, path);
      }
    } catch (e) {
      print('Failed to generate json report: $e');
    }
  }

  @override
  String serialize() {
    return json.encode(_features);
  }
}
