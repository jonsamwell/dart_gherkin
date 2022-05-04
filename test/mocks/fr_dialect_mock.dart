import 'package:gherkin/src/gherkin/languages/dialect.dart';

class FrDialectMock extends GherkinDialect {
  FrDialectMock()
      : super(
          name: 'English',
          nativeName: 'English',
          languageCode: 'en',
          feature: ['Fonctionnalité'],
          background: ['Contexte'],
          rule: ['Rule'],
          scenario: ['Exemple', 'Scénario'],
          scenarioOutline: ['Plan du scénario', 'Plan du Scénario'],
          examples: ['Exemples'],
          given: [
            '*',
            'Soit',
            'Sachant que',
            "Sachant qu'",
            'Sachant',
            'Etant donné que',
            "Etant donné qu'",
            'Etant donné',
            'Etant donnée',
            'Etant donnés',
            'Etant données',
            'Étant donné que',
            "Étant donné qu'",
            'Étant donné',
            'Étant donnée',
            'Étant donnés',
            'Étant données',
          ],
          when: [
            '*',
            'Quand',
            'Lorsque',
            "Lorsqu'",
          ],
          then: [
            '*',
            'Alors',
            'Donc',
          ],
          and: [
            '*',
            'Et que',
            "Et qu'",
            'Et',
          ],
          but: [
            '*',
            'Mais que',
            "Mais qu'",
            'Mais',
          ],
        );
}
