import 'package:gherkin/gherkin.dart';
import 'package:test/test.dart';
import '../mocks/hook_mock.dart';

void main() {
  group('orders hooks', () {
    test('executes hooks in correct order', () async {
      final executionOrder = <int>[];
      final hookOne = HookMock(
        providedPriority: 0,
        onBeforeRunCode: () => executionOrder.add(3),
      );
      final hookTwo = HookMock(
        providedPriority: 10,
        onBeforeRunCode: () => executionOrder.add(2),
      );
      final hookThree = HookMock(
        providedPriority: 20,
        onBeforeRunCode: () => executionOrder.add(1),
      );
      final hookFour = HookMock(
        providedPriority: -1,
        onBeforeRunCode: () => executionOrder.add(4),
      );

      final aggregatedHook = AggregatedHook();
      aggregatedHook.addHooks([hookOne, hookTwo, hookThree, hookFour]);
      await aggregatedHook.onBeforeRun(TestConfiguration.standard([]));
      expect(executionOrder, [1, 2, 3, 4]);
      expect(hookOne.onBeforeRunInvocationCount, 1);
      expect(hookTwo.onBeforeRunInvocationCount, 1);
      expect(hookThree.onBeforeRunInvocationCount, 1);
      expect(hookFour.onBeforeRunInvocationCount, 1);
      await aggregatedHook.onAfterRun(TestConfiguration.standard([]));
      expect(hookOne.onAfterRunInvocationCount, 1);
      expect(hookTwo.onAfterRunInvocationCount, 1);
      expect(hookThree.onAfterRunInvocationCount, 1);
      expect(hookFour.onAfterRunInvocationCount, 1);
      await aggregatedHook.onBeforeScenario(
        TestConfiguration.standard([]),
        '',
        const Iterable.empty(),
      );
      expect(hookOne.onBeforeScenarioInvocationCount, 1);
      expect(hookTwo.onBeforeScenarioInvocationCount, 1);
      expect(hookThree.onBeforeScenarioInvocationCount, 1);
      expect(hookFour.onBeforeScenarioInvocationCount, 1);
      await aggregatedHook.onBeforeStep(World(), '');
      expect(hookOne.onBeforeStepInvocationCount, 1);
      expect(hookTwo.onBeforeStepInvocationCount, 1);
      expect(hookThree.onBeforeStepInvocationCount, 1);
      expect(hookFour.onBeforeStepInvocationCount, 1);
      await aggregatedHook.onAfterScenarioWorldCreated(
        World(),
        '',
        const Iterable.empty(),
      );
      expect(hookOne.onAfterScenarioWorldCreatedInvocationCount, 1);
      expect(hookTwo.onAfterScenarioWorldCreatedInvocationCount, 1);
      expect(hookThree.onAfterScenarioWorldCreatedInvocationCount, 1);
      expect(hookFour.onAfterScenarioWorldCreatedInvocationCount, 1);
      await aggregatedHook.onAfterStep(
        World(),
        '',
        StepResult(
          0,
          StepExecutionResult.skipped,
        ),
      );
      expect(hookOne.onAfterStepInvocationCount, 1);
      expect(hookTwo.onAfterStepInvocationCount, 1);
      expect(hookThree.onAfterStepInvocationCount, 1);
      expect(hookFour.onAfterStepInvocationCount, 1);
    });
  });
}
