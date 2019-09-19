import 'package:gherkin/src/gherkin/langauges/dialect.dart';

class EnDialectMock extends GherkinDialect {
  EnDialectMock() {
    name = 'English';
    nativeName = name;
    feature = ['Feature'];
    background = ['Background'];
    rule = ['Rule'];
    scenario = ['Scenario'];
    scenarioOutline = ['Scenario Outline'];
    examples = ['Scenarios', 'Examples'];
    given = ['Given'];
    when = ['When'];
    then = ['Then'];
    and = ['And'];
    but = ['But'];

    stepKeywords = (<String>[]
          ..addAll(given)
          ..addAll(when)
          ..addAll(then)
          ..addAll(and)
          ..addAll(but))
        .toSet();
  }
}
