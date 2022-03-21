import '../languages/dialect.dart';
import '../runnables/debug_information.dart';
import '../runnables/example.dart';
import '../runnables/runnable.dart';
import 'regex_matched_syntax.dart';
import 'syntax_matcher.dart';
import 'table_line_syntax.dart';

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
