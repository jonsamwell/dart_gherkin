import '../messages/messages.dart';
import 'json_feature.dart';
import 'json_step.dart';
import 'json_tag.dart';

class JsonScenario {
  /// Target type
  final Target target;

  /// Scenario name
  final String name;

  /// Optional description. Default: ''
  final String description;

  final int line;

  /// Filtering tags above the scenario
  final Iterable<JsonTag> tags;

  /// Scenario steps
  List<JsonStep> steps;

  //TODO(Shigomany): Make immutable class (final feature)
  JsonScenario({
    required this.target,
    required this.name,
    required this.line,
    this.description = '',
    this.feature,
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
        line: message.context.nonZeroAdjustedLineNumber,
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

  /// Add [step] in [steps]
  void add(JsonStep step) => steps.add(step);

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
      'description': description,
      'line': line,
    };

    if (tags.isNotEmpty) {
      result['tags'] = tags.toList();
    }

    if (steps.isNotEmpty) {
      result['steps'] = steps.toList();
    }

    return result;
  }
}
