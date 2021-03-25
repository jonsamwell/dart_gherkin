import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/scenario.dart';
import 'package:gherkin/src/gherkin/syntax/scenario_outline_syntax.dart';
import 'package:test/test.dart';

import '../../mocks/en_dialect_mock.dart';

void main() {
  group('isMatch', () {
    test('matches correctly', () {
      final syntax = ScenarioOutlineSyntax();
      expect(
          syntax.isMatch(
            'Scenario outline:',
            EnDialectMock(),
          ),
          true);
      expect(
          syntax.isMatch(
            'Scenario outline:   ',
            EnDialectMock(),
          ),
          true);
      expect(
          syntax.isMatch(
            'Scenario outline: something',
            EnDialectMock(),
          ),
          true);
      expect(
          syntax.isMatch(
            ' Scenario Outline:   something',
            EnDialectMock(),
          ),
          true);
    });

    test('does not match', () {
      final syntax = ScenarioOutlineSyntax();
      expect(
          syntax.isMatch(
            'Scenario outline something',
            EnDialectMock(),
          ),
          false);
      expect(
          syntax.isMatch(
            '#Scenario Outline: something',
            EnDialectMock(),
          ),
          false);
    });
  });

  group('toRunnable', () {
    test('creates FeatureRunnable', () {
      final keyword = ScenarioOutlineSyntax();
      final runnable = keyword.toRunnable(
        'Scenario Outline: A scenario outline 123',
        RunnableDebugInformation(null, 0, null),
        EnDialectMock(),
      );
      expect(runnable, isNotNull);
      expect(runnable, predicate((dynamic x) => x is ScenarioRunnable));
      expect(runnable.name, equals('A scenario outline 123'));
    });
  });
}
