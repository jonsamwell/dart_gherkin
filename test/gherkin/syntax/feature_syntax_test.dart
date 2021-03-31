import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/feature.dart';
import 'package:gherkin/src/gherkin/syntax/feature_syntax.dart';
import 'package:test/test.dart';

import '../../mocks/en_dialect_mock.dart';

void main() {
  group('isMatch', () {
    test('matches correctly', () {
      final keyword = FeatureSyntax();
      expect(
          keyword.isMatch(
            'Feature: one',
            EnDialectMock(),
          ),
          true);
      expect(
          keyword.isMatch(
            'Feature:one',
            EnDialectMock(),
          ),
          true);
    });

    test('does not match', () {
      final keyword = FeatureSyntax();
      expect(
          keyword.isMatch(
            '#Feature: no',
            EnDialectMock(),
          ),
          false);
      expect(
          keyword.isMatch(
            '# Feature no',
            EnDialectMock(),
          ),
          false);
    });
  });

  group('toRunnable', () {
    test('creates FeatureRunnable', () {
      final keyword = FeatureSyntax();
      final runnable = keyword.toRunnable(
        'Feature: A feature 123',
        RunnableDebugInformation(null, 0, null),
        EnDialectMock(),
      );
      expect(runnable, isNotNull);
      expect(runnable, predicate((dynamic x) => x is FeatureRunnable));
      expect(runnable.name, equals('A feature 123'));
    });
  });
}
