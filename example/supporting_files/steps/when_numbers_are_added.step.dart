import 'package:gherkin/gherkin.dart';
import '../worlds/custom_world.world.dart';

class WhenTheStoredNumbersAreAdded extends WhenWithWorld<CalculatorWorld> {
  @override
  Future<void> executeStep() async {
    world.calculator.add();
  }

  @override
  RegExp get pattern => RegExp(r'they are added');
}
