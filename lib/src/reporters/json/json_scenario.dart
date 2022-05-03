import '../messages.dart';
import 'json_feature.dart';
import 'json_step.dart';
import 'json_tag.dart';

class JsonScenario {
  late final Target target;
  late final String name;
  late final String description;
  late final int line;
  late final List<JsonStep> steps;
  late final Iterable<JsonTag> tags;
  bool passed = true;
  JsonFeature? feature;

  static JsonScenario from(StartedMessage message) {
    final scenario = JsonScenario();
    scenario.target = message.target;
    scenario.name = message.name;
    scenario.description = '';
    scenario.line = message.context.nonZeroAdjustedLineNumber;
    scenario.tags = message.tags
        .where((t) => !t.isInherited)
        .map((t) => JsonTag(t.name, t.nonZeroAdjustedLineNumber))
        .toList();

    scenario.steps = <JsonStep>[];

    return scenario;
  }

  void add(JsonStep step) {
    steps.add(step);
    if (steps.last.status == 'failed' ||
        steps.last.status == 'error' ||
        steps.last.status == 'timeout') {
      passed = false;
    }
  }

  JsonStep currentStep() {
    if (steps.isEmpty) {
      final step = JsonStep()
        ..name = 'Unnamed'
        ..line = 0;

      steps.add(step);
    }

    return steps.last;
  }

  Map<String, dynamic> toJson() {
    final result = {
      'keyword':
          target == Target.scenario_outline ? 'Scenario Outline' : 'Scenario',
      'type': 'scenario',
      'id': '${feature?.id};${name.toLowerCase()}',
      'name': name,
      'description': description,
      'line': line,
      'passed': passed,
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
