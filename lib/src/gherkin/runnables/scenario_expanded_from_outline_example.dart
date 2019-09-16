import 'package:gherkin/src/gherkin/runnables/scenario.dart';

import './debug_information.dart';

class ScenarioExpandedFromOutlineExampleRunnable extends ScenarioRunnable {
  ScenarioExpandedFromOutlineExampleRunnable(
      String name, RunnableDebugInformation debug)
      : super(name, debug);
}
