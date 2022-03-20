import 'dart:async';

import 'package:gherkin/src/expect/expect_mimic.dart';
import 'package:gherkin/src/gherkin/exceptions/parameter_count_mismatch_error.dart';
import 'package:gherkin/src/gherkin/steps/step_configuration.dart';
import 'package:gherkin/src/gherkin/steps/step_run_result.dart';
import 'package:gherkin/src/gherkin/steps/world.dart';
import 'package:gherkin/src/reporters/reporter.dart';
import 'package:gherkin/src/utils/perf.dart';

abstract class StepDefinitionGeneric<TWorld extends World> {
  final StepDefinitionConfiguration? config;
  final int _expectParameterCount;
  late TWorld _world;
  late Reporter _reporter;
  Duration? _timeout;
  Pattern get pattern;

  StepDefinitionGeneric(this.config, this._expectParameterCount) {
    _timeout = config?.timeout;
  }

  TWorld get world => _world;
  Duration? get timeout => _timeout;
  Reporter get reporter => _reporter;

  Future<StepResult> run(
    TWorld world,
    Reporter reporter,
    Duration defaultTimeout,
    Iterable<dynamic> parameters,
  ) async {
    _ensureParameterCount(parameters.length, _expectParameterCount);
    late int elapsedMilliseconds;
    try {
      final timeout = _timeout ?? defaultTimeout;
      await Perf.measure(
        () async {
          _world = world;
          _reporter = reporter;
          _timeout = timeout;
          final result = await onRun(parameters).timeout(
            timeout,
          );

          return result;
        },
        (ms) => elapsedMilliseconds = ms,
      );
    } on GherkinTestFailure catch (tf) {
      return StepResult(
        elapsedMilliseconds,
        StepExecutionResult.fail,
        tf.message,
      );
    } on TimeoutException catch (te, st) {
      return ErroredStepResult(
        elapsedMilliseconds,
        StepExecutionResult.timeout,
        te,
        st,
      );
    } on Exception catch (e, st) {
      return ErroredStepResult(
        elapsedMilliseconds,
        StepExecutionResult.error,
        e,
        st,
      );
    } catch (e, st) {
      return ErroredStepResult(
        elapsedMilliseconds,
        StepExecutionResult.error,
        e,
        st,
      );
    }

    return StepResult(elapsedMilliseconds, StepExecutionResult.passed);
  }

  Future<void> onRun(Iterable<dynamic> parameters);

  void _ensureParameterCount(int actual, int expected) {
    if (actual != expected) {
      throw GherkinStepParameterMismatchException(
        runtimeType,
        expected,
        actual,
      );
    }
  }
}
