import 'package:gherkin/src/gherkin/languages/dialect.dart';

import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/table.dart';
import 'package:gherkin/src/gherkin/syntax/comment_syntax.dart';
import 'package:gherkin/src/gherkin/syntax/regex_matched_syntax.dart';
import 'package:gherkin/src/gherkin/syntax/syntax_matcher.dart';

class TableLineSyntax extends RegExMatchedGherkinSyntax<TableRunnable> {
  @override
  RegExp pattern(GherkinDialect dialect) => RegExp(
        r'^\s*(\|.*\|)\s*(?:\s*#\s*.*)?$',
        multiLine: false,
        caseSensitive: false,
      );

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) {
    if (syntax is TableLineSyntax || syntax is CommentSyntax) {
      return false;
    }

    return true;
  }

  @override
  TableRunnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect dialect,
  ) {
    final runnable = TableRunnable(debug);
    runnable.rows.add(
      pattern(dialect).firstMatch(line.trim())!.group(1)!.trim(),
    );

    return runnable;
  }
}
