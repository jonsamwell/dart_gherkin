import 'dart:async';
import 'package:gherkin/gherkin.dart';
import 'package:gherkin/src/expect/expect_mimic.dart';
import 'package:test/test.dart';

import '../../mocks/reporter_mock.dart';

class StepDefinitionMock extends StepDefinitionGeneric<World> {
  int invocationCount = 0;
  final Func0<Future<void>>? code;

  StepDefinitionMock(
    StepDefinitionConfiguration config,
    int expectParameterCount, [
    this.code,
  ]) : super(config, expectParameterCount);

  @override
  Future<void> onRun(Iterable parameters) async {
    invocationCount += 1;
    if (code != null) {
      await code!();
    }
  }

  @override
  RegExp get pattern => RegExp('.');
}

void main() {
  group('onRun', () {
    group('parameter guard', () {
      test('throws exception when parameter counts mismatch', () async {
        final step = StepDefinitionMock(StepDefinitionConfiguration(), 2);
        expect(
          () => step.run(
            World(),
            ReporterMock(),
            const Duration(seconds: 1),
            const Iterable.empty(),
          ),
          throwsA(
            (e) =>
                e is GherkinStepParameterMismatchException &&
                e.message ==
                    'StepDefinitionMock parameter count mismatch. '
                        'Expect 2 parameters but got 0. '
                        'Ensure you are extending the correct '
                        'step class which would be Given',
          ),
        );
        expect(step.invocationCount, 0);
      });

      test(
          'throws exception when parameter counts mismatch listing required step type',
          () async {
        final step = StepDefinitionMock(StepDefinitionConfiguration(), 2);
        expect(
          () => step.run(
            World(),
            ReporterMock(),
            const Duration(seconds: 1),
            [1],
          ),
          throwsA(
            (e) =>
                e is GherkinStepParameterMismatchException &&
                e.message ==
                    'StepDefinitionMock parameter count mismatch. Expect 2 parameters but got 1. '
                        'Ensure you are extending the correct step class which would be Given1<TInputType0>',
          ),
        );
        expect(step.invocationCount, 0);
      });

      test('runs step when correct number of parameters provided', () async {
        final step = StepDefinitionMock(StepDefinitionConfiguration(), 1);
        await step.run(
          World(),
          ReporterMock(),
          const Duration(seconds: 1),
          [1],
        );
        expect(step.invocationCount, 1);
      });
    });

    group('exception reported', () {
      test('when exception is throw in test it is report as an error',
          () async {
        final step = StepDefinitionMock(
          StepDefinitionConfiguration(),
          0,
          () async => throw Exception('1'),
        );
        final result = await step.run(
          World(),
          ReporterMock(),
          const Duration(milliseconds: 1),
          const Iterable.empty(),
        );
        expect(
          result is ErroredStepResult &&
              result.result == StepExecutionResult.error &&
              result.exception is Exception &&
              result.exception.toString() == 'Exception: 1',
          true,
        );
      });
    });

    group('expectation failures reported', () {
      test('when an expectation fails the step is failed', () async {
        final step = StepDefinitionMock(
          StepDefinitionConfiguration(),
          0,
          () async => throw GherkinTestFailure('1'),
        );
        expect(
          await step.run(
            World(),
            ReporterMock(),
            const Duration(milliseconds: 1),
            const Iterable.empty(),
          ),
          (r) {
            return r is StepResult &&
                r.result == StepExecutionResult.fail &&
                r.resultReason == '1';
          },
        );
      });
    });
  });
}
