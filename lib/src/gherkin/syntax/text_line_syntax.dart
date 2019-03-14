import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import '../runnables/text_line.dart';
import './regex_matched_syntax.dart';

class TextLineSyntax extends RegExMatchedGherkinSyntax {
  @override
  final RegExp pattern =
      RegExp(r"^\s*(?!#)\w+.*]*$", multiLine: false, caseSensitive: false);

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) {
    final runnable = TextLineRunnable(debug);
    runnable.text = line.trim();
    return runnable;
  }
}
