import 'dart:convert';
import 'dart:io';
import 'package:gherkin/src/reporters/json/json_tag.dart';

import '../messages.dart';
import '../reporter.dart';
import 'json_feature.dart';
import 'json_scenario.dart';
import 'json_step.dart';

class JsonReporter extends Reporter {
  final List<JsonFeature> _features = [];
  final String path;

  JsonReporter({
    this.path = './report.json',
  });

  @override
  Future<void> onFeatureStarted(StartedMessage? message) async {
    _features.add(JsonFeature.from(message!));
  }

  @override
  Future<void> onScenarioStarted(StartedMessage? message) async {
    _getCurrentFeature().add(scenario: JsonScenario.from(message!));
  }

  @override
  Future<void> onStepStarted(StepStartedMessage? message) async {
    _getCurrentFeature().currentScenario().add(step: JsonStep.from(message!));
  }

  @override
  Future<void> onStepFinished(StepFinishedMessage? message) async {
    _getCurrentFeature().currentScenario().currentStep()!.onFinish(message!);
  }

  @override
  Future<void> onException(Exception? exception, StackTrace? stackTrace) async {
    _getCurrentFeature()
        .currentScenario()
        .currentStep()!
        .onException(exception, stackTrace);
  }

  @override
  Future<void> onTestRunFinished() async {
    await _generateReport(path, _features);
  }

  Future<void> onSaveReport(String jsonReport) async {
    final file = File(path);
    await file.writeAsString(jsonReport);
  }

  Future<void> _generateReport(String path, List<JsonFeature> features) async {
    try {
      final report = json.encode(_features);
      await onSaveReport(report);
    } catch (e) {
      print('Failed to generate json report: $e');
    }
  }

  JsonFeature _getCurrentFeature() {
    if (_features.isEmpty) {
      final feature = JsonFeature()
        ..name = 'Unnamed feature'
        ..description =
            'An unnamed feature is possible if something is logged before any feature has started to execute'
        ..scenarios = <JsonScenario>[
          JsonScenario()
            ..name = 'Unnamed'
            ..description =
                'An unnamed scenario is possible if something is logged before any feature has started to execute'
            ..line = 0
            ..tags = <JsonTag>[]
            ..steps = <JsonStep?>[
              JsonStep()
                ..name = 'Unnamed'
                ..line = 0
            ]
        ]
        ..line = 0
        ..tags = <JsonTag>[]
        ..uri = 'unknown';

      _features.add(feature);
    }

    return _features.last;
  }
}
