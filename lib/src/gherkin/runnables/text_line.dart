import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';

class TextLineRunnable extends Runnable {
  /// The trimmed version of the line
  late String text;

  /// While [text] can be `trim()`'d, original whitespace will be preserved
  /// in `originalText`.
  late String? originalText;

  @override
  String get name => 'Language';

  TextLineRunnable(RunnableDebugInformation debug) : super(debug);
}
