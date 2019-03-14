import '../runnables/comment_line.dart';
import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import './regex_matched_syntax.dart';

class CommentSyntax extends RegExMatchedGherkinSyntax {
  @override
  final RegExp pattern = RegExp("^#", multiLine: false, caseSensitive: false);

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) =>
      CommentLineRunnable(line.trim(), debug);
}
