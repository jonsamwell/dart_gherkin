import 'dart:convert';
import 'dart:io';
import '../messages.dart';
import '../reporter.dart';
import 'json_feature.dart';
import 'json_scenario.dart';
import 'json_step.dart';

class JsonReporter extends Reporter {
  String path;
  List<JsonFeature> _features = [];

  JsonReporter({this.path = './report.json'});

  @override
  Future<void> onFeatureStarted(StartedMessage message) async {
    _features.add(JsonFeature.from(message));
  }

  @override
  Future<void> onScenarioStarted(StartedMessage message) async {
    _features.last.add(scenario: JsonScenario.from(message));
  }

  @override
  Future<void> onStepStarted(StepStartedMessage message) async {
    _features.last.currentScenario().add(step: JsonStep.from(message));
  }

  @override
  Future<void> onStepFinished(StepFinishedMessage message) async {
    _features.last.currentScenario().currentStep().onFinish(message);
  }

  @override
  Future<void> onException(Exception exception, StackTrace stackTrace) async {
    _features.last
        .currentScenario()
        .currentStep()
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
      final report = json.encode(_features.toList());
      await onSaveReport(report);
    } catch (e) {
      print('Failed to generate json report: $e');
    }
  }
}
