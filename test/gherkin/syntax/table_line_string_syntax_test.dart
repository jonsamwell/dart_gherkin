import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/table.dart';
import 'package:gherkin/src/gherkin/syntax/comment_syntax.dart';
import 'package:gherkin/src/gherkin/syntax/multiline_string_syntax.dart';
import 'package:gherkin/src/gherkin/syntax/step_syntax.dart';
import 'package:gherkin/src/gherkin/syntax/table_line_syntax.dart';
import 'package:test/test.dart';

import '../../mocks/en_dialect_mock.dart';

void main() {
  group('isMatch', () {
    test('matches correctly', () {
      final syntax = TableLineSyntax();
      expect(
          syntax.isMatch(
            '||',
            EnDialectMock(),
          ),
          true);
      expect(
          syntax.isMatch(
            ' | | ',
            EnDialectMock(),
          ),
          true);
      expect(
          syntax.isMatch(
            '  |a|b|c| ',
            EnDialectMock(),
          ),
          true);
    });

    test('allows trailing comment', () {
      final syntax = TableLineSyntax();

      expect(
          syntax.isMatch(
            '  |a|b|c| #comment',
            EnDialectMock(),
          ),
          true);

      expect(
          syntax.isMatch(
            '  |a|b|c|#comment with spaces',
            EnDialectMock(),
          ),
          true);

      expect(
          syntax.isMatch(
            '  |a|b|c| # comment with spaces',
            EnDialectMock(),
          ),
          true);
    });

    test('does not match', () {
      final syntax = TableLineSyntax();
      expect(
          syntax.isMatch(
            '#||',
            EnDialectMock(),
          ),
          false);
      expect(
          syntax.isMatch(
            ' |  ',
            EnDialectMock(),
          ),
          false);
      expect(
          syntax.isMatch(
            '  |a|b|c ',
            EnDialectMock(),
          ),
          false);
    });
  });

  group('block', () {
    test('is block', () {
      final syntax = TableLineSyntax();
      expect(syntax.isBlockSyntax, true);
    });

    test('continue block if table line string', () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(TableLineSyntax()), false);
    });

    test('continue block if comment string', () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(CommentSyntax()), false);
    });

    test('end block if not table line string', () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(MultilineStringSyntax()), true);
    });
  });

  group('block', () {
    test('is block', () {
      final syntax = TableLineSyntax();
      expect(syntax.isBlockSyntax, true);
    });

    test('continue block if table line', () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(TableLineSyntax()), false);
    });

    test('continue block if comment string', () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(CommentSyntax()), false);
    });

    test('end block if step', () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(StepSyntax()), true);
    });

    test('end block if multiline string', () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(MultilineStringSyntax()), true);
    });
  });

  group('toRunnable', () {
    test('creates TableRunnable', () {
      final syntax = TableLineSyntax();
      final TableRunnable runnable = syntax.toRunnable(
        ' | Column One | Column Two | ',
        RunnableDebugInformation(null, 0, null),
        EnDialectMock(),
      ) as TableRunnable;
      expect(runnable, isNotNull);
      expect(runnable, predicate((dynamic x) => x is TableRunnable));
      expect(runnable.rows.elementAt(0), '| Column One | Column Two |');
      expect(runnable.rows.length, 1);
    });

    test('creates TableRunnable from line with trailing comment', () {
      final syntax = TableLineSyntax();
      final TableRunnable runnable = syntax.toRunnable(
        ' | Column One | Column Two | Column Three | # comment with spaces',
        RunnableDebugInformation(null, 0, null),
        EnDialectMock(),
      ) as TableRunnable;
      expect(runnable, isNotNull);
      expect(runnable, predicate((dynamic x) => x is TableRunnable));
      expect(runnable.rows.elementAt(0),
          '| Column One | Column Two | Column Three |');
      expect(runnable.rows.length, 1);
    });
  });
}
