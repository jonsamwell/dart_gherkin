import 'package:gherkin/gherkin.dart';
import '../worlds/custom_world.world.dart';

class GivenTheCharacters extends Given1WithWorld<String, CalculatorWorld> {
  @override
  Future<void> executeStep(String input1) async {
    world.calculator.storeCharacterInput(input1);
  }

  @override
  RegExp get pattern => RegExp(r"the characters {string}");
}
