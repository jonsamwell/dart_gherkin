import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';

class CommentLineRunnable extends Runnable {
  final String comment;

  @override
  String get name => 'Comment Line';

  CommentLineRunnable(this.comment, RunnableDebugInformation debug)
      : super(debug);
}
