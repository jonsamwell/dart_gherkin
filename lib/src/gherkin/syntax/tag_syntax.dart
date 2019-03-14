import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import '../runnables/tags.dart';
import './regex_matched_syntax.dart';

class TagSyntax extends RegExMatchedGherkinSyntax {
  @override
  final RegExp pattern = RegExp("^@", multiLine: false, caseSensitive: false);

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) {
    final runnable = TagsRunnable(debug);
    runnable.tags = line
        .trim()
        .split(RegExp("@"))
        .map((t) => t.trim())
        .where((t) => t != null && t.isNotEmpty);
    return runnable;
  }
}
