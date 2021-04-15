import '../messages.dart';
import 'json_scenario.dart';
import 'json_step.dart';
import 'json_tag.dart';

class JsonFeature {
  late final String uri;
  late final String name;
  late final String description;
  late final int line;
  String? id;
  Iterable<JsonTag>? tags;
  List<JsonScenario>? scenarios;

  static JsonFeature from(StartedMessage message) {
    final feature = JsonFeature();
    feature.uri = message.context.filePath;
    feature.id = message.name.toLowerCase();
    feature.name = message.name;
    feature.description = '';
    feature.line = message.context.nonZeroAdjustedLineNumber;
    feature.tags =
        message.tags.map((t) => JsonTag(t.name, t.nonZeroAdjustedLineNumber));

    return feature;
  }

  void add(
    JsonScenario scenario,
  ) {
    scenario.feature = this;
    scenarios ??= <JsonScenario>[];
    scenarios?.add(scenario);
  }

  JsonScenario currentScenario() {
    if (scenarios == null || scenarios!.isEmpty) {
      final scenario = JsonScenario()
        ..target = Target.scenario
        ..name = 'Unnamed'
        ..description =
            'An unnamed scenario is possible if something is logged before any scenario steps have started to execute'
        ..line = 0
        ..tags = <JsonTag>[]
        ..steps = <JsonStep>[
          JsonStep()
            ..name = 'Unnamed'
            ..line = 0
        ];

      scenarios = (scenarios ?? [])..add(scenario);
    }

    return scenarios!.last;
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

    if (tags != null && tags!.isNotEmpty) {
      result['tags'] = tags!.toList();
    }

    if (scenarios != null && scenarios!.isNotEmpty) {
      result['elements'] = scenarios!.toList();
    }

    return result;
  }
}
