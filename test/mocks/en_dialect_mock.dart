import 'package:gherkin/src/gherkin/languages/dialect.dart';

class EnDialectMock extends GherkinDialect {
  EnDialectMock()
      : super(
          name: 'English',
          nativeName: 'English',
          languageCode: 'en',
          feature: ['Feature'],
          background: ['Background'],
          rule: ['Rule'],
          scenario: ['Scenario'],
          scenarioOutline: ['Scenario Outline'],
          examples: ['Scenarios', 'Examples'],
          given: ['Given'],
          when: ['When'],
          then: ['Then'],
          and: ['And'],
          but: ['But'],
        );
}
