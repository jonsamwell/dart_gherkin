class GherkinDialect {
  final String name;
  final String nativeName;
  final String? languageCode;
  final Iterable<String> feature;
  final Iterable<String> background;
  final Iterable<String> rule;
  final Iterable<String> scenario;
  final Iterable<String> scenarioOutline;
  final Iterable<String> examples;
  final Iterable<String> given;
  final Iterable<String> when;
  final Iterable<String> then;
  final Iterable<String> and;
  final Iterable<String> but;

  GherkinDialect({
    required this.name,
    required this.nativeName,
    required this.feature,
    required this.background,
    required this.rule,
    required this.scenario,
    required this.scenarioOutline,
    required this.examples,
    required this.given,
    required this.when,
    required this.then,
    required this.and,
    required this.but,
    this.languageCode,
  });

  Set<String> get stepKeywords => {
        ...given,
        ...when,
        ...then,
        ...and,
        ...but,
      };

  factory GherkinDialect.fromJson(Map<String, dynamic> map) {
    final given = map['given'] as List<String>;
    final when = map['when'] as List<String>;
    final then = map['then'] as List<String>;
    final and = map['and'] as List<String>;
    final but = map['but'] as List<String>;
    return GherkinDialect(
      name: map['name'] as String,
      nativeName: map['native'] as String,
      feature: map['feature'] as List<String>,
      background: map['background'] as List<String>,
      rule: map['rule'] as List<String>,
      scenario: map['scenario'] as List<String>,
      scenarioOutline: map['scenarioOutline'] as List<String>,
      examples: map['examples'] as List<String>,
      given: given,
      when: when,
      then: then,
      and: and,
      but: but,
    );
  }

  GherkinDialect copyWith({
    String? name,
    String? nativeName,
    String? languageCode,
    Iterable<String>? feature,
    Iterable<String>? background,
    Iterable<String>? rule,
    Iterable<String>? scenario,
    Iterable<String>? scenarioOutline,
    Iterable<String>? examples,
    Iterable<String>? given,
    Iterable<String>? when,
    Iterable<String>? then,
    Iterable<String>? and,
    Iterable<String>? but,
  }) {
    return GherkinDialect(
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      languageCode: languageCode ?? this.languageCode,
      feature: feature ?? this.feature,
      background: background ?? this.background,
      rule: rule ?? this.rule,
      scenario: scenario ?? this.scenario,
      scenarioOutline: scenarioOutline ?? this.scenarioOutline,
      examples: examples ?? this.examples,
      given: given ?? this.given,
      when: when ?? this.when,
      then: then ?? this.then,
      and: and ?? this.and,
      but: but ?? this.but,
    );
  }
}
