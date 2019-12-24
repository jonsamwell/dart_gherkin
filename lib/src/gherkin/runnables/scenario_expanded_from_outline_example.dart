import 'package:gherkin/src/gherkin/runnables/scenario.dart';
import 'package:gherkin/src/gherkin/runnables/scenario_type_enum.dart';

import './debug_information.dart';

class ScenarioExpandedFromOutlineExampleRunnable extends ScenarioRunnable {
  @override
  ScenarioType get scenarioType => ScenarioType.scenario_outline;

  ScenarioExpandedFromOutlineExampleRunnable(
      String name, RunnableDebugInformation debug)
      : super(name, debug);
}
