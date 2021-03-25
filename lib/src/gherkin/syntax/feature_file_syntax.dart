import 'package:gherkin/src/gherkin/languages/dialect.dart';

import '../syntax/syntax_matcher.dart';

class FeatureFileSyntax extends SyntaxMatcher {
  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) => false;

  @override
  bool isMatch(String line, GherkinDialect? dialect) {
    return false;
  }
}
