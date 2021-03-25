import './debug_information.dart';
import './runnable.dart';

class TextLineRunnable extends Runnable {
  String? text;

  /// While [text] can be `trim()`'d, original whitespace will be preserved
  /// in `originalText`.
  String? originalText;

  @override
  String get name => 'Language';

  TextLineRunnable(RunnableDebugInformation debug) : super(debug);
}
