import '../messages.dart';
import 'json_scenario.dart';
import 'json_tag.dart';

class JsonFeature {
  String uri;
  String id;
  String name;
  String description;
  int line;
  Iterable<JsonTag> tags;
  List<JsonScenario> scenarios = [];

  static JsonFeature from(StartedMessage message) {
    final feature = JsonFeature();
    feature.uri = message.context.filePath;
    feature.id = message.name.toLowerCase();
    feature.name = message.name;
    feature.description = '';
    feature.line = message.context.lineNumber;
    feature.tags = message.tags.map((t) => JsonTag(t.name, t.lineNumber));

    return feature;
  }

  void add({JsonScenario scenario}) {
    scenario.feature = this;
    scenarios.add(scenario);
  }

  JsonScenario currentScenario() {
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

    if (scenarios.isNotEmpty) {
      result['elements'] = scenarios.toList();
    }

    if (tags.isNotEmpty) {
      result['tags'] = tags.toList();
    }

    return result;
  }
}
