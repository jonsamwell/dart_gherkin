import 'package:gherkin/src/gherkin/languages/dialect.dart';

import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import '../runnables/step.dart';
import './multiline_string_syntax.dart';
import './regex_matched_syntax.dart';
import './syntax_matcher.dart';
import './table_line_syntax.dart';

class StepSyntax extends RegExMatchedGherkinSyntax {
  @override
  RegExp pattern(GherkinDialect? dialect) => RegExp(
        '^(${getMultiDialectRegexPattern(dialect!.stepKeywords)})\\s.*',
        multiLine: false,
        caseSensitive: false,
      );

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) =>
      !(syntax is MultilineStringSyntax || syntax is TableLineSyntax);

  @override
  Runnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect? dialect,
  ) {
    final runnable = StepRunnable(line, debug);
    return runnable;
  }
}
