class GherkinDialect {
  String? name;
  String? nativeName;
  String? languageCode;
  Iterable<String>? feature;
  Iterable<String>? background;
  Iterable<String>? rule;
  Iterable<String>? scenario;
  Iterable<String>? scenarioOutline;
  Iterable<String>? examples;
  Iterable<String>? given;
  Iterable<String>? when;
  Iterable<String>? then;
  Iterable<String>? and;
  Iterable<String>? but;

  late Set<String> stepKeywords;

  static GherkinDialect fromJSON(Map<String, dynamic> map) {
    final dialect = GherkinDialect();
    dialect.name = map['name'];
    dialect.nativeName = map['native'];
    dialect.feature = (map['feature'] as List?)?.map((e) => e as String);
    dialect.background = (map['background'] as List?)?.map((e) => e as String);
    dialect.rule = (map['rule'] as List?)?.map((e) => e as String);
    dialect.scenario = (map['scenario'] as List?)?.map((e) => e as String);
    dialect.scenarioOutline =
        (map['scenarioOutline'] as List?)?.map((e) => e as String);
    dialect.examples = (map['examples'] as List?)?.map((e) => e as String);
    dialect.given = (map['given'] as List?)?.map((e) => e as String);
    dialect.when = (map['when'] as List?)?.map((e) => e as String);
    dialect.then = (map['then'] as List?)?.map((e) => e as String);
    dialect.and = (map['and'] as List?)?.map((e) => e as String);
    dialect.but = (map['but'] as List?)?.map((e) => e as String);

    dialect.stepKeywords = (<String>[
      ...dialect.given!,
      ...dialect.when!,
      ...dialect.then!,
      ...dialect.and!,
      ...dialect.but!
    ]).toSet();

    return dialect;
  }
}
