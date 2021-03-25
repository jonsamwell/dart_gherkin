import 'package:gherkin/src/gherkin/languages/dialect.dart';

import './comment_syntax.dart';
import './regex_matched_syntax.dart';
import './syntax_matcher.dart';
import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import '../runnables/table.dart';

class TableLineSyntax extends RegExMatchedGherkinSyntax {
  @override
  RegExp pattern(GherkinDialect? dialect) => RegExp(
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
  Runnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect? dialect,
  ) {
    final runnable = TableRunnable(debug);
    runnable.rows.add(pattern(dialect).firstMatch(line.trim())!.group(1)!.trim());
    return runnable;
  }
}
