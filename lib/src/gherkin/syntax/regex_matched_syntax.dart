import 'package:gherkin/src/gherkin/languages/dialect.dart';

import './syntax_matcher.dart';

abstract class RegExMatchedGherkinSyntax extends SyntaxMatcher {
  RegExp pattern(GherkinDialect? dialect);

  @override
  bool isMatch(String line, GherkinDialect? dialect) {
    final match = pattern(dialect).hasMatch(line);

    return match;
  }

  String getMultiDialectRegexPattern(Iterable<String> dialectVariants) =>
      dialectVariants.map((s) => s.trim()).where((s) => s != '*').join('|');
}
