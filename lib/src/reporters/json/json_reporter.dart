import 'dart:convert';
import 'dart:io';

import 'package:gherkin/src/reporters/json/json_feature.dart';
import 'package:gherkin/src/reporters/json/json_scenario.dart';
import 'package:gherkin/src/reporters/json/json_step.dart';
import 'package:gherkin/src/reporters/reporter.dart';
import 'package:gherkin/src/reporters/serializable_reporter.dart';

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
  ReporterMap<StartedCallback, FinishedCallback> get onFeature => ReporterMap(
        onStarted: (message) async => _features.add(JsonFeature.from(message)),
      );

  @override
  ReporterMap<StartedCallback, ScenarioFinishedCallback> get onScenario =>
      ReporterMap(
        onStarted: (message) async =>
            _currentFeature.add(JsonScenario.from(message)),
      );

  @override
  ReporterMap<StepStartedCallback, StepFinishedCallback> get onStep =>
      ReporterMap(
        onStarted: (message) async =>
            _currentFeature.currentScenario.add(JsonStep.from(message)),
        onFinished: (message) async =>
            _currentFeature.currentScenario.currentStep.onFinish(message),
      );

  @override
  ReporterMap<FutureCallback, FutureCallback> get onTest =>
      ReporterMap(onFinished: () async => _generateReport(path));

  @override
  String serialize() {
    return json.encode(_features);
  }
}
