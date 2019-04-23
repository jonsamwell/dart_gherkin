import 'package:gherkin/gherkin.dart';
import '../worlds/custom_world.world.dart';

class ThenExpectNumericResult extends Then1WithWorld<num, CalculatorWorld> {
  @override
  Future<void> executeStep(num input1) async {
    final result = world.calculator.getNumericResult();
    expectMatch(result, input1);
  }

  @override
  RegExp get pattern => RegExp(r"the expected result is {num}");
}
