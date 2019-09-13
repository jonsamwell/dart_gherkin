import 'package:gherkin/gherkin.dart';
import '../worlds/custom_world.world.dart';

class WhenTheCharactersAreCounted extends WhenWithWorld<CalculatorWorld> {
  @override
  Future<void> executeStep() async {
    world.calculator.countStringCharacters();
  }

  @override
  RegExp get pattern => RegExp(r"they are counted");
}
