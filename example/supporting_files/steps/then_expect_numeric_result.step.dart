import 'package:gherkin/gherkin.dart';
import '../worlds/custom_world.world.dart';

StepDefinitionGeneric ThenExpectNumericResult() {
  return given1<num, CalculatorWorld>(
    'the expected result is {num}',
    (input1, context) async {
      final result = context.world.calculator.getNumericResult();
      context.expectMatch(result, input1);
    },
  );
}
