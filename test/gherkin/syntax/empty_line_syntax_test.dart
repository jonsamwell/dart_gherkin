import 'package:gherkin/src/gherkin/syntax/empty_line_syntax.dart';
import 'package:test/test.dart';

import '../../mocks/en_dialect_mock.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final keyword = EmptyLineSyntax();
      expect(
          keyword.isMatch(
            "",
            EnDialectMock(),
          ),
          true);
      expect(
          keyword.isMatch(
            " ",
            EnDialectMock(),
          ),
          true);
      expect(
          keyword.isMatch(
            "  ",
            EnDialectMock(),
          ),
          true);
      expect(
          keyword.isMatch(
            "    ",
            EnDialectMock(),
          ),
          true);
    });

    test('does not match', () {
      final keyword = EmptyLineSyntax();
      expect(
          keyword.isMatch(
            "a",
            EnDialectMock(),
          ),
          false);
      expect(
          keyword.isMatch(
            " b",
            EnDialectMock(),
          ),
          false);
      expect(
          keyword.isMatch(
            "  c",
            EnDialectMock(),
          ),
          false);
      expect(
          keyword.isMatch(
            "    ,",
            EnDialectMock(),
          ),
          false);
    });
  });
}
