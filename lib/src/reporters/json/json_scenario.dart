import '../messages.dart';
import 'json_feature.dart';
import 'json_step.dart';
import 'json_tag.dart';

class JsonScenario {
  Target? target;
  JsonFeature? feature;
  String? name;
  String? description;
  int? line;
  List<JsonStep>? steps = [];
  Iterable<JsonTag>? tags;

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

    return scenario;
  }

  void add({required JsonStep step}) {
    steps?.add(step);
  }

  JsonStep? currentStep() {
    if (steps?.isEmpty ?? false) {
      final step = JsonStep()
        ..name = 'Unnamed'
        ..line = 0;

      steps?.add(step);
    }

    return steps?.last;
  }

  Map<String, dynamic> toJson() {
    final result = {
      'keyword':
          target == Target.scenario_outline ? 'Scenario Outline' : 'Scenario',
      'type': 'scenario',
      'id': '${feature?.id};${name?.toLowerCase()}',
      'name': name,
      'description': description,
      'line': line,
    };

    if (tags?.isNotEmpty ?? false) {
      result['tags'] = tags!.toList();
    }

    if (steps?.isNotEmpty ?? false) {
      result['steps'] = steps!.toList();
    }

    return result;
  }
}
