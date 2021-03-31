import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/scenario.dart';
import 'package:gherkin/src/gherkin/syntax/scenario_syntax.dart';
import 'package:test/test.dart';

import '../../mocks/en_dialect_mock.dart';

void main() {
  group('isMatch', () {
    test('matches correctly', () {
      final syntax = ScenarioSyntax();
      expect(
          syntax.isMatch(
            'Scenario: something',
            EnDialectMock(),
          ),
          true);
      expect(
          syntax.isMatch(
            ' Scenario:   something',
            EnDialectMock(),
          ),
          true);
    });

    test('does not match', () {
      final syntax = ScenarioSyntax();
      expect(
          syntax.isMatch(
            'Scenario something',
            EnDialectMock(),
          ),
          false);
      expect(
          syntax.isMatch(
            '#Scenario: something',
            EnDialectMock(),
          ),
          false);
    });
  });

  group('toRunnable', () {
    test('creates FeatureRunnable', () {
      final keyword = ScenarioSyntax();
      var keyword2 = keyword;
      final runnable = keyword2.toRunnable(
        'Scenario: A scenario 123',
        RunnableDebugInformation(null, 0, null),
        EnDialectMock(),
      );
      expect(runnable, isNotNull);
      expect(runnable, predicate((dynamic x) => x is ScenarioRunnable));
      expect(runnable.name, equals('A scenario 123'));
    });
  });
}
