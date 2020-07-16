import 'package:gherkin/gherkin.dart';
import '../worlds/custom_world.world.dart';

StepDefinitionGeneric WhenTheCharactersAreCounted() {
  return given<CalculatorWorld>(
    'they are counted',
    (context) async {
      context.world.calculator.countStringCharacters();
    },
  );
}
