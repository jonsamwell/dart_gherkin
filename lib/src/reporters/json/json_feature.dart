import '../messages.dart';
import 'json_scenario.dart';
import 'json_tag.dart';

class JsonFeature {
  final String uri;
  final String name;
  final String description;
  final int line;
  final String? id;
  final Iterable<JsonTag> tags;
  List<JsonScenario> scenarios;

  // TODO(shigomany): Maybe immutable?
  JsonFeature({
    required this.uri,
    required this.name,
    required this.line,
    this.description = '',
    this.id,
    List<JsonScenario>? scenarios,
    Iterable<JsonTag>? tags,
  })  : scenarios = scenarios ?? [],
        tags = tags ?? [];

  /// Convert [StartedMessage] to [JsonFeature]
  static JsonFeature from(StartedMessage message) {
    final feature = JsonFeature(
      uri: message.context.filePath,
      id: message.name.toLowerCase(),
      name: message.name,
      line: message.context.nonZeroAdjustedLineNumber,
      tags: message.tags.map((t) => JsonTag.fromMessageTag(t)),
    );

    return feature;
  }

  /// Create [JsonFeature] with empty fields and
  /// has one [JsonScenario.empty] in [scenarios]
  static JsonFeature get empty => JsonFeature(
        name: 'Unnamed feature',
        description: 'An unnamed feature is possible '
            'if something is logged before any feature has started to execute',
        scenarios: [JsonScenario.empty],
        line: 0,
        uri: 'unknown',
      );

  /// Add scenario in [scenarios] and
  /// sets the reference [scenario.feature] on this.
  void add(JsonScenario scenario) {
    scenario.feature = this;
    scenarios.add(scenario);
  }

  /// Returns the [scenarios.last] if [scenarios.isEmpty]
  /// otherwise adds the [JsonScenario.empty] value to the [scenarios]
  JsonScenario get currentScenario {
    if (scenarios.isEmpty) {
      scenarios.add(JsonScenario.empty);
    }

    return scenarios.last;
  }

  Map<String, Object?> toJson() {
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
