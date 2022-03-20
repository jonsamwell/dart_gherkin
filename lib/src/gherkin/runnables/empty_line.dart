import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';

class EmptyLineRunnable extends Runnable {
  @override
  String get name => 'Empty Line';

  EmptyLineRunnable(RunnableDebugInformation debug) : super(debug);
}
