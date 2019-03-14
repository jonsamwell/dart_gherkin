import 'package:gherkin/gherkin.dart';
import '../worlds/custom_world.world.dart';

class GivenTheNumbers extends Given2WithWorld<num, num, CalculatorWorld> {
  @override
  Future<void> executeStep(num input1, num input2) async {
    world.calculator.storeNumericInput(input1);
    world.calculator.storeNumericInput(input2);
  }

  @override
  RegExp get pattern => RegExp(r"the numbers {num} and {num}");
}
