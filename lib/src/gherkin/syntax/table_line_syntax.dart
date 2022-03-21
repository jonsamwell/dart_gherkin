import '../languages/dialect.dart';
import '../runnables/debug_information.dart';
import '../runnables/table.dart';
import 'comment_syntax.dart';
import 'regex_matched_syntax.dart';
import 'syntax_matcher.dart';

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
