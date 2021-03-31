import '../messages.dart';
import 'json_scenario.dart';
import 'json_step.dart';
import 'json_tag.dart';

class JsonFeature {
  String? uri;
  String? id;
  String? name;
  String? description;
  int? line;
  late Iterable<JsonTag> tags;
  List<JsonScenario> scenarios = [];

  static JsonFeature from(StartedMessage message) {
    final feature = JsonFeature();
    feature.uri = message.context.filePath;
    feature.id = message.name!.toLowerCase();
    feature.name = message.name;
    feature.description = '';
    feature.line = message.context.nonZeroAdjustedLineNumber;
    feature.tags =
        message.tags.map((t) => JsonTag(t.name, t.nonZeroAdjustedLineNumber));

    return feature;
  }

  void add({
    required JsonScenario scenario,
  }) {
    scenario.feature = this;
    scenarios.add(scenario);
  }

  JsonScenario currentScenario() {
    if (scenarios.isEmpty) {
      final scenario = JsonScenario()
        ..name = 'Unnamed'
        ..description =
            'An unnamed scenario is possible if something is logged before any scenario steps have started to execute'
        ..line = 0
        ..tags = <JsonTag>[]
        ..steps = <JsonStep?>[
          JsonStep()
            ..name = 'Unnamed'
            ..line = 0
        ];

      scenarios.add(scenario);
    }

    return scenarios.last;
  }

  Map<String, dynamic> toJson() {
    final result = {
      'description': description,
      'id': id,
      'keyword': 'Feature',
      'line': line,
      'name': name,
      'uri': uri,
    };

    if (tags.isNotEmpty) {
      result['tags'] = tags.toList();
    }

    if (scenarios.isNotEmpty) {
      result['elements'] = scenarios.toList();
    }

    return result;
  }
}
