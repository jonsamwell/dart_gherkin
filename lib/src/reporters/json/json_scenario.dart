import '../../gherkin/steps/step_run_result.dart';
import '../messages/messages.dart';
import 'json_feature.dart';
import 'json_statuses.dart';
import 'json_step.dart';
import 'json_tag.dart';

class JsonScenario {
  bool? passed;

  /// Target type
  final Target target;

  /// Scenario name
  final String name;

  final String? description;

  final int line;

  void add(JsonStep step) {
    steps.add(step);
  }

  void onStepFinish(StepMessage message) {
    switch (message.result?.result) {
      case null:
      case StepExecutionResult.passed:
      case StepExecutionResult.skipped:
        break;
      case StepExecutionResult.fail:
      case StepExecutionResult.timeout:
      case StepExecutionResult.error:
        passed = false;
        break;
    }

    currentStep.onFinish(message);
  }

  /// Filtering tags above the scenario
  final Iterable<JsonTag> tags;

  /// Scenario steps
  List<JsonStep> steps;

  JsonScenario({
    required this.target,
    required this.name,
    required this.line,
    this.description,
    this.feature,
    this.passed,
    List<JsonStep>? steps,
    Iterable<JsonTag>? tags,
  })  : steps = steps ?? [],
        tags = tags ?? [];

  /// Parent feature
  JsonFeature? feature;

  /// Convert [StartedMessage] to [JsonScenario].
  ///
  /// Only those [message.tags] with the `isInherited` flag are converted
  static JsonScenario from(ScenarioMessage message) => JsonScenario(
        target: message.target,
        name: message.name,
        description: message.description,
        line: message.context.nonZeroAdjustedLineNumber,
        passed: message.hasPassed,
        tags: message.tags
            .where((t) => !t.isInherited)
            .map((t) => JsonTag.fromMessageTag(t))
            .toList(),
      );

  /// Empty [JsonScenario] with one step [JsonStep.empty]
  static JsonScenario get empty => JsonScenario(
        target: Target.scenario,
        name: 'Unnamed',
        description: 'An unnamed scenario is possible '
            'if something is logged before any feature has started to execute',
        line: 0,
        steps: [
          JsonStep.empty,
        ],
      );

  /// Returns the [steps.last] if [steps.isEmpty]
  /// otherwise adds the [JsonStep.empty] value to the [steps]
  JsonStep get currentStep {
    if (steps.isEmpty) {
      steps.add(JsonStep.empty);
    }

    return steps.last;
  }

  Map<String, Object?> toJson() {
    final result = {
      'keyword':
          target == Target.scenarioOutline ? 'Scenario Outline' : 'Scenario',
      'type': 'scenario',
      'id': '${feature?.id};${name.toLowerCase()}',
      'name': name,
      'line': line,
      'status': _calculateStatus()
    };

    if (description?.isNotEmpty ?? false) {
      result['description'] = description!;
    }

    if (tags.isNotEmpty) {
      result['tags'] = tags.toList();
    }

    if (steps.isNotEmpty) {
      result['steps'] = steps.toList();
    }

    return result;
  }

  String _calculateStatus() {
    if (steps.isEmpty) {
      return JsonStatus.skipped;
    }

    return steps.where((x) => x.status == JsonStatus.failed).isNotEmpty
        ? JsonStatus.failed
        : JsonStatus.passed;
  }
}
