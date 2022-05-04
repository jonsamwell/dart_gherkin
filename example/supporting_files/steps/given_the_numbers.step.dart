import 'package:gherkin/gherkin.dart';
import '../worlds/custom_world.world.dart';

StepDefinitionGeneric givenTheNumbers() {
  return given2<num, num, CalculatorWorld>(
    'the numbers {num} and {num}',
    (input1, input2, context) async {
      context.world.calculator.storeNumericInput(input1);
      context.world.calculator.storeNumericInput(input2);
    },
  );
}
