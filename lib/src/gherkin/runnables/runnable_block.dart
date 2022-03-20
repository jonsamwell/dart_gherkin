import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';

abstract class RunnableBlock extends Runnable {
  RunnableBlock(RunnableDebugInformation debug) : super(debug);

  void addChild(Runnable child);
}
