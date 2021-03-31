import './step_configuration.dart';
import './step_definition.dart';
import './step_definition_implementations.dart';
import './world.dart';

abstract class When extends StepDefinition<World> {
  When([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class WhenWithWorld<TWorld extends World>
    extends StepDefinition<TWorld> {
  WhenWithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class When1WithWorld<TInput1, TWorld extends World>
    extends StepDefinition1<TWorld, TInput1> {
  When1WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class When1<TInput1> extends When1WithWorld<TInput1, World> {
  When1([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class When2WithWorld<TInput1, TInput2, TWorld extends World>
    extends StepDefinition2<TWorld, TInput1, TInput2> {
  When2WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class When2<TInput1, TInput2>
    extends When2WithWorld<TInput1, TInput2, World> {
  When2([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class When3WithWorld<TInput1, TInput2, TInput3, TWorld extends World>
    extends StepDefinition3<TWorld, TInput1, TInput2, TInput3> {
  When3WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class When3<TInput1, TInput2, TInput3>
    extends When3WithWorld<TInput1, TInput2, TInput3, World> {
  When3([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class When4WithWorld<TInput1, TInput2, TInput3, TInput4,
        TWorld extends World>
    extends StepDefinition4<TWorld, TInput1, TInput2, TInput3, TInput4> {
  When4WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class When4<TInput1, TInput2, TInput3, TInput4>
    extends When4WithWorld<TInput1, TInput2, TInput3, TInput4, World> {
  When4([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class When5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        TWorld extends World>
    extends StepDefinition5<TWorld, TInput1, TInput2, TInput3, TInput4,
        TInput5> {
  When5WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class When5<TInput1, TInput2, TInput3, TInput4, TInput5>
    extends When5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5, World> {
  When5([StepDefinitionConfiguration? configuration]) : super(configuration);
}

StepDefinitionGeneric<TWorld> when<TWorld extends World>(
  Pattern pattern,
  Future<void> Function(StepContext<TWorld> context) onInvoke, {
  StepDefinitionConfiguration? configuration,
}) =>
    step<TWorld, dynamic, dynamic, dynamic, dynamic, dynamic>(
      pattern,
      0,
      onInvoke,
      configuration: configuration,
    );

StepDefinitionGeneric<TWorld> when1<TInput1, TWorld extends World?>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration? configuration,
}) {
  return step<TWorld, TInput1, dynamic, dynamic, dynamic, dynamic>(
    pattern,
    1,
    onInvoke,
    configuration: configuration,
  );
}

StepDefinitionGeneric<TWorld> when2<TInput1, TInput2, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    TInput2 input2,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration? configuration,
}) =>
    step<TWorld, TInput1, TInput2, dynamic, dynamic, dynamic>(
      pattern,
      2,
      onInvoke,
      configuration: configuration,
    );

StepDefinitionGeneric<TWorld>
    when3<TInput1, TInput2, TInput3, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    TInput2 input2,
    TInput3 input3,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration? configuration,
}) =>
        step<TWorld, TInput1, TInput2, TInput3, dynamic, dynamic>(
          pattern,
          3,
          onInvoke,
          configuration: configuration,
        );

StepDefinitionGeneric<TWorld>
    when4<TInput1, TInput2, TInput3, TInput4, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    TInput2 input2,
    TInput3 input3,
    TInput4 input4,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration? configuration,
}) =>
        step<TWorld, TInput1, TInput2, TInput3, TInput4, dynamic>(
          pattern,
          4,
          onInvoke,
          configuration: configuration,
        );

StepDefinitionGeneric<TWorld>
    when5<TInput1, TInput2, TInput3, TInput4, TInput5, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    TInput1 input2,
    TInput1 input3,
    TInput1 input4,
    TInput1 input5,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration? configuration,
}) =>
        step<TWorld, TInput1, TInput2, TInput3, TInput4, TInput5>(
          pattern,
          5,
          onInvoke,
          configuration: configuration,
        );
