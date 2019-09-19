import 'package:gherkin/src/gherkin/langauges/dialect.dart';

import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import '../runnables/step.dart';
import './multiline_string_syntax.dart';
import './regex_matched_syntax.dart';
import './syntax_matcher.dart';
import './table_line_syntax.dart';

class StepSyntax extends RegExMatchedGherkinSyntax {
  @override
  RegExp pattern(GherkinDialect dialect) {
    final stepKeywordPattern = getMultiDialectRegexPattern([]
      ..addAll(dialect.given)
      ..addAll(dialect.when)
      ..addAll(dialect.then)
      ..addAll(dialect.and)
      ..addAll(dialect.but));
    return RegExp(
      "^($stepKeywordPattern)\\s.*",
      multiLine: false,
      caseSensitive: false,
    );
  }

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) =>
      !(syntax is MultilineStringSyntax || syntax is TableLineSyntax);

  @override
  Runnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect dialect,
  ) {
    final runnable = StepRunnable(line, debug);
    return runnable;
  }
}
