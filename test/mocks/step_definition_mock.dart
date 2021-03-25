import 'package:gherkin/gherkin.dart';
import 'package:gherkin/src/gherkin/steps/step_definition_implementations.dart';

typedef OnRunCode = Future<void> Function(Iterable parameters);

class MockStepDefinition extends StepDefinitionBase<World> {
  bool hasRun = false;
  int runCount = 0;
  final OnRunCode? code;

  MockStepDefinition([this.code, int expectedParameterCount = 0])
      : super(
          StepDefinitionConfiguration()
            ..timeout = const Duration(milliseconds: 200),
          expectedParameterCount,
        );

  @override
  Future<void> onRun(Iterable parameters) async {
    hasRun = true;
    runCount += 1;
    if (code != null) {
      await code!(parameters);
    }
  }

  @override
  RegExp? get pattern => null;
}
