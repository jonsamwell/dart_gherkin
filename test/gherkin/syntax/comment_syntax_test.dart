import 'package:gherkin/src/gherkin/syntax/comment_syntax.dart';
import 'package:test/test.dart';

import '../../mocks/en_dialect_mock.dart';

void main() {
  group('isMatch', () {
    test('matches correctly', () {
      final keyword = CommentSyntax();
      expect(
          keyword.isMatch(
            '# I am a comment',
            EnDialectMock(),
          ),
          true);
      expect(
          keyword.isMatch(
            '#I am also a comment',
            EnDialectMock(),
          ),
          true);
      expect(
          keyword.isMatch(
            '## I am also a comment',
            EnDialectMock(),
          ),
          true);
      expect(
          keyword.isMatch(
            '# Language something',
            EnDialectMock(),
          ),
          true);
    });

    test('does not match', () {
      final keyword = CommentSyntax();
      // expect(keyword.isMatch('# language: en'), false);
      expect(
          keyword.isMatch(
            'I am not a comment',
            EnDialectMock(),
          ),
          false);
    });
  });
}
