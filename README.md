# dart_gherkin

A fully featured Gherkin parser and test runner.  Works with Flutter and Dart 2.

This implementation of the Gherkin tries to follow as closely as possible other implementations of Gherkin and specifically [Cucumber](https://docs.cucumber.io/cucumber/) in it's various forms.

Available as a Dart package https://pub.dartlang.org/packages/gherkin
Available as a Flutter specific package https://pub.dartlang.org/packages/flutter_gherkin which contains specific implementations to help instrument an application to test.

``` dart
  # Comment
  Feature: Addition

    @tag
    Scenario: 1 + 0
      Given I start with 1
      When I add 0
      Then I end up with 1

    Scenario: 1 + 1
      Given I start with 1
      When I add 1
      Then I end up with 2
```

## Table of Contents

<!-- TOC -->

- [dart_gherkin](#dart_gherkin)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
    - [Configuration](#configuration)
      - [features](#features)
      - [tagExpression](#tagexpression)
      - [order](#order)
      - [defaultLanguage](#defaultlanguage)
      - [stepDefinitions](#stepdefinitions)
      - [customStepParameterDefinitions](#customstepparameterdefinitions)
      - [hooks](#hooks)
      - [attachments](#attachments)
      - [reporters](#reporters)
      - [createWorld](#createworld)
      - [featureFileMatcher](#featurefilematcher)
      - [featureFileReader](#featurefilereader)
      - [stopAfterTestFailed](#stopaftertestfailed)
  - [Features Files](#features-files)
    - [Steps Definitions](#steps-definitions)
      - [Given](#given)
      - [Then](#then)
      - [Expects Assertions](#expects-assertions)
      - [Step Timeout](#step-timeout)
      - [Multiline Strings](#multiline-strings)
      - [Data tables](#data-tables)
      - [Well known step parameters](#well-known-step-parameters)
      - [Pluralization](#pluralization)
      - [Custom Parameters](#custom-parameters)
      - [World Context (per test scenario shared state)](#world-context-per-test-scenario-shared-state)
      - [Assertions](#assertions)
    - [Tags](#tags)
    - [Languages](#languages)
  - [Hooks](#hooks-1)
  - [Reporting](#reporting)

<!-- /TOC -->

## Getting Started

See <https://docs.cucumber.io/gherkin/> for information on the Gherkin syntax and Behaviour Driven Development (BDD).

See [example readme](example/README.md) for a quick start guide to running the example features.

To get started with BDD in Dart the first step is to write a feature file and a test scenario within that.

First create a folder called `test` , within the folder create a folder called `features` , then create a file called `calculator_can_add.feature` .

``` dart
Feature: Calculator
  Tests the addition feature of the calculator

  Scenario: Add two numbers
    Given the numbers 1.5 and 2.1
    When they are added
    Then expected result is 3.6
```

Now we have created a scenario we need to implement the steps within.  Steps are just classes that extends from the base step definition class or any of its variations `Given` , `Then` , `When` , `And` , `But` .

Granted the example is a little contrived but is serves to illustrate the process.

To implement a step we have to create a method that will then be imported into our configuration.

``` dart
import 'package:gherkin/gherkin.dart';
import '../worlds/custom_world.world.dart';

StepDefinitionGeneric GivenTheNumbers() {
  return given2<num, num, CalculatorWorld>(
    'the numbers {num} and {num}',
    (input1, input2, context) async {
      context.world.calculator.storeNumericInput(input1);
      context.world.calculator.storeNumericInput(input2);
    },
  );
}
```

As you can see the `given2` method is invoked specifying two input parameters.  The third type `CalculatorWorld` is a special world context object that allow access context to pass between steps in the same scenario execution instance.  If you did not need a custom world object you can omit the type parameters completely.

``` dart
import 'package:gherkin/gherkin.dart';
import '../worlds/custom_world.world.dart';

StepDefinitionGeneric GivenTheNumbers() {
  return given2(
    'the numbers {num} and {num}',
    (input1, input2, context) async {
      // implement step
    },
  );
}
```

The input parameters are retrieved via the pattern `the numbers {num} and {num}` from well know parameter type `{num}` [explained below](#well-known-step-parameters).  They are just special syntax to indicate you are expecting a string, an integer or a number etc at those points in the step text.  Therefore, when the step to execute is `Given the numbers 1.5 and 2.1` the parameters 1.5 and 2.1 will be passed into the step as the correct types.  Note that in the pattern you can use any regex capture group to indicate any input parameter.  For example the pattern `` `RegExp(r"the (numbers|integers|digits) {num} and {num}` `` indicates 3 parameters and would match to either of the below step text.

``` dart
Given the numbers 1.5 and 2.1    // passes 3 parameters "numbers", 1.5 & 2.1
Given the integers 1 and 2      // passes 3 parameters "integers", 1 & 2
```

It is worth noting that this library *does not* rely on mirrors (reflection) for many reasons but most prominently for ease of maintenance and to fall inline with the principles of Flutter not allowing reflection.  All in all this make for a much easier to understand and maintain code base as well as much easier debugging for the user.  The downside is that we have to be slightly more explicit by providing instances of custom code such as step definition, hook, reporters and custom parameters.

Now that we have a testable app, a feature file and a custom step definition we need to create a class that will call this library and actually run the tests.  Create a file called `test.dart` and put the below code in.

``` dart
import 'dart:async';
import 'package:gherkin/gherkin.dart';
import 'supporting_files/steps/given_the_numbers.step.dart';
import 'supporting_files/steps/then_expect_numeric_result.step.dart';
import 'supporting_files/steps/when_numbers_are_added.step.dart';
import 'supporting_files/worlds/custom_world.world.dart';

Future<void> main() {
  final steps = [
      givenTheNumbers(),
      whenTheStoredNumbersAreAdded(),
      thenExpectNumericResult()
  ];
  final config = TestConfiguration.standard(
    steps,
    hooks: [HookExample()],
    customStepParameterDefinitions: [PowerOfTwoParameter()],
    createWorld: (config) => Future.value(CalculatorWorld()),
  );

  return GherkinRunner().execute(config);
}
```

This code simple creates a configuration object and calls this library which will then promptly parse your feature files and run the tests.  The configuration file is important and explained in further detail below.  Finally to actually run the tests run the below on the command line from within the example folder:

``` bash
dart test.dart
```

To debug tests see [Debugging](#debugging).

*Note*: You might need to ensure dart is accessible by adding it to your path variable.

### Configuration

The configuration is an important piece of the puzzle in this library as it specifies not only what to run but classes to run against in the form of steps, hooks and reporters.  Unlike other implementation this library does not rely on reflection so need to be explicitly told classes to use.

The parameters below can be specified in your configuration file:

#### features

*Required*

An iterable of `Pattern` patterns that specify the location(s) of `*.feature` files to run.
Could be [Pattern](https://api.dart.dev/stable/2.12.2/dart-core/Pattern-class.html), [Glob](https://pub.dartlang.org/packages/glob) or just `String`.

#### tagExpression

Defaults to `null` .

An infix boolean expression which defines the features and scenarios to run based of their tags. See [Tags](#tags).

#### order

Defaults to `ExecutionOrder.random`
The order by which scenarios will be run. Running an a random order may highlight any inter-test dependencies that should be fixed.

#### defaultLanguage

Defaults to `en`
This specifies the default language the feature files are written in.  See https://cucumber.io/docs/gherkin/reference/#overview for supported languages.

#### stepDefinitions

Defaults to `Iterable<StepDefinitionBase>`
Place instances of any custom step definition classes `Given` , `Then` , `When` , `And` , `But` that match to any custom steps defined in your feature files.

``` dart
import 'dart:async';
import 'package:gherkin/gherkin.dart';
import 'supporting_files/steps/given_the_numbers.step.dart';
import 'supporting_files/steps/then_expect_numeric_result.step.dart';
import 'supporting_files/steps/when_numbers_are_added.step.dart';
import 'supporting_files/worlds/custom_world.world.dart';

Future<void> main() {
  final config = TestConfiguration(
    features: [RegExp(r"features/.*\.feature")],
    reporters: [
      StdoutReporter(MessageLevel.error),
      ProgressReporter(),
      TestRunSummaryReporter(),
    ],
    createWorld: (config) => Future.value(CalculatorWorld()),
    stepDefinitions: [
      givenTheNumbers(),
      whenTheStoredNumbersAreAdded(),
      thenExpectNumericResult()
    ],
    stopAfterTestFailed: true,
  );

  return GherkinRunner().execute(config);
```

#### customStepParameterDefinitions

Defaults to `CustomParameter<dynamic>` .

Place instances of any custom step parameters that you have defined.  These will be matched up to steps when scenarios are run and their result passed to the executable step.  See [Custom Parameters](#custom-parameters).

``` dart
import 'dart:async';
import 'package:gherkin/gherkin.dart';
import 'supporting_files/parameters/power_of_two.parameter.dart';
import 'supporting_files/steps/given_the_numbers.step.dart';
import 'supporting_files/steps/given_the_powers_of_two.step.dart';
import 'supporting_files/steps/then_expect_numeric_result.step.dart';
import 'supporting_files/steps/when_numbers_are_added.step.dart';
import 'supporting_files/worlds/custom_world.world.dart';

Future<void> main() {
  final steps = [
      givenTheNumbers(),
      whenTheStoredNumbersAreAdded(),
      thenExpectNumericResult()
  ];
  final config = TestConfiguration.standard(
    steps,
    customStepParameterDefinitions: [PowerOfTwoParameter()],
    createWorld: (config) => Future.value(CalculatorWorld()),
  );

  return GherkinRunner().execute(config);
}
```

#### hooks

Hooks are custom bits of code that can be run at certain points with the test run such as before or after a scenario.  Place instances of any custom `Hook` class instance in this collection.  They will then be run at the defined points with the test run.

#### attachments

Attachment are pieces of data you can attach to a running scenario.  This could be simple bits of textual data or even image like a screenshot.  These attachments can then be used by reporters to provide more contextual information.  For example when a step fails a screenshot could be taken and attached to the scenario which is then used by a reporter to display why the step failed.

Attachments would typically be attached via a `Hook` for example `onAfterStep` .

```dart
import 'package:gherkin/gherkin.dart';

class AttachScreenshotOnFailedStepHook extends Hook {
  /// Run after a step has executed
  @override
  Future<void> onAfterStep(World world, String step, StepResult stepResult) async {
    if (stepResult.result == StepExecutionResult.fail) {
      final screenshotData = await _takeScreenshot();
      world.attach(screenshotData, 'image/png', step);
    }
  }

  Future<String> _takeScreenshot() async {
    // logic to take screenshot
  }
}

```

#### reporters

Reporters are classes that are able to report on the status of the test run.  This could be a simple as merely logging scenario result to the console.  There are a number of built-in reporter:

* `StdoutReporter` : Logs all messages from the test run to the standard output (console).
* `ProgressReporter` : Logs the progress of the test run marking each step with a scenario as either passed, skipped or failed.
* `TestRunSummaryReporter` - prints the results and duration of the test run once the run has completed - colours the output.
* `JsonReporter` - create a json file with the test run results.

Previously, it was possible to redefine specific functions, now this happens through the redefinition of classes.

*Note*: Feel free to PR new reporters!

``` dart
import 'dart:async';
import 'package:gherkin/gherkin.dart';
import 'supporting_files/parameters/power_of_two.parameter.dart';
import 'supporting_files/steps/given_the_numbers.step.dart';
import 'supporting_files/steps/given_the_powers_of_two.step.dart';
import 'supporting_files/steps/then_expect_numeric_result.step.dart';
import 'supporting_files/steps/when_numbers_are_added.step.dart';
import 'supporting_files/worlds/custom_world.world.dart';

Future<void> main() {
  final steps = [
      givenTheNumbers(),
      whenTheStoredNumbersAreAdded(),
      thenExpectNumericResult()
  ];
  final config = TestConfiguration.standard(steps); // Provide default reporters for this constructor

  return GherkinRunner().execute(config);
}
```

#### createWorld

Defaults to `null` .

While it is not recommended so share state between steps within the same scenario we all in fact live in the real world and thus at time may need to share certain information such as login credentials etc for future steps to use.  The world context object is created once per scenario and then destroyed at the end of each scenario.  This configuration property allows you to specify a custom `World` class to create which can then be accessed in your step classes.

``` dart
Future<void> main() {
  final steps = [
      givenTheNumbers(),
      whenTheStoredNumbersAreAdded(),
      thenExpectNumericResult()
  ];
  final config = TestConfiguration.standard(
    steps,
    createWorld: (config) => Future.value(CalculatorWorld()),
  );

  return GherkinRunner().execute(config);
}
```

#### featureFileMatcher

`FeatureFileMatcher` is an interface for feature files lookup.
Defaults to `IoFeatureFileAccessor`, which lists files from current execution directory that match `features` patterns (similar to Glob).

#### featureFileReader

`FeatureFileReader` is an interface for feature files content read.
Defaults to `IoFeatureFileAccessor`, which reads files as String with [utf-8 encoding](https://api.dart.dev/stable/2.12.2/dart-convert/utf8-constant.html).

To change encoding, use the default `IoFeatureFileReader` with custom [Encoding](https://api.dart.dev/stable/2.12.2/dart-convert/Encoding-class.html).

``` dart
import dart:convert;

Future<void> main() {
  final steps = [
      givenTheNumbers(),
      whenTheStoredNumbersAreAdded(),
      thenExpectNumericResult()
  ];

  final config = TestConfiguration.standard(
    steps,
    featureFileReader: IoFeatureFileAccessor(
      encoding: Encoding.getByName('latin1')!,
    ),
  );

  return GherkinRunner().execute(config);
}
```

#### stopAfterTestFailed

Defaults to `false`
True to stop the test run when a test fails. You may want to set this to true during debugging.

## Features Files

### Steps Definitions

Step definitions are the coded representation of a textual step in a feature file.  Each step starts with either `Given` , `Then` , `When` , `And` or `But` .  It is worth noting that all steps are actually the same but semantically different.  The keyword is not taken into account when matching a step.  Therefore the two below steps are actually treated the same and will result in the same step definition being invoked.

Note: Step definitions (in this implementation) are allowed up to 5 input parameters.  If you find yourself needing more than this you might want to consider making your step more isolated or using a `Table` parameter.

``` dart
Given there are 6 kangaroos
Then there are 6 kangaroos
```

However, the domain language you choose will influence what keyword works best in each context.  For more information <https://docs.cucumber.io/gherkin/reference/#steps>.

#### Given

`Given` steps are used to describe the initial state of a system.  The execution of a `Given` step will usually put the system into well defined state.

To implement a `Given` step you can inherit from the `` `Given` `` class.

``` dart
Given Bob has logged in
```

Would be implemented like so:

``` dart
import 'package:gherkin/gherkin.dart';

class GivenWellKnownUserIsLoggedIn extends Given1<String> {
  @override
  Future<void> executeStep(String wellKnownUsername) async {
    // implement your code
  }

  @override
  RegExp get pattern => RegExp(r"(Bob|Mary|Emma|Jon) has logged in");
}
```

Alternatively, and the now recommended approach is to use the shorthand methods definitions `given, given1, given2, given3, given4 or given5` .

``` dart
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric GivenWellKnownUserIsLoggedIn() {
  return given1(
    RegExp(r"(Bob|Mary|Emma|Jon) has logged in"),
    (wellKnownUsername, context) async {
      // implement your code
    },
  );
}
```

If you need to have more than one Given in a block it is often best to use the additional keywords `And` or `But` .

``` dart
Given Bob has logged in
And opened the dashboard
```

#### Then

`Then` steps are used to describe an expected outcome, or result.  They would typically have an assertion in which can pass or fail.

``` dart
Then I expect 10 apples
```

Would be implemented like so:

``` dart
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric ExpectTheAppleAmount() {
  return then1(
    'I expect {int} apple(s)',
    (count, context) async {
      final actualCount = await _getActualCount();
      context.expectMatch(actualCount, count);
    },
  );
}
```

#### Expects Assertions

**Caveat**: The `expect` library currently only works within the library's own `test` function blocks; so using it with a `Then` step will cause an error.  Therefore, the `expectMatch` or `expectA` or `this.expect` or `context.expect` methods have been added which mimic the underlying functionality of `except` in that they assert that the give is true.  The `Matcher` within Dart's test library still work and can be used as expected.

#### Step Timeout

By default a step will timeout if it exceed the `defaultTimeout` parameter in the configuration file.  In some cases you want have a step that is longer or shorter running and in the case you can optionally proved a custom timeout to that step.  To do this pass in a `Duration` object in the step's call to `super` .

For example, the below sets the step's timeout to 10 seconds.

``` dart
import 'package:gherkin/gherkin.dart';

class TapButtonNTimesStep extends When2WithWorld<String, int, World> {
  TapButtonNTimesStep()
      : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  Future<void> executeStep(String input1, int input2) async {
    // step logic
  }

  @override
  RegExp get pattern => RegExp(r"I tap the {string} button {int} times");
}
```

or using the shorthand method:

``` dart
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric TapButtonNTimesStep() {
 return given2(
    'I tap the {string} button {int} times',
    (buttonName, count, context) async {
      // step logic
    },
    configuration: StepDefinitionConfiguration()
      ..timeout = Duration(seconds: 10),
  );
}
```

#### Multiline Strings

Multiline strings can follow a step and will be give to the step it proceeds as the final argument.  To denote a multiline string the pre and postfix can either be third double or single quotes `""" ... """` or `''' ... '''` .

For example:

``` dart
Given I provide the following "review" comment
"""
Some long review comment.
That can span multiple lines

Skip lines

Maybe even include some numbers
1
2
3
"""
```

The matching step definition would then be:

``` dart
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric GivenTheMultiLineComment() {
  return given2(
    'I provide the following {string} comment',
    (commentType, comment, context) async {
      // implement step
    },
  );
}
```

#### Data tables

``` dart
import 'package:gherkin/gherkin.dart';

/// This step expects a multiline string proceeding it
///
/// For example:
///
/// `When I add the users`
///  | Firstname | Surname | Age | Gender |
///  | Woody     | Johnson | 28  | Male   |
///  | Edith     | Summers | 23  | Female |
///  | Megan     | Hill    | 83  | Female |
StepDefinitionGeneric WhenIAddTheUsers() {
  return when1(
    'I add the users',
    (Table dataTable, context) async {
      for (var row in dataTable.rows) {
        // do something with row
        row.columns.forEach((columnValue) => print(columnValue));
      }

      // or get the table as a map (column values keyed by the header)
      final columns = dataTable.asMap();
      final personOne = columns.elementAt(0);
      final personOneName = personOne["Firstname"];
      print('Name of first user: `$personOneName` ');
    },
  );
}
```

#### Well known step parameters

In addition to being able to define a step's own parameters (by using regex capturing groups) there are some well known parameter types you can include that will automatically match and convert the parameter into the correct type before passing it to you step definition.  (see <https://docs.cucumber.io/cucumber/cucumber-expressions/#parameter-types>).

In most scenarios theses parameters will be enough for you to write quite advanced step definitions.

| Parameter Name | Description                                   | Aliases                        | Type   | Example                                                             |
| -------------- | --------------------------------------------- | ------------------------------ | ------ | ------------------------------------------------------------------- |
| {word}         | Matches a single word surrounded by a quotes  | {word}, {Word}                 | String | `Given I eat a {word}` would match `Given I eat a "worm"` |
| {string}       | Matches one more words surrounded by a quotes | {string}, {String}             | String | `Given I eat a {string}` would match `Given I eat a "can of worms"` |
| {int}          | Matches an integer                            | {int}, {Int}                   | int    | `Given I see {int} worm(s)` would match `Given I see 6 worms` |
| {num}          | Matches an number                             | {num}, {Num}, {float}, {Float} | num    | `Given I see {num} worm(s)` would match `Given I see 0.75 worms` |

Note that you can combine the well known parameters in any step. For example `Given I {word} {int} worm(s)` would match `Given I "see" 6 worms` and also match `Given I "eat" 1 worm`

#### Pluralization

As the aim of a feature is to convey human readable tests it is often desirable to optionally have some word pluralized so you can use the special pluralization syntax to do simple pluralization of some words in your step definition.  For example:

The step string `Given I see {int} worm(s)` has the pluralization syntax on the word "worm" and thus would be matched to both `Given I see 1 worm` and `Given I see 4 worms` .

#### Custom Parameters

While the well know step parameter will be sufficient in most cases there are time when you would want to defined a custom parameter that might be used across more than or step definition or convert into a custom type.

The below custom parameter defines a regex that matches the words "red", "green" or "blue". The matches word is passed into the function which is then able to convert the string into a Color object.  The name of the custom parameter is used to identity the parameter within the step text.  In the below example the word "colour" is used.  This is combined with the pre / post prefixes (which default to "{" and "}") to match to the custom parameter.

``` dart
import 'package:gherkin/gherkin.dart';

enum Colour { red, green, blue }

class ColourParameter extends CustomParameter<Colour> {
  ColourParameter()
      : super("colour", RegExp(r"(red|green|blue)", caseSensitive: true), (c) {
          switch (c.toLowerCase()) {
            case "red":
              return Colour.red;
            case "green":
              return Colour.green;
            case "blue":
              return Colour.blue;
          }
        });
}
```

The step definition would then use this custom parameter like so:

``` dart
import 'package:gherkin/gherkin.dart';
import 'colour_parameter.dart';

StepDefinitionGeneric GivenIAddTheUsers() {
  return given1<Colour>(
    'I pick the colour {colour}',
    (colour, _) async {
      print("The picked colour was: '$colour'");
    },
  );
}
```

This customer parameter would be used like this: `Given I pick the colour red` . When the step is invoked the word "red" would matched and passed to the custom parameter to convert it into a `Colour` enum which is then finally passed to the step definition code as a `Colour` object.

#### World Context (per test scenario shared state)

#### Assertions

### Tags

Tags are a great way of organizing your features and marking them with filterable information.  Tags can be uses to filter the scenarios that are run.  For instance you might have a set of smoke tests to run on every check-in as the full test suite is only ran once a day.  You could also use an `@ignore` or `@todo` tag to ignore certain scenarios that might not be ready to run yet.

You can filter the scenarios by providing a tag expression to your configuration file.  Tag expression are simple infix expressions such as:

 `@smoke`
 `@smoke and @perf`
 `@billing or @onboarding`
 `@smoke and not @ignore`
You can even us brackets to ensure the order of precedence

 `@smoke and not (@ignore or @todo)`
You can use the usual boolean statement "and", "or", "not"

Also see <https://docs.cucumber.io/cucumber/api/#tags>

### Languages

In order to allow features to be written in a number of languages, you can now write the keywords in languages other than English. To improve readability and flow, some languages may have more than one translation for any given keyword. See https://cucumber.io/docs/gherkin/reference/#overview for a list of supported languages.

You can set the default language of feature files in your project via the configuration setting see [featureDefaultLanguage](#defaultLanguage)

For example these two features are the same the keywords are just written in different languages. Note the `` `# language: de` `` on the second feature.  English is the default language.

```
Feature: Calculator
  Tests the addition of two numbers

  Scenario Outline: Add two numbers
    Given the numbers <number_one> and <number_two>
    When they are added
    Then the expected result is <result>

    Examples:
      | number_one | number_two | result |
      | 12         | 5          | 17     |
      | 20         | 5          | 25     |
      | 20937      | 1          | 20938  |
      | 20.937     | -1.937     | 19     |

```

```
# language: de
Funktionalität: Calculator
  Tests the addition of two numbers

  Szenariogrundriss: Add two numbers
    Gegeben sei the numbers <number_one> and <number_two>
    Wenn they are added
    Dann the expected result is <result>

    Beispiele:
      | number_one | number_two | result |
      | 12         | 5          | 17     |
      | 20         | 5          | 25     |
      | 20937      | 1          | 20938  |
      | 20.937     | -1.937     | 19     |

```

Please note the language data is take and attributed to the cucumber project https://github.com/cucumber/cucumber/blob/master/gherkin/gherkin-languages.json

## Hooks

A hook is a point in the execution that custom code can be run.  Hooks can be run at the below points in the test run.

* Before any tests run
* After all the tests have run
* Before each scenario
* After each scenario

To create a hook is easy.  Just inherit from `Hook` and override the method(s) that signifies the point in the process you want to run code at. Note that not all methods need to be override, just the points at which you want to run custom code.

``` dart
import 'package:gherkin/gherkin.dart';

class HookExample extends Hook {
  /// The priority to assign to this hook.
  /// Higher priority gets run first so a priority of 10 is run before a priority of 2
  int get priority => 1;

  @override
  /// Run before any scenario in a test run have executed
  Future<void> onBeforeRun(TestConfiguration config) async {
    print("before run hook");
  }

  @override
  /// Run after all scenarios in a test run have completed
  Future<void> onAfterRun(TestConfiguration config) async {
    print("after run hook");
  }

  @override
  /// Run before a scenario and it steps are executed
  Future<void> onBeforeScenario(
      TestConfiguration config, String scenario) async {
    print("running hook before scenario '$scenario'");
  }

  @override
  /// Run after the scenario world is created but run before a scenario and its steps are executed
  /// Might not be invoked if there is not a world object
  Future<void> onAfterScenarioWorldCreated(World world, String scenario) {
    print("running hook after world scenario created'$scenario'");
  }

  @override
  /// Run after a scenario has executed
  Future<void> onAfterScenario(
      TestConfiguration config, String scenario) async {
    print("running hook after scenario '$scenario'");
  }
}
```

Finally ensure the hook is added to the hook collection in your configuration file.

``` dart
import 'dart:async';
import 'package:gherkin/gherkin.dart';
import 'supporting_files/hooks/hook_example.dart';
import 'supporting_files/parameters/power_of_two.parameter.dart';
import 'supporting_files/steps/given_the_numbers.step.dart';
import 'supporting_files/steps/given_the_powers_of_two.step.dart';
import 'supporting_files/steps/then_expect_numeric_result.step.dart';
import 'supporting_files/steps/when_numbers_are_added.step.dart';
import 'supporting_files/worlds/custom_world.world.dart';

Future<void> main() {
  final config = TestConfiguration(
    features: [RegExp(r"features/.*\.feature")],
    reporters: [
      StdoutReporter(MessageLevel.error),
      ProgressReporter(),
      TestRunSummaryReporter(),
    ],
    hooks: [HookExample()],
    customStepParameterDefinitions: [PowerOfTwoParameter()],
    createWorld: (config) => Future.value(CalculatorWorld()),
    stepDefinitions: [
      givenTheNumbers(),
      givenThePowersOfTwo(),
      whenTheStoredNumbersAreAdded(),
      thenExpectNumericResult(),
    ],
    stopAfterTestFailed: true,
  );

  return GherkinRunner().execute(config);
}
```

## Reporting

A reporter is a class that is able to report on the progress of the test run. In it simplest form it could just print messages to the console or be used to tell a build server such as TeamCity of the progress of the test run.  The library has a number of built in reporters.

* `StdoutReporter` - prints all messages from the test run to the console.
* `ProgressReporter` - prints the result of each scenario and step to the console - colours the output.
* `TestRunSummaryReporter` - prints the results and duration of the test run once the run has completed - colours the output.
* `JsonReporter` - creates a JSON file with the results of the test run which can then be used by 'https://www.npmjs.com/package/cucumber-html-reporter.' to create a HTML report.  You can pass in the file path of the json file to be created.

You can create your own custom reporter by inheriting from the base `Reporter` class and overriding the one or many of the methods to direct the output message.  The `Reporter` defines the following methods that can be overridden.  All methods must return a `Future<void>` and can be async.

* `test` - where test started or finished
* `feature` - where feature started or finished
* `scenario` - where scenario started or finished
* `step` - where test started or finished
* `onException`
* `message`
* `dispose`

For all field who's stared `on` (example, `step`) has to methods for class `ReportActionHandler`:

* `onStared`
* `onFinished`

All methods nullable. If reporter has non-nullable value he will call them.

Once you have created your custom reporter don't forget to add it to the `reporters` configuration file property.

*Note*: PR's of new reporters are *always* welcome.
