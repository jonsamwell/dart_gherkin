import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/example.dart';
import 'package:gherkin/src/gherkin/syntax/example_syntax.dart';
import 'package:test/test.dart';

import '../../mocks/en_dialect_mock.dart';

void main() {
  group('isMatch', () {
    test('matches correctly', () {
      final syntax = ExampleSyntax();
      expect(
          syntax.isMatch(
            'Examples:',
            EnDialectMock(),
          ),
          true);
      expect(
          syntax.isMatch(
            'Examples: ',
            EnDialectMock(),
          ),
          true);
      expect(
          syntax.isMatch(
            'Examples: something',
            EnDialectMock(),
          ),
          true);
      expect(
          syntax.isMatch(
            ' Examples:   something',
            EnDialectMock(),
          ),
          true);
    });

    test('does not match', () {
      final syntax = ExampleSyntax();
      expect(
          syntax.isMatch(
            'Examples',
            EnDialectMock(),
          ),
          false);
      expect(
          syntax.isMatch(
            'Example something',
            EnDialectMock(),
          ),
          false);
      expect(
          syntax.isMatch(
            '#Examples: something',
            EnDialectMock(),
          ),
          false);
    });
  });

  group('toRunnable', () {
    test('creates Runnable', () {
      final syntax = ExampleSyntax();
      final runnable = syntax.toRunnable(
        'Examples: An example 123',
        RunnableDebugInformation(null, 0, null),
        EnDialectMock(),
      );
      expect(runnable, isNotNull);
      expect(runnable, predicate((dynamic x) => x is ExampleRunnable));
      expect(runnable.name, equals('An example 123'));
    });

    test('creates Runnable with empty name', () {
      final syntax = ExampleSyntax();
      final runnable = syntax.toRunnable(
        'Examples:   ',
        RunnableDebugInformation(null, 0, null),
        EnDialectMock(),
      );
      expect(runnable, isNotNull);
      expect(runnable, predicate((dynamic x) => x is ExampleRunnable));
      expect(runnable.name, equals(''));
    });

    test('creates Runnable with no name', () {
      final syntax = ExampleSyntax();
      final runnable = syntax.toRunnable(
        'Examples:',
        RunnableDebugInformation(null, 0, null),
        EnDialectMock(),
      );
      expect(runnable, isNotNull);
      expect(runnable, predicate((dynamic x) => x is ExampleRunnable));
      expect(runnable.name, equals(''));
    });
  });
}
