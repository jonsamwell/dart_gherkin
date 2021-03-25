import 'dart:async';

import 'package:gherkin/gherkin.dart';

import 'supporting_files/hooks/hook_example.dart';
import 'supporting_files/parameters/power_of_two.parameter.dart';
import 'supporting_files/steps/given_the_characters.step.dart';
import 'supporting_files/steps/given_the_numbers.step.dart';
import 'supporting_files/steps/given_the_powers_of_two.step.dart';
import 'supporting_files/steps/then_expect_numeric_result.step.dart';
import 'supporting_files/steps/when_numbers_are_added.step.dart';
import 'supporting_files/steps/when_the_characters_are_counted.step.dart';
import 'supporting_files/worlds/custom_world.world.dart';

Future<void> main() {
  final Iterable<StepDefinitionGeneric<World?>> steps = [
    GivenTheNumbers(),
    GivenThePowersOfTwo(),
    GivenTheCharacters(),
    WhenTheStoredNumbersAreAdded(),
    WhenTheCharactersAreCounted(),
    ThenExpectNumericResult()
  ];
  final config = TestConfiguration.DEFAULT(steps)
    ..tagExpression = 'not @skip'
    ..hooks = [HookExample()]
    ..customStepParameterDefinitions = [PowerOfTwoParameter()]
    ..createWorld = (TestConfiguration config) => Future.value(CalculatorWorld());

  return GherkinRunner().execute(config);
}
