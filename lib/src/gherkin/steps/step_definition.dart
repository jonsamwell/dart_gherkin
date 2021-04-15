import 'package:gherkin/src/expect/expect_mimic.dart';

import '../../utils/perf.dart';
import './step_run_result.dart';
import '../../reporters/reporter.dart';
import './step_configuration.dart';
import './world.dart';
import '../exceptions/parameter_count_mismatch_error.dart';
import 'dart:async';

abstract class StepDefinitionGeneric<TWorld extends World> {
  final StepDefinitionConfiguration? config;
  final int _expectParameterCount;
  TWorld? _world;
  Reporter? _reporter;
  Duration? _timeout;
  Pattern get pattern;

  StepDefinitionGeneric(this.config, this._expectParameterCount) {
    _timeout = config?.timeout;
  }

  TWorld get world => _world!;
  Duration? get timeout => _timeout;
  Reporter get reporter => _reporter!;

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
    } on Error catch (e, st) {
      return ErroredStepResult(
        elapsedMilliseconds,
        StepExecutionResult.error,
        Exception(e.toString()),
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

    return StepResult(elapsedMilliseconds, StepExecutionResult.pass);
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
