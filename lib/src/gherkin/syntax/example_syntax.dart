import 'package:gherkin/src/gherkin/languages/dialect.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/example.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';
import 'package:gherkin/src/gherkin/syntax/regex_matched_syntax.dart';
import 'package:gherkin/src/gherkin/syntax/syntax_matcher.dart';
import 'package:gherkin/src/gherkin/syntax/table_line_syntax.dart';

class ExampleSyntax extends RegExMatchedGherkinSyntax {
  @override
  RegExp pattern(GherkinDialect dialect) {
    final dialectPattern =
        RegExMatchedGherkinSyntax.getMultiDialectRegexPattern(dialect.examples);

    return RegExp(
      '^\\s*(?:$dialectPattern):(\\s*(.+)\\s*)?\$',
      multiLine: false,
      caseSensitive: false,
    );
  }

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) => syntax is! TableLineSyntax;

  @override
  Runnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect dialect,
  ) {
    final name = (pattern(dialect).firstMatch(line)?.group(1) ?? '').trim();
    final runnable = ExampleRunnable(name, debug);

    return runnable;
  }
}
