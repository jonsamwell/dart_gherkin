import 'package:gherkin/src/expect/expect_mimic.dart';
import 'package:gherkin/src/gherkin/steps/step_configuration.dart';
import 'package:gherkin/src/gherkin/steps/step_definition.dart';
import 'package:gherkin/src/gherkin/steps/world.dart';
import 'package:gherkin/src/reporters/reporter.dart';

abstract class StepDefinitionBase<TWorld extends World>
    extends StepDefinitionGeneric<TWorld> {
  StepDefinitionBase(
    StepDefinitionConfiguration? config,
    int expectParameterCount,
  ) : super(config, expectParameterCount);

  void expect(
    dynamic actual,
    dynamic matcher, {
    String? reason,
  }) =>
      ExpectMimic().expect(
        actual,
        matcher,
        reason: reason,
      );

  void expectA(
    dynamic actual,
    dynamic matcher, {
    String? reason,
  }) =>
      expect(
        actual,
        matcher,
        reason: reason,
      );

  void expectMatch(
    dynamic actual,
    dynamic matcher, {
    String? reason,
  }) =>
      expect(
        actual,
        matcher,
        reason: reason,
      );
}

abstract class StepDefinition<TWorld extends World>
    extends StepDefinitionBase<TWorld> {
  StepDefinition([StepDefinitionConfiguration? configuration])
      : super(configuration, 0);

  @override
  Future<void> onRun(Iterable<dynamic> parameters) => executeStep();

  Future<void> executeStep();
}

abstract class StepDefinition1<TWorld extends World, TInput1>
    extends StepDefinitionBase<TWorld> {
  StepDefinition1([StepDefinitionConfiguration? configuration])
      : super(configuration, 1);

  @override
  Future<void> onRun(Iterable<dynamic> parameters) =>
      executeStep(parameters.elementAt(0) as TInput1);

  Future<void> executeStep(TInput1 input1);
}

abstract class StepDefinition2<TWorld extends World, TInput1, TInput2>
    extends StepDefinitionBase<TWorld> {
  StepDefinition2([StepDefinitionConfiguration? configuration])
      : super(configuration, 2);

  @override
  Future<void> onRun(Iterable<dynamic> parameters) => executeStep(
        parameters.elementAt(0) as TInput1,
        parameters.elementAt(1) as TInput2,
      );

  Future<void> executeStep(
    TInput1 input1,
    TInput2 input2,
  );
}

abstract class StepDefinition3<TWorld extends World, TInput1, TInput2, TInput3>
    extends StepDefinitionBase<TWorld> {
  StepDefinition3([StepDefinitionConfiguration? configuration])
      : super(configuration, 3);

  @override
  Future<void> onRun(Iterable<dynamic> parameters) => executeStep(
        parameters.elementAt(0) as TInput1,
        parameters.elementAt(1) as TInput2,
        parameters.elementAt(2) as TInput3,
      );

  Future<void> executeStep(
    TInput1 input1,
    TInput2 input2,
    TInput3 input3,
  );
}

abstract class StepDefinition4<TWorld extends World, TInput1, TInput2, TInput3,
    TInput4> extends StepDefinitionBase<TWorld> {
  StepDefinition4([StepDefinitionConfiguration? configuration])
      : super(configuration, 4);

  @override
  Future<void> onRun(Iterable<dynamic> parameters) => executeStep(
        parameters.elementAt(0) as TInput1,
        parameters.elementAt(1) as TInput2,
        parameters.elementAt(2) as TInput3,
        parameters.elementAt(3) as TInput4,
      );

  Future<void> executeStep(
    TInput1 input1,
    TInput2 input2,
    TInput3 input3,
    TInput4 input4,
  );
}

abstract class StepDefinition5<TWorld extends World, TInput1, TInput2, TInput3,
    TInput4, TInput5> extends StepDefinitionBase<TWorld> {
  StepDefinition5([StepDefinitionConfiguration? configuration])
      : super(configuration, 5);

  @override
  Future<void> onRun(Iterable<dynamic> parameters) => executeStep(
        parameters.elementAt(0) as TInput1,
        parameters.elementAt(1) as TInput2,
        parameters.elementAt(2) as TInput3,
        parameters.elementAt(3) as TInput4,
        parameters.elementAt(4) as TInput5,
      );

  Future<void> executeStep(
    TInput1 input1,
    TInput2 input2,
    TInput3 input3,
    TInput4 input4,
    TInput5 input5,
  );
}

/// Class that contains the contextual information when a step is run
/// Provides access to the world, reporter, step configuration and expect functions.
class StepContext<TWorld extends World> {
  final TWorld world;
  final Reporter reporter;
  final StepDefinitionConfiguration configuration;

  StepContext(
    this.world,
    this.reporter,
    this.configuration,
  );

  /// Assert that [actual] matches [matcher], [reason] is optional.
  void expect(
    dynamic actual,
    dynamic matcher, {
    String? reason,
  }) =>
      ExpectMimic().expect(
        actual,
        matcher,
        reason: reason,
      );

  /// Assert that [actual] matches [matcher], [reason] is optional.
  void expectA(
    dynamic actual,
    dynamic matcher, {
    String? reason,
  }) =>
      expect(
        actual,
        matcher,
        reason: reason,
      );

  /// Assert that [actual] matches [matcher], [reason] is optional.
  void expectMatch(
    dynamic actual,
    dynamic matcher, {
    String? reason,
  }) =>
      expect(
        actual,
        matcher,
        reason: reason,
      );
}

class GenericFunctionStepDefinition<TWorld extends World>
    extends StepDefinitionGeneric<TWorld> {
  final Pattern _pattern;
  final Function _onInvoke;
  final int _expectedParameterCount;

  GenericFunctionStepDefinition(
    this._pattern,
    this._onInvoke,
    this._expectedParameterCount, {
    StepDefinitionConfiguration? configuration,
  }) : super(
          configuration,
          _expectedParameterCount,
        );

  @override
  Future<void> onRun(Iterable<dynamic> parameters) {
    var setupConfig = config;

    if (setupConfig == null || setupConfig.timeout == null) {
      setupConfig = (setupConfig ?? StepDefinitionConfiguration())
        ..timeout = timeout;
    }

    final methodParams = [
      ...parameters.take(_expectedParameterCount),
      StepContext<TWorld>(
        world,
        reporter,
        setupConfig,
      ),
    ];
    return Function.apply(_onInvoke, methodParams) as Future<void>;
  }

  @override
  RegExp get pattern =>
      _pattern is RegExp ? _pattern as RegExp : RegExp(_pattern.toString());
}

StepDefinitionGeneric<TWorld>
    step<TWorld extends World, TInput1, TInput2, TInput3, TInput4, TInput5>(
  Pattern pattern,
  int expectedParameterCount,
  Function onInvoke, {
  StepDefinitionConfiguration? configuration,
}) {
  return GenericFunctionStepDefinition<TWorld>(
    pattern,
    onInvoke,
    expectedParameterCount,
    configuration: configuration,
  );
}
