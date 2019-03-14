import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import '../runnables/table.dart';
import './comment_syntax.dart';
import './regex_matched_syntax.dart';
import './syntax_matcher.dart';

class TableLineSyntax extends RegExMatchedGherkinSyntax {
  @override
  final RegExp pattern =
      RegExp(r"^\s*\|.*\|\s*$", multiLine: false, caseSensitive: false);

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
  Runnable toRunnable(String line, RunnableDebugInformation debug) {
    final runnable = TableRunnable(debug);
    runnable.rows.add(line.trim());
    return runnable;
  }
}
