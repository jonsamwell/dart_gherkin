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
  final steps = [
    givenTheNumbers(),
    givenThePowersOfTwo(),
    givenTheCharacters(),
    whenTheStoredNumbersAreAdded(),
    whenTheCharactersAreCounted(),
    thenExpectNumericResult()
  ];

  final config = TestConfiguration(
    features: [RegExp(r'features\\.+\.feature')],
    reporters: [
      StdoutReporter(MessageLevel.error),
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(),
    ],
    hooks: [HookExample()],
    customStepParameterDefinitions: [PowerOfTwoParameter()],
    createWorld: (config) => Future.value(CalculatorWorld()),
    stepDefinitions: steps,
    stopAfterTestFailed: true,
  );

  // or

  // final config = TestConfiguration.standard(
  //   steps,
  //   tagExpression: 'not @skip',
  //   hooks: [HookExample()],
  //   customStepParameterDefinitions: [PowerOfTwoParameter()],
  //   createWorld: (config) => Future.value(CalculatorWorld()),
  //   stopAfterTestFailed: true,
  // );

  return GherkinRunner().execute(config);
}
