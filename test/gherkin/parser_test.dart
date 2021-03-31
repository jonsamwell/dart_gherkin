import 'package:gherkin/src/gherkin/parser.dart';
import 'package:gherkin/src/gherkin/runnables/tags.dart';
import 'package:test/test.dart';
import '../mocks/language_service_mock.dart';
import '../mocks/reporter_mock.dart';

Iterable<String> tagsToList(Iterable<TagsRunnable?> tags) sync* {
  for (var tgs in tags) {
    for (var tag in tgs!.tags!) {
      yield tag;
    }
  }
}

void main() {
  group('parse', () {
    test('parses simple, single scenario correctly', () async {
      final parser = GherkinParser();
      final featureContents = """
      # language: en
      @primary_tag_one
      @primary_tag_two
      Feature: The name of the feature
        A multiline line description
        Line two
        Line three

        Background: Some background
          Given I setup 1
          And I setup 2

        @smoke
        @some_another_tag
        Scenario: When the user does some steps they see 'd'
          Given I do step a
          And I do step b
          And I add the comment
          '''
          A multiline
          comment
          '''
          When I do step c
          Then I expect to see d
      """;
      final featureFile = await parser.parseFeatureFile(
        featureContents,
        '',
        ReporterMock(),
        LanguageServiceMock(),
      );
      expect(featureFile, isNot(null));
      expect(featureFile.language, equals('en'));
      expect(featureFile.features.length, 1);

      final feature = featureFile.features.elementAt(0)!;
      expect(feature.name, 'The name of the feature');
      expect(feature.description,
          'A multiline line description\nLine two\nLine three');
      expect(tagsToList(feature.tags),
          <String>['@primary_tag_one', '@primary_tag_two']);
      expect(feature.scenarios.length, 1);

      final background = featureFile.features.elementAt(0)!.background!;
      expect(background.name, 'Some background');
      expect(background.steps.length, 2);
      expect(background.steps.elementAt(0)!.name, 'Given I setup 1');
      expect(background.steps.elementAt(1)!.name, 'And I setup 2');

      final scenario = featureFile.features.elementAt(0)!.scenarios.elementAt(0)!;
      expect(tagsToList(scenario.tags), <String>[
        '@primary_tag_one',
        '@primary_tag_two',
        '@smoke',
        '@some_another_tag'
      ]);
      expect(scenario.name, "When the user does some steps they see 'd'");
      expect(scenario.steps.length, 5);

      final steps = scenario.steps;
      expect(steps.elementAt(0)!.name, 'Given I do step a');
      expect(steps.elementAt(1)!.name, 'And I do step b');
      expect(steps.elementAt(2)!.name, 'And I add the comment');
      expect(steps.elementAt(3)!.name, 'When I do step c');
      expect(steps.elementAt(4)!.name, 'Then I expect to see d');

      final commentStep = steps.elementAt(2)!;
      expect(commentStep.multilineStrings.length, 1);
      expect(commentStep.multilineStrings.elementAt(0), 'A multiline\ncomment');
    });

    test('parses feature description with non-alpha numeric characters',
        () async {
      final parser = GherkinParser();
      final featureContents = """
      Feature: Conway's Game of Life

        Rules of Conway's Game of Life
        > The universe of the _Game of Life_ is an infinite, two-dimensional orthogonal grid of square cells.

        Scenario: Empty universe
          Given the following universe:
          '''

          *

          abc

          '''
          And the following universe:
          '''
          *
          '''
      """;
      final featureFile = await parser.parseFeatureFile(
        featureContents,
        '',
        ReporterMock(),
        LanguageServiceMock(),
      );
      expect(featureFile, isNot(null));
      expect(featureFile.language, equals('en'));
      expect(featureFile.features.length, 1);

      final feature = featureFile.features.elementAt(0)!;
      expect(feature.name, 'Conway\'s Game of Life');
      expect(feature.description,
          'Rules of Conway\'s Game of Life\n> The universe of the _Game of Life_ is an infinite, two-dimensional orthogonal grid of square cells.');
      expect(feature.scenarios.length, 1);

      final scenario = featureFile.features.elementAt(0)!.scenarios.elementAt(0)!;
      expect(scenario.steps.length, 2);

      final steps = scenario.steps;
      expect(steps.elementAt(0)!.name, 'Given the following universe:');
      expect(steps.elementAt(0)!.multilineStrings.elementAt(0), '\n*\n\nabc\n');

      expect(steps.elementAt(1)!.name, 'And the following universe:');
      expect(steps.elementAt(1)!.multilineStrings.elementAt(0), '*');
    });

    test('parses single scenario with no names', () async {
      final parser = GherkinParser();
      final featureContents = """
      # language: en
      Feature: The name of the feature
        A multiine line description
        Line two
        Line three

        Background:
          Given I setup 1
          And I setup 2

        @smoke
        Scenario: When the user does some steps they see 'd'
          Given I do step a
          And I do step b
          And I add the comment
          '''
          A multiline
          comment
          '''
          When I do step c
          Then I expect to see d
      """;
      final featureFile = await parser.parseFeatureFile(
        featureContents,
        '',
        ReporterMock(),
        LanguageServiceMock(),
      );
      expect(featureFile, isNot(null));
      expect(featureFile.language, equals('en'));
      expect(featureFile.features.length, 1);

      final feature = featureFile.features.elementAt(0)!;
      expect(feature.name, 'The name of the feature');
      expect(feature.description,
          'A multiine line description\nLine two\nLine three');
      expect(feature.scenarios.length, 1);

      final background = featureFile.features.elementAt(0)!.background!;
      expect(background.name, '');
      expect(background.steps.length, 2);
      expect(background.steps.elementAt(0)!.name, 'Given I setup 1');
      expect(background.steps.elementAt(1)!.name, 'And I setup 2');

      final scenario = featureFile.features.elementAt(0)!.scenarios.elementAt(0)!;
      expect(tagsToList(scenario.tags), ['@smoke']);
      expect(scenario.name, "When the user does some steps they see 'd'");
      expect(scenario.steps.length, 5);

      final steps = scenario.steps;
      expect(steps.elementAt(0)!.name, 'Given I do step a');
      expect(steps.elementAt(1)!.name, 'And I do step b');
      expect(steps.elementAt(2)!.name, 'And I add the comment');
      expect(steps.elementAt(3)!.name, 'When I do step c');
      expect(steps.elementAt(4)!.name, 'Then I expect to see d');

      final commentStep = steps.elementAt(2)!;
      expect(commentStep.multilineStrings.length, 1);
      expect(commentStep.multilineStrings.elementAt(0), 'A multiline\ncomment');
    });

    test('parses single scenario outline with multiple examples', () async {
      final parser = GherkinParser();
      final featureContents = '''
      Feature: The name of the feature
        Background: Setup
          Given I setup 1
          And I setup 2

        @smoke
        Scenario Outline: Eating
          Given there are <start> cucumbers
          When I eat <eat> cucumbers
          Then I should have <left> cucumbers

          Examples: First set
            | start | eat | left |
            |    12 |   5 |    7 |
            |    20 |   9 |   11 |

          @second
          Examples: Second set
            | start | eat | left |
            |    12 |   5 |    7 |
            |    20 |   9 |   11 |
            |    32 |  14 |   18 |
      ''';
      final featureFile = await parser.parseFeatureFile(
        featureContents,
        '',
        ReporterMock(),
        LanguageServiceMock(),
      );
      expect(featureFile, isNot(null));
      expect(featureFile.language, equals('en'));
      expect(featureFile.features.length, 1);

      final feature = featureFile.features.elementAt(0)!;
      expect(feature.name, 'The name of the feature');
      expect(feature.scenarios.length, 5);

      final background = featureFile.features.elementAt(0)!.background!;
      expect(background.name, 'Setup');
      expect(background.steps.length, 2);
      expect(background.steps.elementAt(0)!.name, 'Given I setup 1');
      expect(background.steps.elementAt(1)!.name, 'And I setup 2');

      final scenario = featureFile.features.elementAt(0)!.scenarios.elementAt(0)!;
      expect(scenario.name, 'Eating Examples: First set (1)');
      expect(tagsToList(scenario.tags), ['@smoke']);
      expect(scenario.steps.length, 3);

      final scenario2 =
          featureFile.features.elementAt(0)!.scenarios.elementAt(1)!;
      expect(scenario2.name, 'Eating Examples: First set (2)');
      expect(tagsToList(scenario2.tags), ['@smoke']);
      expect(scenario2.steps.length, 3);

      final scenario3 =
          featureFile.features.elementAt(0)!.scenarios.elementAt(2)!;
      expect(scenario3.name, 'Eating Examples: Second set (1)');
      expect(tagsToList(scenario3.tags), ['@smoke', '@second']);
      expect(scenario3.steps.length, 3);

      expect(scenario.steps.elementAt(0)!.name, 'Given there are 12 cucumbers');
      expect(scenario.steps.elementAt(1)!.name, 'When I eat 5 cucumbers');
      expect(
          scenario.steps.elementAt(2)!.name, 'Then I should have 7 cucumbers');

      expect(scenario2.steps.elementAt(0)!.name, 'Given there are 20 cucumbers');
      expect(scenario2.steps.elementAt(1)!.name, 'When I eat 9 cucumbers');
      expect(
          scenario2.steps.elementAt(2)!.name, 'Then I should have 11 cucumbers');

      expect(scenario3.steps.elementAt(0)!.name, 'Given there are 12 cucumbers');
      expect(scenario3.steps.elementAt(1)!.name, 'When I eat 5 cucumbers');
      expect(
          scenario3.steps.elementAt(2)!.name, 'Then I should have 7 cucumbers');
    });

    test(
        'parses scenario outline and another scenario in the same feature file',
        () async {
      final parser = GherkinParser();
      final featureContents = '''
      Feature: The name of the feature
        Background: Setup
          Given I setup 1
          And I setup 2

        @smoke
        Scenario Outline: Eating
          Given there are <start> cucumbers
          When I eat <eat> cucumbers
          Then I should have <left> cucumbers

          Examples:
            | start | eat | left |
            |    12 |   5 |    7 |
            |    20 |   9 |   11 |

        Scenario: More eating
          Given there are 2 cucumbers
          When I eat 2 cucumbers
          Then I should have 0 cucumbers
      ''';
      final featureFile = await parser.parseFeatureFile(
        featureContents,
        '',
        ReporterMock(),
        LanguageServiceMock(),
      );
      expect(featureFile, isNot(null));
      expect(featureFile.language, equals('en'));
      expect(featureFile.features.length, 1);

      final feature = featureFile.features.elementAt(0)!;
      expect(feature.name, 'The name of the feature');
      expect(feature.scenarios.length, 3);

      final background = featureFile.features.elementAt(0)!.background!;
      expect(background.name, 'Setup');
      expect(background.steps.length, 2);
      expect(background.steps.elementAt(0)!.name, 'Given I setup 1');
      expect(background.steps.elementAt(1)!.name, 'And I setup 2');

      final scenario = featureFile.features.elementAt(0)!.scenarios.elementAt(0)!;
      expect(scenario.name, 'Eating Examples: (1)');
      expect(tagsToList(scenario.tags), ['@smoke']);
      expect(scenario.steps.length, 3);

      final scenario2 =
          featureFile.features.elementAt(0)!.scenarios.elementAt(1)!;
      expect(scenario2.name, 'Eating Examples: (2)');
      expect(tagsToList(scenario2.tags), ['@smoke']);
      expect(scenario2.steps.length, 3);

      expect(scenario.steps.elementAt(0)!.name, 'Given there are 12 cucumbers');
      expect(scenario.steps.elementAt(1)!.name, 'When I eat 5 cucumbers');
      expect(
          scenario.steps.elementAt(2)!.name, 'Then I should have 7 cucumbers');

      expect(scenario2.steps.elementAt(0)!.name, 'Given there are 20 cucumbers');
      expect(scenario2.steps.elementAt(1)!.name, 'When I eat 9 cucumbers');
      expect(
          scenario2.steps.elementAt(2)!.name, 'Then I should have 11 cucumbers');

      final scenario3 =
          featureFile.features.elementAt(0)!.scenarios.elementAt(2)!;
      expect(scenario3.name, 'More eating');
      expect(scenario3.steps.elementAt(0)!.name, 'Given there are 2 cucumbers');
      expect(scenario3.steps.elementAt(1)!.name, 'When I eat 2 cucumbers');
      expect(
          scenario3.steps.elementAt(2)!.name, 'Then I should have 0 cucumbers');
    });

    test('parses complex multi-scenario correctly', () async {
      final parser = GherkinParser();
      final featureContents = """
      # language: en
      Feature: The name of the feature
        A multiine line description
        Line two
        Line three

        Background: Some background
          Given I setup 1
          And I setup 2

        @smoke
        Scenario: When the user does some steps they see 'd'
          Given I do step a
          And I do step b
          And I add the comment
          '''
          A mutliline
          comment
          '''
          And I add the people
          | Firstname | Surname | Age | Gender |
          | Woody     | Johnson | 28  | Male   |
          | Edith     | Summers | 23  | Female |
          | Megan     | Hill    | 83  | Female |
          When I do step c
          # ignore the below step
          # When I do step c.1
          Then I expect to see d
      """;
      final featureFile = await parser.parseFeatureFile(
        featureContents,
        '',
        ReporterMock(),
        LanguageServiceMock(),
      );
      expect(featureFile, isNot(null));
      expect(featureFile.language, equals('en'));
      expect(featureFile.features.length, 1);

      final feature = featureFile.features.elementAt(0)!;
      expect(feature.name, 'The name of the feature');
      expect(feature.description,
          'A multiine line description\nLine two\nLine three');
      expect(feature.scenarios.length, 1);

      final background = featureFile.features.elementAt(0)!.background!;
      expect(background.name, 'Some background');
      expect(background.steps.length, 2);
      expect(background.steps.elementAt(0)!.name, 'Given I setup 1');
      expect(background.steps.elementAt(1)!.name, 'And I setup 2');

      final scenario = featureFile.features.elementAt(0)!.scenarios.elementAt(0)!;
      expect(scenario.name, "When the user does some steps they see 'd'");
      expect(tagsToList(scenario.tags), ['@smoke']);
      expect(scenario.steps.length, 6);

      final steps = scenario.steps;
      expect(steps.elementAt(0)!.name, 'Given I do step a');
      expect(steps.elementAt(1)!.name, 'And I do step b');
      expect(steps.elementAt(2)!.name, 'And I add the comment');
      expect(steps.elementAt(3)!.name, 'And I add the people');
      expect(steps.elementAt(4)!.name, 'When I do step c');
      expect(steps.elementAt(5)!.name, 'Then I expect to see d');

      expect(steps.elementAt(3)!.table, isNotNull);
      expect(steps.elementAt(3)!.table!.header, isNotNull);
      expect(steps.elementAt(3)!.table!.header!.columns,
          ['Firstname', 'Surname', 'Age', 'Gender']);
      expect(steps.elementAt(3)!.table!.rows!.elementAt(0).columns.toList(),
          ['Woody', 'Johnson', '28', 'Male']);
      expect(steps.elementAt(3)!.table!.rows!.elementAt(1).columns.toList(),
          ['Edith', 'Summers', '23', 'Female']);
      expect(steps.elementAt(3)!.table!.rows!.elementAt(2).columns.toList(),
          ['Megan', 'Hill', '83', 'Female']);

      final commentStep = steps.elementAt(2)!;
      expect(commentStep.multilineStrings.length, 1);
      expect(commentStep.multilineStrings.elementAt(0), 'A mutliline\ncomment');
    });
  });
}
