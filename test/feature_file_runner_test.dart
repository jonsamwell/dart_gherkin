import 'package:gherkin/gherkin.dart';
import 'package:gherkin/src/configuration.dart';
import 'package:gherkin/src/feature_file_runner.dart';
import 'package:gherkin/src/gherkin/exceptions/step_not_defined_error.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/feature.dart';
import 'package:gherkin/src/gherkin/runnables/feature_file.dart';
import 'package:gherkin/src/gherkin/runnables/scenario.dart';
import 'package:gherkin/src/gherkin/runnables/step.dart';
import 'package:gherkin/src/gherkin/runnables/tags.dart';
import 'package:gherkin/src/gherkin/steps/exectuable_step.dart';
import 'package:gherkin/src/gherkin/steps/step_run_result.dart';
import 'package:test/test.dart';

import 'mocks/gherkin_expression_mock.dart';
import 'mocks/hook_mock.dart';
import 'mocks/reporter_mock.dart';
import 'mocks/step_definition_mock.dart';
import 'mocks/tag_expression_evaluator_mock.dart';
import 'mocks/world_mock.dart';

void main() {
  final emptyDebuggable = RunnableDebugInformation('File Path', 0, 'Line text');
  group('run', () {
    test('run simple feature file scenario', () async {
      final stepDefinition = MockStepDefinition();
      final executableStep = ExecutableStep(MockGherkinExpression((_) => true), stepDefinition);
      final runner = FeatureFileRunner(
          TestConfiguration(), MockTagExpressionEvaluator(), [executableStep], ReporterMock(), HookMock());

      final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, 'Given I do a'));
      final scenario = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(step);
      final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario);
      final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
      await runner.run(featureFile);
      expect(stepDefinition.hasRun, true);
      expect(stepDefinition.runCount, 1);
    });

    test('world context is created and disposed', () async {
      final worldMock = WorldMock();
      var worldCreationFnInoked = false;
      final stepDefiniton = MockStepDefinition();
      final executableStep = ExecutableStep(MockGherkinExpression((_) => true), stepDefiniton);
      final runner = FeatureFileRunner(
          TestConfiguration()
            ..createWorld = (_) async {
              worldCreationFnInoked = true;
              return worldMock;
            },
          MockTagExpressionEvaluator(),
          [executableStep],
          ReporterMock(),
          HookMock());

      final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, 'Given I do a'));
      final scenario = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(step);
      final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario);
      final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
      await runner.run(featureFile);
      expect(worldCreationFnInoked, true);
      expect(worldMock.disposeFnInvoked, true);
    });

    test('steps are skipped if previous step failed', () async {
      final stepTextOne = 'Given I do a';
      final stepTextTwo = 'Given I do b';
      final stepDefiniton = MockStepDefinition((_) => throw Exception());
      final stepDefinitonTwo = MockStepDefinition();
      final executableStep = ExecutableStep(MockGherkinExpression((s) => s == stepTextOne), stepDefiniton);
      final executableStepTwo = ExecutableStep(MockGherkinExpression((s) => s == stepTextTwo), stepDefinitonTwo);
      final runner = FeatureFileRunner(TestConfiguration(), MockTagExpressionEvaluator(),
          [executableStep, executableStepTwo], ReporterMock(), HookMock());

      final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, stepTextOne));
      final stepTwo = StepRunnable('Step 2', RunnableDebugInformation('', 0, stepTextTwo));
      final scenario = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(step)..steps.add(stepTwo);
      final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario);
      final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
      await runner.run(featureFile);
      expect(stepDefiniton.hasRun, true);
      expect(stepDefiniton.runCount, 1);
      expect(stepDefinitonTwo.runCount, 0);
    });

    test('feature are skipped if previous feature failed', () async {
      final stepTextOne = 'Given I do a';
      final stepTextTwo = 'Given I do b';
      final stepDefiniton = MockStepDefinition((_) => throw Exception());
      final stepDefinitonTwo = MockStepDefinition();
      final executableStep = ExecutableStep(MockGherkinExpression((s) => s == stepTextOne), stepDefiniton);
      final executableStepTwo = ExecutableStep(MockGherkinExpression((s) => s == stepTextTwo), stepDefinitonTwo);
      final runner = FeatureFileRunner(TestConfiguration()..exitAfterTestFailed = true, MockTagExpressionEvaluator(),
          [executableStep, executableStepTwo], ReporterMock(), HookMock());
      final stepOne = StepRunnable('Step 1', RunnableDebugInformation('', 0, stepTextOne));
      final stepTwo = StepRunnable('Step 2', RunnableDebugInformation('', 0, stepTextTwo));
      final scenarioOne = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(stepOne);
      final scenarioTwo = ScenarioRunnable('Scenario: 2', emptyDebuggable)..steps.add(stepTwo);
      final featureOne = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenarioOne);
      final featureTwo = FeatureRunnable('2', emptyDebuggable)..scenarios.add(scenarioTwo);
      final featureFile = FeatureFile(emptyDebuggable)..features.addAll([featureOne, featureTwo]);
      await runner.run(featureFile);
      expect(stepDefiniton.hasRun, true);
      expect(stepDefiniton.runCount, 1);
      expect(stepDefinitonTwo.runCount, 0);
    });

    test('scenario are skipped if previous scenario failed', () async {
      final stepTextOne = 'Given I do a';
      final stepTextTwo = 'Given I do b';
      final stepDefiniton = MockStepDefinition((_) => throw Exception());
      final stepDefinitonTwo = MockStepDefinition();
      final executableStep = ExecutableStep(MockGherkinExpression((s) => s == stepTextOne), stepDefiniton);
      final executableStepTwo = ExecutableStep(MockGherkinExpression((s) => s == stepTextTwo), stepDefinitonTwo);
      final runner = FeatureFileRunner(TestConfiguration()..exitAfterTestFailed = true, MockTagExpressionEvaluator(),
          [executableStep, executableStepTwo], ReporterMock(), HookMock());
      final stepOne = StepRunnable('Step 1', RunnableDebugInformation('', 0, stepTextOne));
      final stepTwo = StepRunnable('Step 2', RunnableDebugInformation('', 0, stepTextTwo));
      final scenarioOne = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(stepOne);
      final scenarioTwo = ScenarioRunnable('Scenario: 2', emptyDebuggable)..steps.add(stepTwo);
      final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.addAll([scenarioOne, scenarioTwo]);
      final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
      await runner.run(featureFile);
      expect(stepDefiniton.hasRun, true);
      expect(stepDefiniton.runCount, 1);
      expect(stepDefinitonTwo.runCount, 0);
    });

    test('Unchecked errors are handled gracefully', () async {
      final stepTextOne = 'Given I do a';
      final stepTextTwo = 'Given I do b';
      final stepDefiniton = MockStepDefinition((_) => throw TypeError());
      final stepDefinitonTwo = MockStepDefinition();
      final executableStep = ExecutableStep(MockGherkinExpression((s) => s == stepTextOne), stepDefiniton);
      final executableStepTwo = ExecutableStep(MockGherkinExpression((s) => s == stepTextTwo), stepDefinitonTwo);
      final runner = FeatureFileRunner(TestConfiguration(), MockTagExpressionEvaluator(),
          [executableStep, executableStepTwo], ReporterMock(), HookMock());

      final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, stepTextOne));
      final stepTwo = StepRunnable('Step 2', RunnableDebugInformation('', 0, stepTextTwo));
      final scenario = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(step)..steps.add(stepTwo);
      final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario);
      final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
      await runner.run(featureFile);
      expect(stepDefiniton.hasRun, true);
      expect(stepDefiniton.runCount, 1);
      expect(stepDefinitonTwo.runCount, 0);
    });

    test('Unhandled async errors are handled gracefully', () async {
      final stepTextOne = 'Given I do a';
      final stepTextTwo = 'Given I do b';
      final stepDefiniton = MockStepDefinition();
      final stepDefinitonTwo = MockStepDefinition();
      final executableStep = ExecutableStep(MockGherkinExpression((s) => s == stepTextOne), stepDefiniton);
      final executableStepTwo = ExecutableStep(MockGherkinExpression((s) => s == stepTextTwo), stepDefinitonTwo);
      final runner = FeatureFileRunner(
          TestConfiguration()
            ..createWorld = (c) => Future<World>.value(
                WorldMockThatThrowsWhenDisposed()), // error is thrown here when the world is disposed
          MockTagExpressionEvaluator(),
          [
            executableStep,
            executableStepTwo,
          ],
          ReporterMock(),
          HookMock());

      final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, stepTextOne));
      final stepTwo = StepRunnable('Step 2', RunnableDebugInformation('', 0, stepTextTwo));
      final scenario = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(step)..steps.add(stepTwo);
      final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario);
      final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
      final result = await runner.run(featureFile);
      expect(result, false);
      expect(stepDefiniton.hasRun, true);
      expect(stepDefiniton.runCount, 1);
      expect(stepDefinitonTwo.runCount, 1);
    });

    group('step matching', () {
      test('exception throw when matching step definition not found', () async {
        final stepDefiniton = MockStepDefinition();
        final executableStep = ExecutableStep(MockGherkinExpression((_) => false), stepDefiniton);
        final runner = FeatureFileRunner(
            TestConfiguration(), MockTagExpressionEvaluator(), [executableStep], ReporterMock(), HookMock());

        final step = StepRunnable('Step 1', RunnableDebugInformation('File Path', 2, "Given I do 'a'"));
        final scenario = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(step);
        final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario);
        final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
        expect(
            () async => await runner.run(featureFile),
            throwsA(allOf(
                (e) => e is GherkinStepNotDefinedException,
                (e) =>
                    e.message ==
                    '''      Step definition not found for text:

        'Given I do 'a''

      File path: File Path#2
      Line:      Given I do 'a'

      ---------------------------------------------

      You must implement the step like below and add the class to the 'stepDefinitions' property in your configuration:

      /// The 'Given' class prefix can be replaced with 'Then', 'When' 'And' or 'But'
      /// All classes can take up to 5 input parameters. With more, you should probably use a table.
      /// For example: `When4<String, bool, int, num>`
      /// You can also specify the type of world context you want
      /// `When4WithWorld<String, bool, int, num, MyWorld>`
      class Given_Given_I_do__a_ extends Given1<String> {
        @override
        RegExp get pattern => RegExp(r"I do 'a'");

        @override
        Future<void> executeStep(String input1) async {
          // If the step is "Given I do a 'windy pop'"
          // in this example, input1 would equal 'windy pop'

          // your code...
        }
      }
      ''')));
      });
    });

    group('step parameters', () {
      test('table parameters are given to the step', () async {
        var tableParameterProvided = false;
        final stepDefiniton = MockStepDefinition((Iterable<dynamic> parameters) async {
          tableParameterProvided = parameters.first is Table;
        }, 1);
        final executableStep = ExecutableStep(MockGherkinExpression((_) => true), stepDefiniton);
        final runner = FeatureFileRunner(
            TestConfiguration(), MockTagExpressionEvaluator(), [executableStep], ReporterMock(), HookMock());

        final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, 'Given I do a'));
        step.table = Table(null, null);
        final scenario = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(step);
        final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario);
        final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
        await runner.run(featureFile);
        expect(stepDefiniton.hasRun, true);
        expect(stepDefiniton.runCount, 1);
        expect(tableParameterProvided, true);
      });
    });

    group('hooks', () {
      test('hook is called when starting and finishing scenarios', () async {
        final hookMock = HookMock();
        final stepDefiniton = MockStepDefinition();
        final executableStep = ExecutableStep(MockGherkinExpression((_) => true), stepDefiniton);
        final runner = FeatureFileRunner(
            TestConfiguration(), MockTagExpressionEvaluator(), [executableStep], ReporterMock(), hookMock);

        final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, 'Given I do a'));
        final scenario1 = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(step);
        final scenario2 = ScenarioRunnable('Scenario: 2', emptyDebuggable)..steps.add(step);
        final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario1)..scenarios.add(scenario2);
        final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
        await runner.run(featureFile);
        expect(hookMock.onBeforeScenarioInvocationCount, 2);
        expect(hookMock.onAfterScenarioInvocationCount, 2);
      });

      test('scenario tags are passed to hook', () async {
        final hookMock = HookMock();
        final stepDefiniton = MockStepDefinition();
        final tagOne = TagsRunnable(emptyDebuggable)..tags = ['@tag1'];
        final tagTwo = TagsRunnable(emptyDebuggable)..tags = ['@tag2'];
        final executableStep = ExecutableStep(MockGherkinExpression((_) => true), stepDefiniton);
        final runner = FeatureFileRunner(
            TestConfiguration(), MockTagExpressionEvaluator(), [executableStep], ReporterMock(), hookMock);

        final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, 'Given I do a'));
        final scenario1 = ScenarioRunnable('Scenario: 1', emptyDebuggable)
          ..steps.add(step)
          ..addTag(tagTwo);
        final feature = FeatureRunnable('1', emptyDebuggable)
          ..scenarios.add(scenario1)
          ..addTag(tagOne);
        final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
        await runner.run(featureFile);
        expect(hookMock.onBeforeScenarioInvocationCount, 1);
        expect(hookMock.onAfterScenarioInvocationCount, 1);
        expect(hookMock.onBeforeScenarioTags!.length, 2);
        expect(hookMock.onAfterScenarioTags.length, 2);
        expect(hookMock.onBeforeScenarioTags!.elementAt(0).name, tagTwo.tags!.elementAt(0));
        expect(hookMock.onBeforeScenarioTags!.elementAt(1).name, tagOne.tags!.elementAt(0));
        expect(hookMock.onBeforeScenarioTags!.elementAt(1).isInherited, true);
        expect(hookMock.onAfterScenarioTags.elementAt(0).name, tagTwo.tags!.elementAt(0));
        expect(hookMock.onAfterScenarioTags.elementAt(1).name, tagOne.tags!.elementAt(0));
        expect(hookMock.onAfterScenarioTags.elementAt(1).isInherited, true);
      });
    });

    group('reporter', () {
      test('reporter is called when starting and finishing runnable blocks', () async {
        final reporterMock = ReporterMock();
        final stepDefiniton = MockStepDefinition();
        final executableStep = ExecutableStep(MockGherkinExpression((_) => true), stepDefiniton);
        final runner = FeatureFileRunner(
            TestConfiguration(), MockTagExpressionEvaluator(), [executableStep], reporterMock, HookMock());

        final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, 'Given I do a'));
        final scenario1 = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(step);
        final scenario2 = ScenarioRunnable('Scenario: 2', emptyDebuggable)..steps.add(step)..steps.add(step);
        final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario1)..scenarios.add(scenario2);
        final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
        await runner.run(featureFile);
        expect(reporterMock.onFeatureStartedInvocationCount, 1);
        expect(reporterMock.onFeatureFinishedInvocationCount, 1);
        expect(reporterMock.onFeatureStartedInvocationCount, 1);
        expect(reporterMock.onFeatureFinishedInvocationCount, 1);
        expect(reporterMock.onScenarioStartedInvocationCount, 2);
        expect(reporterMock.onScenarioFinishedInvocationCount, 2);
        expect(reporterMock.onStepStartedInvocationCount, 3);
        expect(reporterMock.onStepFinishedInvocationCount, 3);
      });

      test('step reported with correct finishing value when passing', () async {
        StepFinishedMessage? finishedMessage;
        final reporterMock = ReporterMock();
        reporterMock.onStepFinishedFn = (message) => finishedMessage = message;
        final stepDefiniton = MockStepDefinition();
        final executableStep = ExecutableStep(MockGherkinExpression((_) => true), stepDefiniton);
        final runner = FeatureFileRunner(
            TestConfiguration(), MockTagExpressionEvaluator(), [executableStep], reporterMock, HookMock());

        final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, 'Given I do a'));
        final scenario1 = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(step);
        final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario1);
        final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
        await runner.run(featureFile);
        expect(stepDefiniton.hasRun, true);
        expect(finishedMessage, (m) => m.name == 'Step 1');
        expect(finishedMessage, (m) => m.result.result == StepExecutionResult.pass);
      });

      test('step reported with correct finishing value when failing', () async {
        StepFinishedMessage? finishedMessage;
        final testFailureException = TestFailure('FAILED');
        final reporterMock = ReporterMock();
        reporterMock.onStepFinishedFn = (message) => finishedMessage = message;
        final stepDefiniton = MockStepDefinition((_) => throw testFailureException);
        final executableStep = ExecutableStep(MockGherkinExpression((_) => true), stepDefiniton);
        final runner = FeatureFileRunner(
            TestConfiguration(), MockTagExpressionEvaluator(), [executableStep], reporterMock, HookMock());

        final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, 'Given I do a'));
        final scenario1 = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(step);
        final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario1);
        final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
        await runner.run(featureFile);
        expect(stepDefiniton.hasRun, true);
        expect(finishedMessage, (m) => m.name == 'Step 1');
        expect(finishedMessage, (m) => m.result.result == StepExecutionResult.fail);
      });

      test('step reported with correct finishing value when unhandled exception raised', () async {
        StepFinishedMessage? finishedMessage;
        final reporterMock = ReporterMock();
        reporterMock.onStepFinishedFn = (message) => finishedMessage = message;
        final stepDefiniton = MockStepDefinition((_) async => await Future.delayed(const Duration(seconds: 2)));
        final executableStep = ExecutableStep(MockGherkinExpression((_) => true), stepDefiniton);
        final runner = FeatureFileRunner(TestConfiguration()..defaultTimeout = const Duration(milliseconds: 1),
            MockTagExpressionEvaluator(), [executableStep], reporterMock, HookMock());

        final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, 'Given I do a'));
        final scenario1 = ScenarioRunnable('Scenario: 1', emptyDebuggable)..steps.add(step);
        final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario1);
        final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
        await runner.run(featureFile);
        expect(stepDefiniton.hasRun, true);
        expect(finishedMessage, (m) => m.name == 'Step 1');
        expect(finishedMessage, (m) => m.result.result == StepExecutionResult.timeout);
      });

      test('skipped step reported correctly', () async {
        final finishedMessages = <StepFinishedMessage?>[];
        final reporterMock = ReporterMock();
        reporterMock.onStepFinishedFn = (message) => finishedMessages.add(message);

        final stepTextOne = 'Given I do a';
        final stepTextTwo = 'Given I do b';
        final stepTextThree = 'Given I do c';
        final stepDefiniton = MockStepDefinition((_) => throw Exception());
        final stepDefinitonTwo = MockStepDefinition();
        final stepDefinitonThree = MockStepDefinition();
        final executableStep = ExecutableStep(MockGherkinExpression((s) => s == stepTextOne), stepDefiniton);
        final executableStepTwo = ExecutableStep(MockGherkinExpression((s) => s == stepTextTwo), stepDefinitonTwo);
        final executableStepThree =
            ExecutableStep(MockGherkinExpression((s) => s == stepTextThree), stepDefinitonThree);
        final runner = FeatureFileRunner(
            TestConfiguration()..defaultTimeout = const Duration(milliseconds: 1),
            MockTagExpressionEvaluator(),
            [executableStep, executableStepTwo, executableStepThree],
            reporterMock,
            HookMock());

        final step = StepRunnable('Step 1', RunnableDebugInformation('', 0, stepTextOne));
        final stepTwo = StepRunnable('Step 2', RunnableDebugInformation('', 0, stepTextTwo));
        final stepThree = StepRunnable('Step 3', RunnableDebugInformation('', 0, stepTextThree));
        final scenario1 = ScenarioRunnable('Scenario: 1', emptyDebuggable)
          ..steps.add(step)
          ..steps.add(stepTwo)
          ..steps.add(stepThree);
        final feature = FeatureRunnable('1', emptyDebuggable)..scenarios.add(scenario1);
        final featureFile = FeatureFile(emptyDebuggable)..features.add(feature);
        await runner.run(featureFile);
        expect(stepDefiniton.hasRun, true);
        expect(finishedMessages.length, 3);
        expect(finishedMessages.elementAt(0)!.result.result, StepExecutionResult.error);
        expect(finishedMessages.elementAt(1)!.result.result, StepExecutionResult.skipped);
        expect(finishedMessages.elementAt(2)!.result.result, StepExecutionResult.skipped);
      });
    });
  });
}
