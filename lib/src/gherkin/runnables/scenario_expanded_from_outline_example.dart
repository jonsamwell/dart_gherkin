import 'debug_information.dart';
import 'scenario.dart';
import 'scenario_type_enum.dart';

class ScenarioExpandedFromOutlineExampleRunnable extends ScenarioRunnable {
  String _name;

  @override
  ScenarioType get scenarioType => ScenarioType.scenarioOutline;

  @override
  String get name => _name;

  ScenarioExpandedFromOutlineExampleRunnable(
    String name,
    String? description,
    RunnableDebugInformation debug,
  )   : _name = name,
        super(
          name,
          description,
          debug,
        );

  void setStepParameter(String parameterName, String value) {
    _name = _name.replaceAll('<$parameterName>', value);
    debug = debug.copyWith(
      lineNumber: debug.lineNumber,
      lineText: debug.lineText.replaceAll('<$parameterName>', value),
    );
  }
}
