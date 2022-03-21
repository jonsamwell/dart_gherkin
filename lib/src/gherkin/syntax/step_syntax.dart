import '../languages/dialect.dart';

import '../runnables/debug_information.dart';
import '../runnables/step.dart';
import 'multiline_string_syntax.dart';
import 'regex_matched_syntax.dart';
import 'syntax_matcher.dart';
import 'table_line_syntax.dart';

class StepSyntax extends RegExMatchedGherkinSyntax<StepRunnable> {
  @override
  RegExp pattern(GherkinDialect dialect) {
    final dialectPattern =
        RegExMatchedGherkinSyntax.getMultiDialectRegexPattern(
      dialect.stepKeywords,
    );

    return RegExp(
      '^($dialectPattern)\\s?.*',
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
  StepRunnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect dialect,
  ) {
    final runnable = StepRunnable(line, debug);
    return runnable;
  }
}
