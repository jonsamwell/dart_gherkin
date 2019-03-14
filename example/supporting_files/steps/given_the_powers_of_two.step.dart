import 'package:gherkin/gherkin.dart';
import '../worlds/custom_world.world.dart';

class GivenThePowersOfTwo extends Given2WithWorld<int, int, CalculatorWorld> {
  @override
  Future<void> executeStep(int input1, int input2) async {
    world.calculator.storeNumericInput(input1);
    world.calculator.storeNumericInput(input2);
  }

  @override
  RegExp get pattern => RegExp(r"the powers {POW} and {POW}");
}
