import 'package:gherkin/gherkin.dart';

import '../worlds/custom_world.world.dart';

StepDefinitionGeneric GivenTheCharacters() {
  return given1<String, CalculatorWorld>(
    'the characters {string}',
    (input1, context) async {
      context.world.calculator.storeCharacterInput(input1);
    },
  );
}
