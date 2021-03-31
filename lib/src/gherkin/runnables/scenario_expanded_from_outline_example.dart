import 'package:gherkin/src/gherkin/runnables/scenario.dart';
import 'package:gherkin/src/gherkin/runnables/scenario_type_enum.dart';

import './debug_information.dart';

class ScenarioExpandedFromOutlineExampleRunnable extends ScenarioRunnable {
  String _name;

  @override
  ScenarioType get scenarioType => ScenarioType.scenario_outline;

  @override
  String get name => _name;

  ScenarioExpandedFromOutlineExampleRunnable(
      String name, RunnableDebugInformation debug)
      : _name = name,
        super(name, debug);

  void setStepParameter(String? parameterName, String value) {
    _name = _name.replaceAll('<$parameterName>', value);
    updateDebugInformation(debug.copyWith(debug.lineNumber,
        debug.lineText?.replaceAll('<$parameterName>', value)));
  }
}
