import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/language.dart';
import 'package:gherkin/src/gherkin/syntax/language_syntax.dart';
import 'package:test/test.dart';

import '../../mocks/en_dialect_mock.dart';

void main() {
  group('isMatch', () {
    test('matches correctly', () {
      final keyword = LanguageSyntax();
      expect(
          keyword.isMatch(
            '# language: en',
            EnDialectMock(),
          ),
          true);
      expect(
          keyword.isMatch(
            '#language: fr',
            EnDialectMock(),
          ),
          true);
      expect(
          keyword.isMatch(
            '#language:de',
            EnDialectMock(),
          ),
          true);
    });

    test('does not match', () {
      final keyword = LanguageSyntax();
      expect(
          keyword.isMatch(
            '#language no',
            EnDialectMock(),
          ),
          false);
      expect(
          keyword.isMatch(
            '# language comment',
            EnDialectMock(),
          ),
          false);
    });
  });

  group('toRunnable', () {
    test('creates LanguageRunnable', () {
      final keyword = LanguageSyntax();
      final runnable = keyword.toRunnable(
        '# language: de',
        RunnableDebugInformation('', 0, null),
        EnDialectMock(),
      ) as LanguageRunnable;
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is LanguageRunnable));
      expect(runnable.language, equals('de'));
    });
  });
}
