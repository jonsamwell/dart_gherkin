import '../languages/dialect.dart';
import '../runnables/runnable.dart';

import 'syntax_matcher.dart';

abstract class RegExMatchedGherkinSyntax<TRunnable extends Runnable>
    extends SyntaxMatcher<TRunnable> {
  RegExp pattern(GherkinDialect dialect);

  @override
  bool isMatch(String line, GherkinDialect dialect) =>
      pattern(dialect).hasMatch(line);

  static String getMultiDialectRegexPattern(Iterable<String> dialectVariants) =>
      dialectVariants.map((s) => s.trim()).where((s) => s != '*').join('|');
}
