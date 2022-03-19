import 'dart:convert';
import 'dart:io';

import '../messages.dart';
import '../reporter.dart';
import '../serializable_reporter.dart';
import 'json_feature.dart';
import 'json_scenario.dart';
import 'json_step.dart';

typedef WriteReportCallback = Future<void> Function(
    String jsonReport, String path);

class JsonReporter extends Reporter implements JsonSerializableReporter {
  final List<JsonFeature> _features;
  final String path;
  final WriteReportCallback? writeReport;

  JsonReporter({
    this.path = './report.json',
    this.writeReport,
  }) : _features = [];

  @override
  Future<void> onFeatureStarted(StartedMessage message) async {
    _features.add(JsonFeature.from(message));
  }

  @override
  Future<void> onScenarioStarted(StartedMessage message) async {
    _currentFeature.add(JsonScenario.from(message));
  }

  @override
  Future<void> onStepStarted(StepStartedMessage message) async {
    _currentFeature.currentScenario.add(JsonStep.from(message));
  }

  @override
  Future<void> onStepFinished(StepFinishedMessage message) async {
    _currentFeature.currentScenario.currentStep.onFinish(message);
  }

  @override
  Future<void> onException(Object exception, StackTrace stackTrace) async {
    _currentFeature.currentScenario.currentStep
        .onException(exception, stackTrace);
  }

  @override
  Future<void> onTestRunFinished() => _generateReport(path);

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

  JsonFeature get _currentFeature {
    if (_features.isEmpty) {
      _features.add(JsonFeature.empty);
    }

    return _features.last;
  }

  @override
  String serialize() {
    return json.encode(_features);
  }
}
