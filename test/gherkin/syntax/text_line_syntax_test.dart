import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/text_line.dart';
import 'package:gherkin/src/gherkin/syntax/text_line_syntax.dart';
import 'package:test/test.dart';

import '../../mocks/en_dialect_mock.dart';

void main() {
  group('isMatch', () {
    test('matches correctly', () {
      final syntax = TextLineSyntax();
      expect(
        syntax.isMatch(
          'Hello Jon',
          EnDialectMock(),
        ),
        true,
      );
      expect(
        syntax.isMatch(
          "Hello 'Jon'!",
          EnDialectMock(),
        ),
        true,
      );
      expect(
        syntax.isMatch(
          ' Hello Jon',
          EnDialectMock(),
        ),
        true,
      );
      expect(
        syntax.isMatch(
          '  Hello Jon',
          EnDialectMock(),
        ),
        true,
      );
      expect(
        syntax.isMatch(
          '   h ',
          EnDialectMock(),
        ),
        true,
      );
      expect(
        syntax.isMatch(
          '*',
          EnDialectMock(),
        ),
        true,
      );
      expect(
        syntax.isMatch(
          ' +  ',
          EnDialectMock(),
        ),
        true,
      );
    });

    test('does not match', () {
      final syntax = TextLineSyntax();
      expect(
        syntax.isMatch(
          '#Hello Jon',
          EnDialectMock(),
        ),
        false,
      );
      expect(
        syntax.isMatch(
          '# Hello Jon',
          EnDialectMock(),
        ),
        false,
      );
      expect(
        syntax.isMatch(
          '#  Hello Jon',
          EnDialectMock(),
        ),
        false,
      );
      expect(
        syntax.isMatch(
          '      ',
          EnDialectMock(),
        ),
        false,
      );
      expect(
        syntax.isMatch(
          ' #   h ',
          EnDialectMock(),
        ),
        false,
      );
    });
  });

  group('toRunnable', () {
    test('creates TextLineRunnable', () {
      final syntax = TextLineSyntax();
      final runnable = syntax.toRunnable(
        '  Some text ',
        RunnableDebugInformation.empty(),
        EnDialectMock(),
      );
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is TextLineRunnable));
      expect(runnable.text, equals('Some text'));
    });
  });
}
