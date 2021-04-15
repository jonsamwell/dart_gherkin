class GherkinDialect {
  late String name;
  late String nativeName;
  late String languageCode;
  late Iterable<String> feature;
  late Iterable<String> background;
  late Iterable<String> rule;
  late Iterable<String> scenario;
  late Iterable<String> scenarioOutline;
  late Iterable<String> examples;
  late Iterable<String> given;
  late Iterable<String> when;
  late Iterable<String> then;
  late Iterable<String> and;
  late Iterable<String> but;
  late Set<String> stepKeywords;

  static GherkinDialect fromJSON(Map<String, dynamic> map) {
    final dialect = GherkinDialect();
    dialect.name = map['name'];
    dialect.nativeName = map['native'];
    dialect.feature = map['feature'] as List<String>;
    dialect.background = map['background'] as List<String>;
    dialect.rule = map['rule'] as List<String>;
    dialect.scenario = map['scenario'] as List<String>;
    dialect.scenarioOutline = map['scenarioOutline'] as List<String>;
    dialect.examples = map['examples'] as List<String>;
    dialect.given = map['given'] as List<String>;
    dialect.when = map['when'] as List<String>;
    dialect.then = map['then'] as List<String>;
    dialect.and = map['and'] as List<String>;
    dialect.but = map['but'] as List<String>;

    dialect.stepKeywords = (<String>[
      ...dialect.given,
      ...dialect.when,
      ...dialect.then,
      ...dialect.and,
      ...dialect.but
    ]).toSet();

    return dialect;
  }
}
